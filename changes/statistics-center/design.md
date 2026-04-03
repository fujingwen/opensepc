# 统计中心模块设计

## 1. 总体目标

在不新增统计业务表的前提下，直接基于业务明细表构建两个只读统计页面：

1. 统计分析
2. 采购价格分析

本次设计重点是统一查询口径、筛选交互、字典展示和汇总规则，而不是做离线汇总。

## 2. 数据来源

### 2.1 主表

- `master.t_project_product`
  - 产品类别：`product_type`
  - 产品名称：`product_name`
  - 产品规格：`product_standard` / `product_standard_select`
  - 产品数量：`quantity`
  - 产品价格：`unit_price`
  - 产品单位：`unit`
  - 进场时间：`approach_time`
  - 填报时间：`filling_time` / `create_time`

### 2.2 关联表

- `master.t_project`
  - 工程名称：`project_name`
  - 质量监督机构：`quality_supervision_agency`
- `master.t_companyinfo`
  - 生产单位区域编码：`area`
- `master.sys_product`
  - 产品类别名称、产品名称、规格名称解析
- `master.sys_dict_data`
  - 质量监督机构字典标签解析
- `master.base_province`
  - 省、市、区名称解析

## 3. 查询口径

### 3.1 产品类别、产品名称、产品规格

- 查询场景统一对齐建材产品页面 `materials/product`
- 产品类别使用 `sys_product` 类别节点 ID
- 产品名称使用 `sys_product` 产品节点 ID
- 产品规格使用 `productStandardSelect` 中的规格节点 ID
- 前端统一通过公共三级联动组件选择

### 3.2 统计分析

统计分析直接输出项目建材明细，不做分组聚合。

字段映射：
- 工程名称：`p.project_name`
- 产品类别：优先显示 `sys_product.full_name` 解析结果
- 产品名称：优先显示 `sys_product.full_name` 解析结果
- 产品规格：优先显示规格名称，回退到原始 `product_standard` / `product_standard_select`
- 质量监督机构：优先显示字典标签，回退到原始值
- 生产单位省市区：优先显示后端按区域编码解析后的 `省/市/区` 文本，回退到原始 `area`
- 价格：`pp.unit_price`
- 数量：`pp.quantity`
- 进场时间：`pp.approach_time`
- 填报时间：`coalesce(pp.filling_time, pp.create_time)`

### 3.3 采购价格分析

采购价格分析与统计分析共用相同数据源，但页面重点调整为价格视角：

- 仍按明细展示
- 默认排序按填报时间倒序、ID 倒序
- 保留工程名称和质量监督机构，便于比较同类产品价格差异
- 汇总不展示总数量和总金额，改为展示平均价格

## 4. 汇总规则

### 4.1 统计分析

返回全量汇总信息：

- `totalCount`
- `totalQuantity`
- `totalAmount`
- `totalUnit`

展示规则：

- 合计行显示全量数据，不受分页限制
- 总数量、总金额保留两位小数
- 当筛选结果只有一个单位时，总数量显示“数量 + 单位”

### 4.2 采购价格分析

返回全量汇总信息：

- `totalCount`
- `avgPrice`

展示规则：

- 合计行显示“平均价格”
- 平均价格保留两位小数

## 5. 接口设计

### 5.1 查询接口

- `GET /materials/statistics/analysis/list`
- `GET /materials/statistics/analysis/summary`
- `GET /materials/statistics/purchase/list`
- `GET /materials/statistics/purchase/summary`

### 5.2 导出接口

- `POST /materials/statistics/purchase/export`

说明：

- 采购价格分析导出接口可用
- 统计分析“工作调度表 / 信息确认情况表”导出暂不纳入本次交付，先记录为未解决问题，不在本次设计中承诺接口交付

### 5.3 筛选项接口

- `GET /materials/statistics/options/projects`
- `GET /materials/statistics/options/qualityAgencies`

说明：

- 产品类别、产品名称、产品规格不再依赖统计模块独立下拉接口，前端直接复用 `system/product` 口径
- 生产单位省市区查询条件改为前端使用 `RegionSelect` 组件选择地区编码

## 6. 前端设计

### 6.1 公共能力

- 公共组件：`construction-material-web/src/components/ProductCascadeSelect/index.vue`
- 公共工具：`construction-material-web/src/utils/materials.js`

### 6.2 统计分析交互

- 首屏只加载基础选项，不自动查询
- 产品类别、产品名称必选
- 生产单位省市区使用 `RegionSelect`
- 合计行展示全量总条数、总数量、总金额
- 表格中的生产单位省市区直接使用后端返回文本，不再逐条前端补查

### 6.3 采购价格分析交互

- 首屏只加载基础选项，不自动查询
- 产品类别、产品名称、产品规格必选
- 导出按钮放在工具栏
- 合计行展示平均价格

## 7. 风险与限制

1. 当前实现仍基于业务明细表直接查询，未做物化统计表，后续数据量继续增长时可能需要单独优化。
2. 生产单位省市区依赖 `manufacturer_id -> t_companyinfo.area -> base_province`，若历史数据未建立完整企业映射或行政区划编码不规范，则可能仍需回退展示原始值。
3. 统计分析两个导出文件当前不纳入本次交付，需在后续独立需求中补齐。
4. 当前未解决问题统一维护在 `openspec/原型/原型文件/未解决问题/statistics-center-unresolved-issues.md`。
