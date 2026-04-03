# 通知公告模块规格

## ADDED Requirements

### Requirement: 维护系统公告

系统 SHALL 允许用户维护系统公告。

#### Scenario: 新建系统公告

- **Given** 用户进入系统公告页面
- **When** 用户填写标题和正文并提交
- **Then** 系统新增一条 `msg_notice_publish`
- **Then** `notice_type` 为 `system`

#### Scenario: 查询系统公告

- **Given** 系统中存在系统公告
- **When** 用户按关键词过滤
- **Then** 系统返回 `notice_type=system` 的公告列表

### Requirement: 维护库存信息发布

系统 SHALL 允许用户维护库存信息发布公告。

#### Scenario: 新建库存信息发布

- **Given** 用户进入库存信息发布页面
- **When** 用户填写标题、生产企业和内容并提交
- **Then** 系统新增一条 `msg_notice_publish`
- **Then** `notice_type` 为 `inventory`

### Requirement: 维护采购信息发布

系统 SHALL 允许用户维护采购信息发布公告。

#### Scenario: 新建采购信息发布

- **Given** 用户进入采购信息发布页面
- **When** 用户填写标题、施工企业和内容并提交
- **Then** 系统新增一条 `msg_notice_publish`
- **Then** `notice_type` 为 `purchase`

### Requirement: 页面布局

系统 SHALL 提供与原型一致的三个子页面。

#### Scenario: 通知公告菜单结构

- **Given** 用户拥有通知公告权限
- **When** 系统加载动态菜单
- **Then** 展示 `通知公告`
- **Then** 展示 `系统公告`
- **Then** 展示 `库存信息发布`
- **Then** 展示 `采购信息发布`
