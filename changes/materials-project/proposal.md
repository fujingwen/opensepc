## Why

`materials-project` 原提案把工程项目主表设计成了 `master.mat_project`，但后续数据库盘点和代码回调分析已经确认这个方向不对：

- 真实历史数据来源是 `test.t_project`
- 后续正确承载表应为 `master.t_project`
- 质量追溯、统计分析等后续模块都依赖 `t_project`

因此本提案需要原地修正，不再继续以 `mat_project` 为依据。

## What Changes

- 将工程项目主表从 `mat_project` 修正为 `t_project`
- 补充 `test.t_project -> master.t_project` 的迁移要求
- 保持现有业务入口不变：
  - 页面入口 `materials/project/index`
  - 接口入口 `/materials/project`
- 要求后端查询、详情、新增、编辑、删除统一围绕 `t_project`
- 作为后续建材产品、质量追溯、统计分析的前置主数据能力

## Capabilities

### New Capabilities

- `materials_project`
  - 基于 `master.t_project` 提供工程项目查询、详情、维护能力
  - 支持从 `test.t_project` 迁移历史数据

### Capability Details

- 查询条件
  - 工程名称
  - 施工许可证
  - 工程进度
  - 质量监督机构
  - 施工单位
  - 有无填报
  - 是否对接一体化平台编码
- 列表字段
  - 工程名称
  - 施工许可证
  - 工程进度
  - 施工单位
  - 有无填报
  - 是否对接一体化平台编码
  - 创建时间
- 维护约束
  - 底层读写表必须为 `t_project`
  - 逻辑删除字段统一使用 `del_flag`
  - 补齐 `tenant_id`、`create_dept`、审计字段

## Impact

- OpenSpec
  - `openspec/changes/materials-project/proposal.md`
  - `openspec/changes/materials-project/design.md`
  - `openspec/changes/materials-project/tasks.md`
  - `openspec/changes/materials-project/specs/materials_project/spec.md`
- SQL
  - 现有 `mat_project` 方向 SQL 不再作为继续开发依据
  - 应补充 `t_project` 建表与迁移 SQL
- Backend
  - `MatProjectController`
  - `IMatProjectService`
  - `MatProjectServiceImpl`
  - `MatProjectMapper`
  - `MatProjectMapper.xml`
  - `MatProject` / `MatProjectBo` / `MatProjectVo`
- Frontend
  - `construction-material-web/src/views/materials/project/index.vue`
  - `construction-material-web/src/api/materials/project.js`
