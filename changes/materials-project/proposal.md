## Why

工程项目管理页面需要完成以下工作：
- 主表使用 `t_project`
- 历史数据从 `test.t_project` 迁移到 `master.t_project`
- 字典数据迁移（旧字典ID映射为新短编码）
- 一体化工程编码下拉选择（数据源 `jck_t_gc_sgxkz`）
- 新增/编辑表单字段调整
- 列表操作按钮调整（导出功能）

本提案从 `materials-project-product-callback` 拆分，独立管理工程项目页面。

## Supersedes

- 整合自 `materials-project-product-callback` 中的工程项目部分

## What Changes

- 工程项目主链路基于 `master.t_project`
- 一体化工程编码下拉选择器（打开 dialog 时立即加载列表）
- 新增表单：施工许可证和发证日期非必填，有无填报和对接状态字段不显示
- 操作按钮：移除批量删除，新增导出和导出已开工未填报项目表
- 列表字段补全，施工单位显示名称（LEFT JOIN t_companyinfo）

## Capabilities

### New Capabilities

- `materials_project_callback`
  - 系统可基于 `master.t_project` 提供工程项目 CRUD 能力
  - 系统可从 `test.t_project` 将历史数据迁移到 `master.t_project`
- `materials_project_integrated_code`
  - 系统可在新增/编辑时通过下拉选择关联一体化工程编码
  - 数据来源：`master.jck_t_gc_sgxkz`
  - 打开新增 dialog 时立即加载列表，支持按施工许可证号或工程名称搜索
  - 选中后自动填充施工许可证和对接状态
- `materials_project_export`
  - 系统可导出工程项目列表
  - 系统可导出已开工未填报项目表（排除施工前准备和土方开挖阶段）

## Impact

- OpenSpec
  - `openspec/changes/materials-project/` 全部文件
- SQL
  - `openspec/changes/materials-project-product-callback/sql/tables/base_t_project.sql`
  - `openspec/changes/materials-project-product-callback/sql/migrate/migrate_t_project.sql`
  - `openspec/changes/materials-project-product-callback/sql/migrate/migrate_dict_values_in_t_project.sql`
- Backend
  - `construction-material-backend/.../controller/MatProjectController.java`
  - `construction-material-backend/.../domain/MatProject.java`
  - `construction-material-backend/.../domain/vo/MatProjectVo.java`
  - `construction-material-backend/.../mapper/MatProjectMapper.java`
  - `construction-material-backend/.../mapper/MatProjectMapper.xml`
  - `construction-material-backend/.../service/IMatProjectService.java`
  - `construction-material-backend/.../service/impl/MatProjectServiceImpl.java`
- Frontend
  - `construction-material-web/src/views/materials/project/index.vue`
  - `construction-material-web/src/api/materials/project.js`
