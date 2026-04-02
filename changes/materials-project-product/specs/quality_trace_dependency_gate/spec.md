# 质量追溯依赖门槛规格

## ADDED Requirements

### Requirement: 质量追溯四页依赖项目与产品主链路

系统 SHALL 在质量追溯模块实现前先完成工程项目与建材产品主链路回调。

#### Scenario: 进入质量追溯第二阶段

- **Given** 计划实现质量追溯四个页面
- **When** 团队评审实现前置条件
- **Then** 必须先确认 `master.t_project` 已启用
- **Then** 必须先确认建材产品能力已统一到 `master.t_project_product`

### Requirement: 缺陷建材使用情况页不得绕过前置表关系

系统 SHALL 基于“项目 -> 产品 -> 质量追溯”的主链路实现缺陷建材使用情况页。

#### Scenario: 设计缺陷建材使用情况页

- **Given** 团队开始设计缺陷建材使用情况页
- **When** 确认数据来源
- **Then** 页面关系链应建立在 `t_project`、`t_project_product`、`t_quality_trace`
- **Then** 不得再偏离 `t_project` 或 `t_project_product` 这条主关系链
