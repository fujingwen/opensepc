## Context

本变更基于现有 Spring Boot + Vue 3 项目，新增两个顶层业务模块：

- 消息通知模块
- 通知公告模块

需要满足以下约束：

1. 复用现有权限体系和动态菜单
2. 复用现有富文本组件 `Editor`
3. 复用现有用户选择组件 `UserSelect`
4. 数据库使用 PostgreSQL `master` schema
5. 所有业务表包含 `tenant_id`、审计字段、逻辑删除字段

## Goals / Non-Goals

**Goals**

- 建立消息发送、消息接收、预警查看三类站内消息能力
- 建立系统公告、库存信息发布、采购信息发布三类公告能力
- 落地菜单、字典、数据库表、后端 API、前端页面
- 页面布局尽量贴近原型图

**Non-Goals**

- 本次不实现“审核状态变化自动发预警”与“超48小时自动提醒”定时任务
- 本次不迁移旧 `test` 消息数据
- 本次不实现消息附件上传

## Decisions

### 1. 模块拆分

采用两个顶层模块：

- `消息中心`
  - 发送消息
  - 消息查看
  - 预警信息
- `通知公告`
  - 系统公告
  - 库存信息发布
  - 采购信息发布

### 2. 数据模型设计

#### 2.1 站内消息主表 `master.msg_message`

用途：

- 保存消息主体
- 区分普通消息与预警消息

关键字段：

- `id`: 主键
- `tenant_id`: 租户编号
- `title`: 标题
- `content`: 内容
- `message_type`: `message` / `warning`
- `business_type`: `manual` / `audit` / `timeout`
- `sender_id`
- `sender_name`
- `send_time`
- `del_flag`
- `create_dept/create_by/create_time/update_by/update_time`

#### 2.2 站内消息接收表 `master.msg_message_user`

用途：

- 保存消息与接收用户的关系
- 记录已读状态

关键字段：

- `id`
- `tenant_id`
- `message_id`
- `receiver_user_id`
- `receiver_name`
- `read_status`
- `read_time`
- `del_flag`
- `create_dept/create_by/create_time/update_by/update_time`

#### 2.3 通知公告表 `master.msg_notice_publish`

用途：

- 统一承载系统公告、库存信息发布、采购信息发布

关键字段：

- `id`
- `tenant_id`
- `notice_type`: `system` / `inventory` / `purchase`
- `title`
- `content`
- `publisher_user_id`
- `publisher_name`
- `company_id`
- `company_name`
- `publish_status`
- `publish_time`
- `del_flag`
- `create_dept/create_by/create_time/update_by/update_time`

### 3. 企业公告建模

库存信息发布、采购信息发布需要企业维度，因此不继续复用现有 `sys_notice`，而是统一使用 `msg_notice_publish`：

- `system` 类型：`company_id/company_name` 可为空
- `inventory` 类型：关联生产企业
- `purchase` 类型：关联施工企业

这样可以统一列表和表单结构，也更贴近原型。

### 4. 页面形态

四类页面采用“列表页 + 内嵌表单态”的扁平分页模板：

- 发送消息
- 系统公告
- 库存信息发布
- 采购信息发布

两个只读列表页：

- 消息查看
- 预警信息

设计原因：

- 与原型“列表页切入新建页”的交互相近
- 无需单独配置静态路由
- 更适配当前动态菜单模式

### 5. 收件人选择

发送消息复用 `components/UserSelect`：

- 支持多选
- 返回 `userId/userName` 列表
- 保存时拆成接收表记录

### 6. 富文本编辑器

消息内容和公告正文统一复用全局 `Editor` 组件。

### 7. 权限设计

#### 7.1 消息通知模块

- `message:send:list`
- `message:send:query`
- `message:send:add`
- `message:send:remove`
- `message:receive:list`
- `message:receive:query`
- `message:warning:list`
- `message:warning:query`

#### 7.2 通知公告模块

- `notice:system:list`
- `notice:system:query`
- `notice:system:add`
- `notice:system:remove`
- `notice:inventory:list`
- `notice:inventory:query`
- `notice:inventory:add`
- `notice:inventory:remove`
- `notice:purchase:list`
- `notice:purchase:query`
- `notice:purchase:add`
- `notice:purchase:remove`

### 8. 数据字典

新增字典：

- `msg_message_type`
- `msg_business_type`
- `msg_read_status`
- `msg_notice_type`
- `msg_publish_status`

## Backend Design

### 1. 消息通知

- `MsgMessageController`
  - `GET /message/send/list`
  - `GET /message/receive/list`
  - `GET /message/warning/list`
  - `GET /message/{id}`
  - `POST /message`
  - `DELETE /message/{ids}`
  - `PUT /message/read/{id}`
- `IMsgMessageService` / `MsgMessageServiceImpl`
- `MsgMessageMapper` + XML

查询策略：

- 发送消息：按 `msg_message.sender_id`
- 消息查看：按 `msg_message_user.receiver_user_id` 且 `message_type=message`
- 预警信息：按 `msg_message_user.receiver_user_id` 且 `message_type=warning`

### 2. 通知公告

- `MsgNoticePublishController`
  - `GET /notice/publish/list`
  - `GET /notice/publish/{id}`
  - `POST /notice/publish`
  - `PUT /notice/publish`
  - `DELETE /notice/publish/{ids}`
- `IMsgNoticePublishService` / `MsgNoticePublishServiceImpl`
- `MsgNoticePublishMapper` + XML

列表通过 `noticeType` 参数区分三类公告。

## Frontend Design

### 1. 消息通知模块页面

- `views/message/send/index.vue`
- `views/message/receive/index.vue`
- `views/message/warning/index.vue`

#### 发送消息页

- 列表态
  - 搜索条件：标题、接收人、发送时间范围
  - 列表字段：标题、内容、创建时间
- 表单态
  - 标题
  - 接收人
  - 消息内容
  - 用户选择弹窗

#### 消息查看页

- 搜索条件：标题、发送人、发送时间范围
- 列表字段：标题、内容、发送人、创建时间、已读状态
- 操作：查看

#### 预警信息页

- 搜索条件：发送人、发送时间范围、消息类别
- 列表字段：标题、内容、发送人、发送时间、消息类别、已读状态
- 操作：查看

### 2. 通知公告模块页面

- `views/notice/system/index.vue`
- `views/notice/inventory/index.vue`
- `views/notice/purchase/index.vue`

三者共用一套布局，按 `noticeType` 区分：

- `system`
- `inventory`
- `purchase`

系统公告表单：

- 标题
- 正文

库存/采购发布表单：

- 标题名称
- 对应企业
- 内容

## SQL Design

### 1. 执行顺序

1. `sql/sequences/base_sequences.sql`
2. `sql/tables/base_msg_message.sql`
3. `sql/tables/base_msg_message_user.sql`
4. `sql/tables/base_msg_notice_publish.sql`
5. `sql/indexes/base_indexes.sql`
6. `sql/dict/base_dict.sql`
7. `sql/menu/base_menu.sql`

### 2. 菜单设计

新增两个顶级菜单：

- `消息中心`
- `通知公告`

并挂接 6 个子页面和对应按钮权限。

## Risks / Trade-offs

1. `UserSelect` 当前返回完整用户对象数组，发送消息保存时需要做额外转换
2. 预警自动生成逻辑暂未实现，本次只先落页面和数据模型
3. 通知公告统一进新表后，与历史 `sys_notice` 数据不会自动合并
