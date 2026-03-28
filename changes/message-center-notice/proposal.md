## Why

当前系统只有基础的 `sys_notice` 公告能力，缺少与原型一致的两类完整业务模块：

- 消息通知模块：发送消息、消息查看、预警信息
- 通知公告模块：系统公告、库存信息发布、采购信息发布

现状问题有三类：

1. 旧系统的消息相关数据还停留在 `test.t_message`、`test.base_message`、`test.base_messagereceive`
2. 新系统没有正式的消息中心页面、收件人选择发送能力、预警列表能力
3. 通知公告只有通用 `sys_notice`，无法覆盖库存信息发布、采购信息发布这类带企业维度的公告

因此需要新增一个统一的 OpenSpec 变更，把消息通知与通知公告拆成两个顶层模块，统一落地数据库、菜单、后端接口和前端页面。

## What Changes

- 新建 `message-center-notice` 变更
- 新增消息通知模块
  - 发送消息
  - 消息查看
  - 预警信息
- 新增通知公告模块
  - 系统公告
  - 库存信息发布
  - 采购信息发布
- 新增三张业务表
  - `master.msg_message`
  - `master.msg_message_user`
  - `master.msg_notice_publish`
- 新增字典、菜单、索引、序列 SQL
- 新增后端 Controller / Service / Mapper / Domain / Vo / Bo
- 新增前端 API 与 6 个页面

## Capabilities

### New Capabilities

- `message_center`
  - 发送站内消息给一个或多个用户
  - 查询当前用户已发送消息
  - 查询当前用户已接收消息
  - 查询当前用户预警信息
  - 查看消息详情并支持接收消息已读
- `notice_announcement`
  - 维护系统公告
  - 维护库存信息发布
  - 维护采购信息发布
  - 按标题、发布主体、发布时间过滤公告

### Capability Details

#### 1. 消息通知模块

- 页面结构
  - `消息中心`
    - `发送消息`
    - `消息查看`
    - `预警信息`
- 发送消息页
  - 查询条件：标题、接收人、发送时间范围
  - 列表字段：标题、内容摘要、创建时间
  - 操作：新增、查看、删除
  - 表单字段：标题、接收人、消息内容
  - 接收人选择：复用现有 `UserSelect`
- 消息查看页
  - 查询条件：标题、发送人、发送时间范围
  - 列表字段：标题、内容摘要、发送人、创建时间、已读状态
  - 操作：查看
- 预警信息页
  - 查询条件：发送人、发送时间范围、消息类别
  - 列表字段：标题、内容摘要、发送人、发送时间、消息类别、已读状态
  - 操作：查看

#### 2. 通知公告模块

- 页面结构
  - `通知公告`
    - `系统公告`
    - `库存信息发布`
    - `采购信息发布`
- 系统公告页
  - 查询条件：关键词
  - 列表字段：标题、发布人员、发布时间、状态
  - 操作：新增、查看、删除
- 库存信息发布页
  - 查询条件：标题名称、生产企业、发布时间范围
  - 列表字段：标题、内容摘要、生产企业名称、发布时间、发布状态
  - 操作：新增、查看、删除
- 采购信息发布页
  - 查询条件：标题名称、施工企业、发布时间范围
  - 列表字段：标题、内容摘要、施工企业名称、发布时间、发布状态
  - 操作：新增、查看、删除

## Impact

- OpenSpec
  - `openspec/changes/message-center-notice/.openspec.yaml`
  - `openspec/changes/message-center-notice/proposal.md`
  - `openspec/changes/message-center-notice/design.md`
  - `openspec/changes/message-center-notice/tasks.md`
  - `openspec/changes/message-center-notice/issues.md`
  - `openspec/changes/message-center-notice/specs/message_center/spec.md`
  - `openspec/changes/message-center-notice/specs/notice_announcement/spec.md`
- SQL
  - `openspec/changes/message-center-notice/sql/sequences/base_sequences.sql`
  - `openspec/changes/message-center-notice/sql/tables/base_msg_message.sql`
  - `openspec/changes/message-center-notice/sql/tables/base_msg_message_user.sql`
  - `openspec/changes/message-center-notice/sql/tables/base_msg_notice_publish.sql`
  - `openspec/changes/message-center-notice/sql/indexes/base_indexes.sql`
  - `openspec/changes/message-center-notice/sql/dict/base_dict.sql`
  - `openspec/changes/message-center-notice/sql/menu/base_menu.sql`
- Backend
  - `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/MsgMessageController.java`
  - `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/MsgNoticePublishController.java`
  - 相关 domain / bo / vo / mapper / service 文件
- Frontend
  - `construction-material-web/src/api/message/message.js`
  - `construction-material-web/src/api/notice/publish.js`
  - `construction-material-web/src/views/message/send/index.vue`
  - `construction-material-web/src/views/message/receive/index.vue`
  - `construction-material-web/src/views/message/warning/index.vue`
  - `construction-material-web/src/views/notice/system/index.vue`
  - `construction-material-web/src/views/notice/inventory/index.vue`
  - `construction-material-web/src/views/notice/purchase/index.vue`
