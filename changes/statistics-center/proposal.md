## Why

当前系统已经具备统计中心所需的主数据基础，但还没有正式的统计页面与接口：

- 工程项目已回调到 `master.t_project`
- 建材产品主链已明确为 `master.t_project_product`
- 企业归属和生产地信息可通过 `master.t_companyinfo` 解释

原型中已经明确存在两个统计中心页面：

1. `统计分析`
2. `采购价格分析`

如果继续缺少统计层实现，后续质量追溯、大屏展示、价格横向比对都会缺少统一查询口径。因此需要新增一个独立 OpenSpec 变更，把统计中心模块完整落地。

## What Changes

- 新建 `statistics-center` 变更
- 新增 `统计中心` 顶层菜单
  - `统计分析`
  - `采购价格分析`
- 新增统计中心只读查询接口
  - 统计分析分页查询
  - 采购价格分析分页查询
  - 筛选项下拉数据查询
  - 统计分析导出
- 统计口径统一建立在以下表上
  - `master.t_project_product`
  - `master.t_project`
  - `master.t_companyinfo`

## Capabilities

### New Capabilities

- `statistics_analysis`
  - 按工程、产品、监督机构、生产单位省市区、进场时间、填报时间查询建材统计结果
  - 导出工作调度表
  - 导出信息确认情况表
- `purchase_price_analysis`
  - 按产品类别、产品名称、产品规格、监督机构、进场时间、填报时间查询采购价格明细

### Capability Details

#### 1. 统计分析

- 页面入口
  - `统计中心 / 统计分析`
- 查询条件
  - 工程名称
  - 产品类别
  - 产品名称
  - 产品规格
  - 质量监督机构
  - 生产单位省市区
  - 进场时间范围
  - 填报时间范围
- 列表字段
  - 工程名称
  - 产品类别
  - 产品名称
  - 产品规格
  - 质量监督机构
  - 生产单位省市区
  - 价格
  - 数量
  - 进场时间
  - 填报时间

#### 2. 采购价格分析

- 页面入口
  - `统计中心 / 采购价格分析`
- 查询条件
  - 产品类别
  - 产品名称
  - 产品规格
  - 质量监督机构
  - 进场时间范围
  - 填报时间范围
- 列表字段
  - 产品类别
  - 产品名称
  - 产品规格
  - 产品数量
  - 产品价格
  - 工程名称
  - 质量监督机构
  - 进场时间
  - 填报时间

## Impact

- OpenSpec
  - `openspec/changes/statistics-center/.openspec.yaml`
  - `openspec/changes/statistics-center/proposal.md`
  - `openspec/changes/statistics-center/design.md`
  - `openspec/changes/statistics-center/tasks.md`
  - `openspec/changes/statistics-center/specs/statistics_analysis/spec.md`
  - `openspec/changes/statistics-center/specs/purchase_price_analysis/spec.md`
- SQL
  - `openspec/changes/statistics-center/sql/menu/base_menu.sql`
- Backend
  - `MatStatisticsController`
  - `IMatStatisticsService`
  - `MatStatisticsServiceImpl`
  - `MatStatisticsMapper`
  - `MatStatisticsMapper.xml`
  - 相关 bo / vo 文件
- Frontend
  - `construction-material-web/src/api/statistics/analysis.js`
  - `construction-material-web/src/views/statistics/analysis/index.vue`
  - `construction-material-web/src/views/statistics/price/index.vue`
