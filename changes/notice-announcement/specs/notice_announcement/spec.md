# 通知公告模块规格

## ADDED Requirements

### Requirement: 查看系统公告

企业侧系统 SHALL 允许用户查看系统公告，但不在当前模块维护系统公告。

#### Scenario: 查询系统公告

- **Given** 系统中存在系统公告
- **When** 用户进入系统公告页面并按关键字过滤
- **Then** 系统返回 `notice_type=system` 的公告列表

#### Scenario: 查看系统公告详情

- **Given** 用户在系统公告列表中选择一条公告
- **When** 用户打开公告详情
- **Then** 系统展示标题、正文、发布时间和发布状态
- **Then** 页面不提供新增、编辑、删除入口

### Requirement: 维护库存信息发布

系统 SHALL 允许用户维护库存信息发布公告，并支持草稿到发布流转。

#### Scenario: 保存库存信息草稿

- **Given** 用户进入库存信息发布页面
- **When** 用户填写标题和内容并点击“保存草稿”
- **Then** 系统新增或更新一条 `msg_notice_publish`
- **Then** `notice_type` 为 `inventory`
- **Then** `publish_status` 为 `draft`
- **Then** 系统不要求提交 `companyId/companyName`

#### Scenario: 发布库存信息

- **Given** 用户正在编辑一条库存信息草稿
- **When** 用户点击“发布”
- **Then** 系统更新该条公告
- **Then** `publish_status` 为 `published`

#### Scenario: 施工企业查看已发布库存公告

- **Given** 系统中存在已发布的库存公告
- **When** 施工企业用户进入库存信息发布页面
- **Then** 系统返回全部已发布库存公告列表

### Requirement: 维护采购信息发布

系统 SHALL 允许用户维护采购信息发布公告，并支持草稿到发布流转。

#### Scenario: 保存采购信息草稿

- **Given** 用户进入采购信息发布页面
- **When** 用户填写标题和内容并点击“保存草稿”
- **Then** 系统新增或更新一条 `msg_notice_publish`
- **Then** `notice_type` 为 `purchase`
- **Then** `publish_status` 为 `draft`
- **Then** 系统不要求提交 `companyId/companyName`

#### Scenario: 发布采购信息

- **Given** 用户正在编辑一条采购信息草稿
- **When** 用户点击“发布”
- **Then** 系统更新该条公告
- **Then** `publish_status` 为 `published`

#### Scenario: 生产企业查看已发布采购公告

- **Given** 系统中存在已发布的采购公告
- **When** 生产企业用户进入采购信息发布页面
- **Then** 系统返回全部已发布采购公告列表

### Requirement: 发布人可继续维护自己的草稿

系统 SHALL 允许采购/库存公告的发布人继续查看并维护自己创建的草稿。

#### Scenario: 发布人查看自己草稿

- **Given** 用户创建了一条采购或库存草稿
- **When** 用户再次进入对应公告页面
- **Then** 系统返回该用户自己创建的草稿记录

#### Scenario: 已发布公告不可再次修改

- **Given** 一条采购或库存公告已经发布
- **When** 用户尝试再次编辑该公告
- **Then** 系统拒绝修改请求

### Requirement: 页面布局

系统 SHALL 提供与当前菜单结构一致的三个子页面。

#### Scenario: 通知公告菜单结构

- **Given** 用户拥有通知公告权限
- **When** 系统加载动态菜单
- **Then** 展示 `通知公告`
- **Then** 展示 `系统公告`
- **Then** 展示 `库存信息发布`
- **Then** 展示 `采购信息发布`
