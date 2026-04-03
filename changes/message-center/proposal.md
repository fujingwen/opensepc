## Why

当前 `message-center-notice` 聚焦消息中心能力，消息部分此前使用的是 `master.msg_message` / `master.msg_message_user` 新模型。

但数据库核查结果表明，旧系统 `test` schema 下真实的消息能力并不是这一套：

- `test.base_message` 主要承载人工发送或平台类消息主记录
- `test.base_messagereceive` 是真实的收件箱/预警落库表，数量远大于 `base_message`
- `test.base_message_template` 是模板表
- `test.t_message` 是另一套较轻量的人工消息表，字段和“发送消息”场景高度相似

进一步核查发现：

1. `test.base_messagereceive` 并不只是 `base_message` 的从表，绝大多数记录的 `F_MessageId` 指向外部业务消息 ID
2. 当前建材产品流转产生的待确认提醒、超时提醒、确认成功/失败提醒，本质上更接近旧系统的 `base_messagereceive` 模式，而不是“主表 + 接收关系表”的纯手工消息模式
3. 如果继续沿用 `msg_message` / `msg_message_user` 方案，会和旧系统数据迁移方向、历史语义以及现有业务提醒生成方式长期不一致
4. 当前 `master.msg_message` / `master.msg_message_user` 中已经存在少量运行时消息，如果切换时不做兼容迁移，会造成新旧实现断档

因此，本次变更需要把消息模块改为“按 `test` 旧表迁移后的模型实现”，并同步修订提案、SQL 和后端代码。

## What Changes

- 将消息中心的数据模型从：
  - `master.msg_message`
  - `master.msg_message_user`
  调整为：
  - `master.base_message`
  - `master.base_message_receive`
  - `master.base_message_template`
- 新增 `sql/migrate` 迁移脚本，明确从 `test.base_message` / `test.base_messagereceive` / `test.base_message_template` / `test.t_message` 到 `master` 的映射规则，并兼容吸收现有 `master.msg_message` / `master.msg_message_user` 存量数据；旧的建材流转提醒编码统一归一到 `warning/audit`
- 保持消息中心前端页面、接口路径和交互基本不变，但后端实现切换为迁移后的表模型
- 将建材产品流转通知从直接写 `msg_message` 切换为直接写 `base_message_receive`

## Capabilities

### Message Center

- 发送消息
  - 发送时写入 `master.base_message`
  - 同时按接收人拆分写入 `master.base_message_receive`
- 消息查看
  - 直接基于 `master.base_message_receive` 查询当前用户收件箱
- 预警信息
  - 直接基于 `master.base_message_receive` 查询当前用户预警记录
- 消息已读
  - 直接更新 `master.base_message_receive.read_status/read_time`

## Data Model Direction

### 1. `master.base_message`

对应旧表：

- `test.base_message`
- `test.t_message` 中的人工发送主消息
- 当前 `master.msg_message` 中尚未清退的人工消息

角色：

- 承载“发送消息”页的发件主记录
- 保存发送人、接收人集合、标题、正文等主数据

### 2. `master.base_message_receive`

对应旧表：

- `test.base_messagereceive`
- `test.t_message` 拆分后的收件记录
- 当前 `master.msg_message_user` 中尚未清退的收件记录

角色：

- 承载“消息查看”和“预警信息”页的真实收件箱数据
- 承载业务模块自动生成的提醒消息
- 保存已读状态、阅读时间、接收人、业务分类等信息

### 3. `master.base_message_template`

对应旧表：

- `test.base_message_template`

角色：

- 先完成结构迁移
- 本次页面能力不直接使用模板表

## Compatibility

- 前端 API 仍保持：
  - `GET /message/send/list`
  - `GET /message/receive/list`
  - `GET /message/warning/list`
  - `GET /message/{id}`
  - `POST /message`
  - `DELETE /message/{ids}`
  - `PUT /message/read/{id}`
- 前端页面字段仍保持：
  - `title`
  - `content`
  - `senderName`
  - `receiverNames`
  - `businessType`
  - `readStatus`
  - `sendTime`

也就是说，迁移的是底层表模型和后端实现方式，不是前端页面契约。

## Manual Alignment

对照《青岛市建设工程材料信息管理平台操作手册》，本提案虽然已经完成消息表模型切换，但还有两项手册级交互尚未落地：

- 顶部铃铛未读数应来自真实消息/公告数据源，而不是前端本地临时状态。
- 建材产品审核类业务消息点击后应支持跳转到建材产品列表，而不是始终停留在详情弹窗。

## Impact

- OpenSpec
  - `openspec/changes/message-center-notice/.openspec.yaml`
  - `openspec/changes/message-center-notice/proposal.md`
  - `openspec/changes/message-center-notice/design.md`
  - `openspec/changes/message-center-notice/issues.md`
  - `openspec/changes/message-center-notice/tasks.md`
  - `openspec/changes/message-center-notice/specs/message_center/spec.md`
- SQL
  - `openspec/changes/message-center-notice/sql/tables/**`
  - `openspec/changes/message-center-notice/sql/indexes/base_indexes.sql`
  - `openspec/changes/message-center-notice/sql/sequences/base_sequences.sql`
  - `openspec/changes/message-center-notice/sql/migrate/**`
- Backend
  - `construction-material-backend/hny-modules/hny-system/**/MsgMessage*`
  - `construction-material-backend/hny-modules/hny-materials/**/ProductFlowMessage*`
  - `construction-material-backend/hny-modules/hny-materials/**/MatProductServiceImpl.java`
