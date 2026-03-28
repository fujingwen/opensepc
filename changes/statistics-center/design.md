# 统计中心模块设计

## 1. 总体目标

在不新增统计业务表的前提下，直接基于主业务数据表构建两个只读统计页面：

1. 统计分析
2. 采购价格分析

本次设计重点是统一口径，而不是做离线汇总或大屏指标沉淀。

## 2. 数据来源

### 2.1 主表

- `master.t_project_product`
  - 产品类别：`product_type`
  - 产品名称：`product_name`
  - 产品规格：`product_standard` / `product_standard_select`
  - 产品数量：`quantity`
  - 产品价格：`unit_price`
  - 进场时间：`approach_time`
  - 填报时间：`filling_time`

### 2.2 关联表

- `master.t_project`
  - 工程名称：`project_name`
  - 质量监督机构：`quality_supervision_agency`
- `master.t_companyinfo`
  - 生产单位省市区：`area`

## 3. 查询口径

### 3.1 统计分析

统计分析直接输出项目建材明细，不做聚合汇总，原因如下：

- 原型列表本身就是明细表格
- 后续导出工作调度表和信息确认情况表都需要保留明细粒度
- 质量追溯和价格分析也能复用相同查询口径

字段映射：

- 工程名称：`p.project_name`
- 产品类别：`pp.product_type`
- 产品名称：`pp.product_name`
- 产品规格：`coalesce(nullif(pp.product_standard, ''), pp.product_standard_select)`
- 质量监督机构：`p.quality_supervision_agency`
- 生产单位省市区：`mc.area`
- 价格：`pp.unit_price`
- 数量：`pp.quantity`
- 进场时间：`pp.approach_time`
- 填报时间：`coalesce(pp.filling_time, pp.create_time)`

### 3.2 采购价格分析

采购价格分析与统计分析共享相同数据源，但页面重点调整为价格视角：

- 仍按明细展示
- 默认排序按填报时间倒序、ID倒序
- 保留工程名称和质量监督机构，便于比对同类产品价格差异

## 4. 接口设计

### 4.1 查询接口

- `GET /materials/statistics/analysis/list`
- `GET /materials/statistics/purchase/list`

### 4.2 导出接口

- `POST /materials/statistics/analysis/exportSchedule`
- `POST /materials/statistics/analysis/exportConfirmation`
- `POST /materials/statistics/purchase/export`

### 4.3 下拉选项接口

- `GET /materials/statistics/options/projects`
- `GET /materials/statistics/options/productTypes`
- `GET /materials/statistics/options/productNames`
- `GET /materials/statistics/options/productSpecs`
- `GET /materials/statistics/options/qualityAgencies`
- `GET /materials/statistics/options/areas`

## 5. 前端设计

### 5.1 页面结构

- 顶层菜单：`统计中心`
- 子页面
  - `statistics/analysis/index`
  - `statistics/price/index`

### 5.2 交互原则

- 查询条件使用下拉和时间范围组合
- 列表使用标准分页
- 首屏默认加载第一页数据和下拉选项
- 导出沿用系统统一 `proxy.download` 方式

## 6. 风险与限制

1. 当前实现基于业务明细表直接查询，未做物化统计表，后续数据量进一步增长时可能需要单独优化。
2. 生产单位省市区依赖 `manufacturer_id -> t_companyinfo.area`，若历史数据未完成企业映射，则该列可能为空。
3. “导出工作调度表”和“导出信息确认情况表”当前复用相同明细数据口径，区别体现在导出文件名称和业务语义上；若后续需要差异化列结构，可在此变更上继续扩展。
