## Context

工程项目模块已经有前后端入口，但旧提案和旧代码都把主表放在 `mat_project`。根据后续迁移盘点，工程项目正确主线应为：

- 历史源表：`test.t_project`
- 当前目标表：`master.t_project`

本设计用于把 `materials-project` 变更本身纠偏。

## Goals / Non-Goals

**Goals**

- 明确工程项目主表为 `master.t_project`
- 明确历史迁移来源为 `test.t_project`
- 保持页面路由和接口路径稳定
- 为后续 `t_project_product`、质量追溯、统计分析提供统一项目主数据

**Non-Goals**

- 本次不新建独立的项目回调变更目录
- 本次不实现质量追溯
- 本次不扩展工程项目之外的新业务能力

## Decisions

### 1. 主表改为 `t_project`

- `MatProject` 实体应映射 `t_project`
- `MatProjectMapper.xml` 的主查询来源应改为 `t_project`
- 所有工程项目 CRUD 均围绕 `t_project`

### 2. 迁移来源改为 `test.t_project`

迁移脚本应完成：

- 业务字段迁移
- `tenant_id` 默认值补齐为 `'000000'`
- `create_dept` 默认值补齐为 `'103'`
- `del_flag` 缺失时补 `0`

### 3. 保持入口稳定

- 页面路径仍为 `materials/project/index`
- 接口路径仍为 `/materials/project`
- 菜单与权限标识保持 `materials:project:*`

## Backend Design

- 控制器：`MatProjectController`
- 服务：`IMatProjectService` / `MatProjectServiceImpl`
- Mapper：`MatProjectMapper` / `MatProjectMapper.xml`
- 实体模型：`MatProject` / `MatProjectBo` / `MatProjectVo`

关键点：

- 主键类型应兼容 `t_project.id` 的真实口径
- 删除条件统一围绕 `del_flag`
- 保留现有查询条件和页面字段，尽量减少前端改动

## Frontend Design

- 保留查询区、列表、详情弹窗、编辑弹窗结构
- 前端不改菜单入口，只适配新的返回字段口径

## Risks / Trade-offs

1. 旧 SQL 文件仍以 `mat_project` 为主，需要后续继续清理或补新 SQL。
2. 当前页面已经接入，回调时要优先兼容字段名，避免前端一起返工。
3. 如果继续沿用 `mat_project`，后续质量追溯和统计模块会建立在错误项目主链上。
