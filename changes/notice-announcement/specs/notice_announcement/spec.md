# 通知公告模块规格

## ADDED Requirements

### Requirement: 查看系统公告

企业侧系统 SHALL 允许用户查看系统公告，但不在当前模块维护系统公告。

#### Scenario: 查询系统公告

- **Given** 系统中存在系统公告
- **When** 用户进入系统公告页面并按关键词过滤
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
- **When** 用户填写标题、生产企业和内容并点击“保存草稿”
- **Then** 系统新增或更新一条 `msg_notice_publish`
- **Then** `notice_type` 为 `inventory`
- **Then** `publish_status` 为 `draft`

#### Scenario: 发布库存信息

- **Given** 用户正在编辑一条库存信息草稿
- **When** 用户点击“发布”
- **Then** 系统更新该条公告
- **Then** `publish_status` 为 `published`

### Requirement: 维护采购信息发布

系统 SHALL 允许用户维护采购信息发布公告，并支持草稿到发布流转。

#### Scenario: 保存采购信息草稿

- **Given** 用户进入采购信息发布页面
- **When** 用户填写标题、施工企业和内容并点击“保存草稿”
- **Then** 系统新增或更新一条 `msg_notice_publish`
- **Then** `notice_type` 为 `purchase`
- **Then** `publish_status` 为 `draft`

#### Scenario: 发布采购信息

- **Given** 用户正在编辑一条采购信息草稿
- **When** 用户点击“发布”
- **Then** 系统更新该条公告
- **Then** `publish_status` 为 `published`

### Requirement: 企业上下文自动带出

系统 SHALL 在库存/采购发布页面优先带出当前登录用户所属企业（匹配成功时）。

#### Scenario: 页面自动锁定所属企业

- **Given** 当前登录用户的 `deptName` 能和企业列表匹配
- **When** 用户进入库存信息发布或采购信息发布页面
- **Then** 页面自动回填并锁定对应企业

### Requirement: 页面布局

系统 SHALL 提供与原型一致的三个子页面。

#### Scenario: 通知公告菜单结构

- **Given** 用户拥有通知公告权限
- **When** 系统加载动态菜单
- **Then** 展示 `通知公告`
- **Then** 展示 `系统公告`
- **Then** 展示 `库存信息发布`
- **Then** 展示 `采购信息发布`
