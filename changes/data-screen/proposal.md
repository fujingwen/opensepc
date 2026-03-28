## Why

当前仓库已经补齐了统计中心的基础查询口径，但“数据大屏”仍然缺位，现网原型中的几个关键展示还没有承载：

- 项目总量、填报量、备案量、企业量等汇总卡片
- 信息确认率 / 审核通过率环形指标
- 各区市项目分布地图
- 各区市建材产品填报数量、产品类别数量、月度趋势图
- 最近填报审核列表、缺陷建材滚动列表

在核对数据库后，现状是：

- `master.t_project_product` 已经是建材填报主链
- `master.t_record_product` 已承载备案产品
- `master.base_region` / `master.base_dictionarytype` 可以支撑区市与产品类别口径
- `master.t_project` 与 `master.t_quality_trace` 还没有落到运行库，需要先迁移

如果继续只做页面而不先补齐运行表，数据大屏会落到 `test.*` 表或错误链路上，后续统计中心、质量追溯和大屏会出现口径分裂。因此需要新增一个独立 OpenSpec 变更，把数据大屏和它依赖的运行库迁移一起完成。

## What Changes

- 新建 `data-screen` 变更
- 新增 `数据大屏` 菜单与访问权限
- 新增数据大屏只读聚合接口
  - 汇总卡片
  - 信息确认率 / 审核通过率
  - 各区市项目总数 / 参与项目数
  - 各区市建材填报数量
  - 各产品类别填报数量
  - 各产品类别近 12 个月趋势
  - 最近项目填报审核列表
  - 最近缺陷建材列表
- 新增 `master.t_project` 运行表建表与 `test.t_project -> master.t_project` 迁移 SQL
- 新增 `master.t_quality_trace` 运行表建表与 `test.t_quality_trace -> master.t_quality_trace` 迁移 SQL
- 新增前端数据大屏页面，地图使用 L7，并内置青岛 GeoJSON 边界数据

## Capabilities

### New Capabilities

- `data_screen`
  - 以 `master.t_project_product` 为核心口径展示项目建材填报总览
  - 以 `master.t_project` 为项目维度补齐区市地图和项目总量
  - 以 `master.t_quality_trace` 展示最新缺陷建材榜单

### Capability Details

#### 1. 汇总卡片与指标

- 页面入口
  - `数据大屏 / 建材数据大屏`
- 汇总卡片
  - 已填报项目总数 / 项目总数
  - 已填报建材产品总数
  - 备案产品总数
  - 施工企业数
  - 生产单位数
- 环形指标
  - 信息确认率
  - 审核通过率

#### 2. 区市地图与图表

- 地图
  - 使用 L7 渲染青岛市区县边界
  - 展示各区市项目总数与参与项目数
- 图表
  - 各区市建材产品填报数量
  - 各产品类别填报数量
  - 各产品类别近 12 个月填报趋势

#### 3. 滚动榜单

- 最近项目填报审核列表
  - 项目名称
  - 填报材料
  - 备案证号
  - 审核状态
- 最近缺陷建材列表
  - 缺陷建材产品
  - 批号
  - 生产厂家
  - 使用项目

## Impact

- OpenSpec
  - `openspec/changes/data-screen/.openspec.yaml`
  - `openspec/changes/data-screen/proposal.md`
  - `openspec/changes/data-screen/design.md`
  - `openspec/changes/data-screen/tasks.md`
  - `openspec/changes/data-screen/specs/data_screen/spec.md`
- SQL
  - `openspec/changes/data-screen/sql/menu/base_menu.sql`
  - `openspec/changes/data-screen/sql/tables/base_t_project.sql`
  - `openspec/changes/data-screen/sql/migrate/migrate_t_project.sql`
  - `openspec/changes/data-screen/sql/tables/base_t_quality_trace.sql`
  - `openspec/changes/data-screen/sql/migrate/migrate_t_quality_trace.sql`
- Backend
  - `MatDashboardController`
  - `IMatDashboardService`
  - `MatDashboardServiceImpl`
  - `MatDashboardMapper`
  - `MatDashboardMapper.xml`
  - 相关 dashboard vo
- Frontend
  - `construction-material-web/src/api/dashboard/materials.js`
  - `construction-material-web/src/views/dashboard/materials/index.vue`
  - `construction-material-web/src/assets/geo/qingdao.json`
  - `construction-material-web/package.json`
