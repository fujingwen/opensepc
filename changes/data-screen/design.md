# 数据大屏模块设计

## 1. 总体目标

本次设计不是做离线大屏配置系统，也不是接入 `blade_visual_*` 表，而是直接基于当前迁移后的业务主表生成一个可运行、可校验、可复用的数据大屏页面。

设计目标：

1. 统一统计中心与数据大屏的数据口径
2. 将大屏运行依赖从 `test.*` 表迁回 `master.*`
3. 页面只做只读展示，不新增业务写入

## 2. 数据来源

### 2.1 核心运行表

- `master.t_project`
  - 项目总数
  - 项目名称
  - 项目地址
  - 施工企业
  - 质量监督机构
- `master.t_project_product`
  - 建材填报数量
  - 产品类别 / 名称 / 规格
  - 备案证号
  - 审核状态
  - 生产单位
  - 进场时间 / 填报时间
- `master.t_record_product`
  - 备案产品总数
- `master.t_companyinfo`
  - 生产单位名称与区域信息
- `master.t_quality_trace`
  - 缺陷建材产品
  - 批号
  - 生产厂家
  - 使用项目
- `master.base_region`
  - 青岛市区县边界匹配口径
- `master.base_dictionarytype`
  - 产品类别名称解析

### 2.2 迁移依赖

由于当前运行库还没有 `master.t_project` 与 `master.t_quality_trace`，因此本变更内同步提供：

- `test.t_project -> master.t_project`
- `test.t_quality_trace -> master.t_quality_trace`

## 3. 指标口径

### 3.1 汇总卡片

- 项目总数
  - `count(*) from master.t_project where del_flag = 0`
- 已填报项目总数
  - `count(distinct project_id) from master.t_project_product where del_flag = 0`
- 已填报建材产品总数
  - `count(*) from master.t_project_product where del_flag = 0`
- 备案产品总数
  - `count(*) from master.t_record_product where del_flag = 0`
- 施工企业数
  - `count(distinct construction_unit) from master.t_project where del_flag = 0`
- 生产单位数
  - `count(distinct manufacturer_id) from master.t_project_product where del_flag = 0`

### 3.2 环形指标

- 信息确认率
  - 分母：`master.t_project_product` 有效记录总数
  - 分子：`record_no` 非空的有效记录数
- 审核通过率
  - 分母：信息已确认记录数
  - 分子：`check_status = 1` 且 `supplier_check_status = 1 或为空`

### 3.3 区市地图

由于当前项目表没有标准化行政区字段，本次采用 `master.base_region` 的青岛区县名称与 `master.t_project.project_address` 文本匹配，生成：

- 区市项目总数
- 参与项目总数
  - 指在 `master.t_project_product` 中出现过的项目

### 3.4 图表

- 各区市建材产品填报数量
  - 以项目地址匹配区市，再汇总项目建材条数
- 各产品类别填报数量
  - 使用 `product_type -> base_dictionarytype.id`
- 各产品类别近 12 个月趋势
  - 以 `coalesce(filling_time, create_time)` 为月份口径
  - 默认展示近 12 个月内填报量前 8 的产品类别

### 3.5 榜单

- 最近项目填报审核列表
  - 取最近填报 / 创建时间倒序的项目建材记录
- 最近缺陷建材列表
  - 取 `master.t_quality_trace` 中 `conclusion_mark = 'n'` 的最新记录

## 4. 接口设计

- `GET /materials/dashboard/overview`
  - 一次返回大屏全部展示数据

返回体包含：

- `summary`
- `confirmationRate`
- `approvalRate`
- `projectAuditList`
- `defectProductList`
- `regionStats`
- `districtFillStats`
- `typeStats`
- `monthlyTypeTrend`

## 5. 前端设计

### 5.1 页面结构

- 顶部标题栏
- 左侧
  - 汇总卡片
  - 各区市建材产品填报数量
  - 各产品类别填报数量
- 中部
  - 两个环形指标
  - L7 青岛地图
- 右侧
  - 最近项目填报审核列表
  - 最近缺陷建材列表
  - 各产品类别月度趋势

### 5.2 地图实现

- 使用 `@antv/l7` + `@antv/l7-maps`
- 采用本地 `qingdao.json` 作为 GeoJSON 数据源
- 使用 `Mapbox` 空白底图模式，仅渲染区县面层与标签

## 6. 风险与限制

1. 区市归属当前基于项目地址文本匹配，不是结构化行政区字段；若后续 `master.t_project` 补齐区域编码，应切换到编码口径。
2. 缺陷建材榜单依赖 `master.t_quality_trace` 迁移结果；若后续质量追溯模块新增更多运行字段，需要在此变更上继续扩展。
3. 本次大屏为在线聚合查询，不引入离线汇总表；如果后续数据量显著增长，可再补物化汇总层。
