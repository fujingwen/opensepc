## Why

当前系统已经具备统计中心所需的主要业务数据，但原型中的“统计分析”和“采购价格分析”页面仍需要统一查询口径、交互规则和汇总展示方式。

本次变更聚焦于：
- 统计分析页的产品类别、产品名称、产品规格取值方式与建材产品页面 `materials/product` 保持一致
- 前端将产品类别、名称、规格三级联动抽取为公共组件，便于复用
- 统计分析页首屏不自动查询，且产品类别、产品名称为必选
- 采购价格分析页首屏不自动查询，且产品类别、产品名称、产品规格为必选
- 质量监督机构统一按字典标签展示
- 生产单位省市区统一按基础数据中的企业区域编码转换为“省/市/区”文本，并由后端直接返回展示文本
- 统计分析页支持全量合计；采购价格分析页展示平均价格

## What Changes

- 新建 `statistics-center` 变更
- 新增顶层菜单 `统计中心`
  - `统计分析`
  - `采购价格分析`
- 新增统计中心只读查询接口
  - 统计分析分页查询
  - 统计分析全量汇总查询
  - 采购价格分析分页查询
  - 采购价格分析全量汇总查询
  - 基础筛选项查询
- 统一统计口径建立在以下数据源上
  - `master.t_project_product`
  - `master.t_project`
  - `master.t_companyinfo`
  - `master.sys_product`
  - `master.sys_dict_data`
  - `master.base_province`

## Capabilities

### New Capabilities

- `statistics_analysis`
  - 按工程、产品、质量监督机构、生产单位省市区、进场时间、填报时间查询建材明细
  - 支持全量合计展示
- `purchase_price_analysis`
  - 按产品、质量监督机构、进场时间、填报时间查询采购价格明细
  - 支持平均价格汇总展示

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
- 原型对齐规则
  - 产品类别、产品名称为必选
  - 首次进入页面不自动查询
  - 产品三级联动口径与 `materials/product` 保持一致
  - 生产单位省市区使用 `RegionSelect` 选择编码，表格直接使用后端返回的文本展示
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
- 合计规则
  - 在表格最后一行展示全量总条数、总数量、总金额
  - 总数量、总金额保留两位小数
  - 总数量带单位

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
- 原型对齐规则
  - 产品类别、产品名称、产品规格为必选
  - 首次进入页面不自动查询
  - 导出按钮位置与统计分析页保持一致，位于工具栏
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
- 汇总规则
  - 不展示总数量、总金额
  - 展示平均价格，保留两位小数

## Manual Alignment

对照《青岛市建设工程材料信息管理平台操作手册》，当前变更与手册存在以下关系：

- 手册中的“统计分析”要求查询时至少选择“产品类别”和“产品名称”，本次变更已补齐该前置校验
- `purchase_price_analysis` 属于手册范围之外的扩展能力，需要继续在提案与规格中明确标记

## Current Status Notes

- 统计分析页两个导出能力当前不纳入本次交付，先在问题记录中保留，待后续以独立需求补齐
- 当前未解决问题统一维护在 `openspec/原型/原型文件/未解决问题/statistics-center-unresolved-issues.md`

## Impact

- OpenSpec
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
  - 相关 BO / VO
- Frontend
  - `construction-material-web/src/api/statistics/analysis.js`
  - `construction-material-web/src/components/ProductCascadeSelect/index.vue`
  - `construction-material-web/src/utils/materials.js`
  - `construction-material-web/src/views/statistics/analysis/index.vue`
  - `construction-material-web/src/views/statistics/price/index.vue`
