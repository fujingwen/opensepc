## Context

本变更仅聚焦消息中心，数据模型改为按 `test` 旧系统消息表迁移后的模式实现。

数据库核查结论：

- `test.base_message` 只有少量主消息记录，适合做“发送消息”主表
- `test.base_messagereceive` 是旧系统真实收件箱，既承接人工消息，也承接业务自动提醒
- `test.base_message_template` 是模板结构，当前无存量但需要保留迁移能力
- `test.t_message` 是旧系统另一套人工消息表，应在迁移时归并进新的 `master.base_message` / `master.base_message_receive`
- 当前 `master.msg_message` / `master.msg_message_user` 中已有少量新模型试运行数据，正式切换时需要并入迁移目标表

## Goals

- 消息模块底层表模型与 `test` 旧系统保持迁移连续性
- 运行时实现符合旧系统“主消息 + 收件箱”分层，而不是当前 `msg_message/msg_message_user` 的临时模型
- 保持前端 API 和页面交互基本不变，降低回归范围

## Non-Goals

- 本次不扩展消息模板页面能力
- 本次不改变前端消息中心的页面结构和路由

## Table Design

### 1. `master.base_message`

用途：

- 发送消息页的主记录表
- 人工消息和迁移后的旧 `t_message` 主记录统一落这张表

建议字段：

- `id`
- `tenant_id`
- `title`
- `content`
- `message_type`
- `business_type`
- `receiver_user_ids`
- `sender_id`
- `sender_name`
- `priority_level`
- `status`
- `legacy_source`
- `legacy_type`
- `remark`
- `sort_code`
- `enabled_mark`
- `send_time`
- `create_dept/create_by/create_time/update_by/update_time`
- `del_flag`

说明：

- `message_type` 继续保留前端契约，使用 `message` / `warning`
- `business_type` 继续保留前端契约，使用 `manual` / `audit` / `timeout`
- `legacy_source` / `legacy_type` 用于保留旧表来源和旧类型值，支撑迁移追踪

### 2. `master.base_message_receive`

用途：

- 消息查看页的数据来源
- 预警信息页的数据来源
- 业务自动提醒的直接落库表

建议字段：

- `id`
- `tenant_id`
- `message_id`
- `title`
- `content`
- `message_type`
- `business_type`
- `sender_id`
- `sender_name`
- `receiver_user_id`
- `receiver_name`
- `source_business_id`
- `legacy_type`
- `read_status`
- `read_time`
- `read_count`
- `send_time`
- `create_dept/create_by/create_time/update_by/update_time`
- `del_flag`

说明：

- 人工发送消息时：
  - 先写 `base_message`
  - 再按接收人拆分写 `base_message_receive`
- 业务提醒时：
  - 直接写 `base_message_receive`
  - 不强制创建 `base_message`
- `message_id` 仅在收件记录来自人工发送主消息时回填
- `source_business_id` 用于保留业务来源 ID，例如建材产品 ID 或旧系统外部业务消息 ID

### 3. `master.base_message_template`

用途：

- 承接 `test.base_message_template` 结构迁移
- 供未来模板化发送能力复用

当前不接入页面和运行时主流程。

## Legacy Mapping

### `test.base_message -> master.base_message`

映射重点：

- `F_Id -> id`
- `F_Title -> title`
- `F_BodyText -> content`
- `F_ToUserIds -> receiver_user_ids`
- `F_PriorityLevel -> priority_level`
- `F_Type -> legacy_type`
- `F_Description -> remark`
- `F_SortCode -> sort_code`
- `F_EnabledMark -> enabled_mark`
- `F_CreatorUserId -> sender_id`
- `F_CreatorTime -> send_time`
- `F_CreatorTime -> create_time`
- `F_LastModifyTime -> update_time`
- `F_DeleteMark -> del_flag`

归一化规则：

- `message_type = 'message'`
- `business_type = 'manual'`
- `legacy_source = 'test.base_message'`

### `test.t_message -> master.base_message`

映射重点：

- `F_Id -> id`
- `F_Title -> title`
- `F_Content -> content`
- `F_ReceiverId -> receiver_user_ids`
- `F_Status -> status`
- `F_CreatorUserId -> sender_id`
- `F_CreatorTime -> send_time/create_time`

归一化规则：

- `message_type = 'message'`
- `business_type = 'manual'`
- `legacy_source = 'test.t_message'`

### `test.base_messagereceive -> master.base_message_receive`

映射重点：

- `F_Id -> id`
- `F_Title -> title`
- `F_Content -> content`
- `F_SendUser -> sender_id`
- `F_UserId -> receiver_user_id`
- `F_MessageId -> message_id/source_business_id`
- `F_IsRead -> read_status`
- `F_ReadTime -> read_time`
- `F_ReadCount -> read_count`
- `F_Type -> legacy_type`
- `F_CreatorTime -> send_time/create_time`

归一化规则：

- 如果 `F_MessageId` 指向 `test.base_message` 或 `test.t_message`：
  - `message_id = F_MessageId`
  - `message_type = 'message'`
  - `business_type = 'manual'`
- 如果 `F_MessageId` 指向外部业务：
  - `source_business_id = F_MessageId`
  - `message_type = 'warning'`
  - `business_type` 按 `F_Type` 归一到：
    - `5 -> timeout`
    - 其余非人工消息 -> `audit`
- `read_status` 归一为：
  - `0 -> unread`
  - `1 -> read`

### `test.base_message_template -> master.base_message_template`

按字段一一迁移，不参与当前运行时逻辑。

### `master.msg_message -> master.base_message`

映射重点：

- `id::text -> id`
- `title -> title`
- `content -> content`
- `message_type -> message_type`
- `business_type -> business_type`
- `sender_id::text -> sender_id`
- `sender_name -> sender_name`
- `send_time -> send_time`

归一化规则：

- `legacy_source = 'master.msg_message'`
- 若旧值是建材流转提醒类业务编码（如 `mat_product_*`），统一归一到 `message_type='warning'`、`business_type='audit'`
- 其余值保留现有业务语义，超长值在迁移前裁剪到新模型允许范围内

### `master.msg_message_user -> master.base_message_receive`

映射重点：

- `id::text -> id`
- `message_id::text -> message_id`
- `receiver_user_id::text -> receiver_user_id`
- `receiver_name -> receiver_name`
- `read_status -> read_status`
- `read_time -> read_time`
- `create_time -> send_time/create_time`

归一化规则：

- `legacy_source` 通过关联 `message_id` 对应的 `base_message.legacy_source` 间接保留
- `title/content/message_type/business_type/sender_*` 从迁移后的 `base_message` 补齐

## Backend Design

### Message Center

- `MsgMessageController` 接口路径不变
- `MsgMessageServiceImpl` 改为：
  - 发件列表查 `base_message`
  - 收件/预警列表查 `base_message_receive`
  - 消息详情按 `base_message_receive.id` 查询并置已读
  - 人工发送时同时写 `base_message` 和 `base_message_receive`
  - 删除发件时逻辑删除主消息及其关联收件记录

### Materials Notification

- 建材产品待确认、再次确认、超时提醒等业务消息，统一直接写 `base_message_receive`
- 不再写 `msg_message/msg_message_user`

## Frontend Impact

前端页面和 API 保持不变：

- 发送消息页仍使用同一表单
- 消息查看/预警信息页仍展示：
  - 标题
  - 内容
  - 发送人
  - 消息类别
  - 已读状态
  - 发送时间

因此前端仅依赖接口返回结构，无需感知底层表名变化。

## Permission Alignment

### 顶部统一提醒摘要接口权限

- `/message/notification/summary` 的访问控制不能只绑定“消息查看”“预警信息”“公告页面”这些菜单权限。
- 代理商虽然通常不进入完整消息中心页面，但登录后仍需要通过右上角铃铛接收建材产品审核提醒。
- 因此该接口需要额外覆盖代理商现有可用权限标识，保证代理商用户可以访问统一提醒摘要接口。
- 设计目标是“只放开顶部摘要接口”，而不是默认放开代理商对全部消息中心页面和接口的访问权限。

## Risks

1. `test.base_messagereceive` 中存在大量外部业务 `F_MessageId`，不能简单强绑到新主消息表
2. 旧表用户 ID 存在少量非纯数字值，迁移 SQL 需要做兼容处理
3. `t_message` 与 `base_message` 字段结构相近但不完全一致，迁移时需要统一归一到人工消息模型
4. 已经写入 `master.msg_message*` 的试运行数据需要一并迁移，否则切换后消息中心会出现历史数据断层
