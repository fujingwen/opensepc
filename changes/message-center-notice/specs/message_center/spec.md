# 消息通知模块规格

## ADDED Requirements

### Requirement: 发送站内消息

系统 SHALL 允许用户向一个或多个系统用户发送站内消息。

#### Scenario: 新建发送消息

- **Given** 用户进入发送消息页面
- **When** 用户填写标题、接收人和消息内容并提交
- **Then** 系统创建一条 `msg_message`
- **Then** 系统按接收人拆分创建多条 `msg_message_user`
- **Then** 消息类型为 `message`

#### Scenario: 查询已发送消息

- **Given** 用户已发送过消息
- **When** 用户按标题、接收人或发送时间过滤
- **Then** 系统返回当前登录用户发送的消息列表

### Requirement: 查看接收消息

系统 SHALL 允许用户查看发给自己的站内消息。

#### Scenario: 查询接收消息

- **Given** 当前用户有接收消息
- **When** 用户进入消息查看页面
- **Then** 系统返回当前用户接收的 `message` 类型消息

#### Scenario: 查看消息详情并标记已读

- **Given** 当前用户存在一条未读消息
- **When** 用户打开消息详情
- **Then** 系统将对应接收记录标记为已读

### Requirement: 查看预警信息

系统 SHALL 允许用户查看发送给自己的预警信息。

#### Scenario: 查询预警列表

- **Given** 当前用户存在预警信息
- **When** 用户按发送人、发送时间、消息类别过滤
- **Then** 系统返回当前用户接收的 `warning` 类型消息

### Requirement: 页面布局

系统 SHALL 提供与原型一致的三个子页面。

#### Scenario: 消息中心菜单结构

- **Given** 用户拥有消息中心权限
- **When** 系统加载动态菜单
- **Then** 展示 `消息中心`
- **Then** 展示 `发送消息`
- **Then** 展示 `消息查看`
- **Then** 展示 `预警信息`
