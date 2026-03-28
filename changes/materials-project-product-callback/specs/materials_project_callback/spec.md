# 工程项目回调规格

## ADDED Requirements

### Requirement: 工程项目主表统一到 `t_project`

系统 SHALL 使用 `master.t_project` 作为工程项目主承载表，而不是继续使用 `master.mat_project`。

#### Scenario: 查询工程项目列表

- **Given** 用户进入工程项目页面
- **When** 系统执行工程项目分页查询
- **Then** 数据来源应为 `master.t_project`
- **Then** 系统应过滤逻辑删除数据

#### Scenario: 维护工程项目

- **Given** 用户拥有工程项目维护权限
- **When** 用户新增、编辑或删除工程项目
- **Then** 系统应读写 `master.t_project`

### Requirement: 工程项目数据从 `test.t_project` 迁移

系统 SHALL 支持将历史工程项目数据从 `test.t_project` 迁移到 `master.t_project`。

#### Scenario: 执行迁移

- **Given** `test.t_project` 中存在历史工程项目数据
- **When** 执行迁移脚本
- **Then** 系统应将业务字段写入 `master.t_project`
- **Then** 系统应补齐 `tenant_id`、`create_dept`、`del_flag`
