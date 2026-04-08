# 消息通知模块规格

## ADDED Requirements

### Requirement: 发送站内消息

系统 SHALL 允许用户向一个或多个系统用户发送站内消息。

#### Scenario: 新建发送消息

- **Given** 用户进入发送消息页面
- **When** 用户填写标题、接收人和消息内容并提交
- **Then** 系统创建一条 `base_message`
- **Then** 系统按接收人拆分创建多条 `base_message_receive`
- **Then** 主消息和收件记录的 `message_type` 均为 `message`
- **Then** `business_type` 为 `manual`

#### Scenario: 查询已发送消息

- **Given** 用户已发送过消息
- **When** 用户按标题、接收人或发送时间过滤
- **Then** 系统返回当前登录用户发送的主消息列表
- **Then** 接收人名称通过关联 `base_message_receive` 聚合展示

### Requirement: 查看接收消息

系统 SHALL 允许用户查看发送给自己的站内消息。

#### Scenario: 查询接收消息

- **Given** 当前用户存在接收消息
- **When** 用户进入消息查看页面
- **Then** 系统返回当前用户在 `base_message_receive` 中 `message_type=message` 的收件记录

#### Scenario: 查看消息详情并标记已读

- **Given** 当前用户存在一条未读收件记录
- **When** 用户打开消息详情
- **Then** 系统按收件记录 ID 查询详情
- **Then** 系统将该收件记录标记为已读

### Requirement: 查看预警信息

系统 SHALL 允许用户查看发送给自己的预警信息。

#### Scenario: 查询预警列表

- **Given** 当前用户存在预警信息
- **When** 用户按发送人、发送时间、消息类别过滤
- **Then** 系统返回当前用户在 `base_message_receive` 中 `message_type=warning` 的收件记录

#### Scenario: 业务提醒直接进入收件箱

- **Given** 业务模块产生自动提醒
- **When** 系统写入消息
- **Then** 系统直接写入 `base_message_receive`
- **Then** 不强制要求存在对应 `base_message` 主记录

### Requirement: 统一提醒入口

系统 SHALL 提供基于真实消息和已发布公告的统一提醒入口。

#### Scenario: 查询顶部提醒摘要

- **Given** 当前用户存在消息或有权限查看已发布公告
- **When** 前端调用 `/message/notification/summary`
- **Then** 系统返回当前用户消息未读数
- **Then** 系统返回最近消息和有权限查看的已发布公告混合列表

#### Scenario: 批量标记消息已读

- **Given** 当前用户进入统一提醒入口
- **When** 用户点击“全部已读”
- **Then** 系统批量更新当前用户 `base_message_receive` 中的未读消息为已读
- **Then** 当当前用户没有未读消息时接口仍返回成功

#### Scenario: 业务提醒跳转建材产品页

- **Given** 当前用户收到 `message_type=warning` 且 `business_type` 为 `audit` 或 `timeout` 的提醒
- **When** 用户在统一提醒入口或消息详情中点击“去处理”
- **Then** 前端跳转到 `/materials/product?messageBusinessId={source_business_id}`

### Requirement: 兼容旧系统消息迁移

系统 SHALL 支持从 `test` 旧消息表迁移到 `master` 新表模型。

#### Scenario: 迁移 `base_message`

- **Given** 旧系统存在 `test.base_message`
- **When** 执行迁移脚本
- **Then** 旧表主消息迁移到 `master.base_message`

#### Scenario: 迁移 `base_messagereceive`

- **Given** 旧系统存在 `test.base_messagereceive`
- **When** 执行迁移脚本
- **Then** 旧表收件记录迁移到 `master.base_message_receive`
- **Then** 若旧 `F_MessageId` 指向外部业务，则保留到 `source_business_id`

#### Scenario: 迁移 `t_message`

- **Given** 旧系统存在 `test.t_message`
- **When** 执行迁移脚本
- **Then** 旧表人工消息归并到 `master.base_message`
- **Then** 按接收人拆分补充 `master.base_message_receive`

#### Scenario: 迁移当前 `master.msg_message`

- **Given** 当前系统已经存在 `master.msg_message` / `master.msg_message_user` 存量数据
- **When** 执行迁移脚本
- **Then** 现有主消息归并到 `master.base_message`
- **Then** 现有收件记录归并到 `master.base_message_receive`
