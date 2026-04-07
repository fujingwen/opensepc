# 数据大屏模块设计

## 1. 总体目标

本次设计不是接入 `blade_visual_*` 的 DataV 配置式大屏，而是直接基于迁移后的业务运行表实现一个可运行、可维护的建材数据大屏页面。

设计目标：

1. 统一统计中心与数据大屏的数据口径
2. 将大屏运行依赖固定在 `master.*`
3. 只保留当前真实使用的拆分接口结构
4. 页面保持只读展示，不新增业务写入链路

## 2. 数据来源

### 2.1 核心运行表

- `master.t_project`
  - 项目总数
  - 项目名称
  - 项目地址
  - 施工企业
- `master.t_project_product`
  - 建材填报数量
  - 产品类别 / 产品名称
  - 备案证号
  - 审核状态
  - 生产单位
  - 填报时间 / 创建时间
- `master.t_record_product`
  - 备案产品总数
- `master.t_quality_trace`
  - 缺陷建材产品
  - 批号
  - 生产厂家
  - 使用项目
- `master.base_dictionarytype`
  - 产品类别名称解析
- 前端静态资源
  - `construction-material-web/src/assets/geo/qingdao.json`
  - `construction-material-web/src/assets/screen/bg.png`
  - `construction-material-web/src/assets/screen/border.png`

### 2.2 迁移依赖

本变更依赖以下运行表迁移成果：

- `test.t_project -> master.t_project`
- `test.t_quality_trace -> master.t_quality_trace`

## 3. 指标口径

### 3.1 汇总卡片

- 项目总数
  - `count(*) from master.t_project where coalesce(del_flag, 0) = 0`
- 已填报项目总数
  - `count(distinct project_id) from master.t_project_product where coalesce(del_flag, 0) = 0`
- 已填报建材产品总数
  - `count(*) from master.t_project_product where coalesce(del_flag, 0) = 0`
- 备案产品总数
  - `count(*) from master.t_record_product where coalesce(del_flag, 0) = 0`
- 施工企业数
  - `count(distinct construction_unit) from master.t_project where coalesce(del_flag, 0) = 0`
- 生产单位数
  - `count(distinct manufacturer_id) from master.t_project_product where coalesce(del_flag, 0) = 0`

### 3.2 审核指标

- 信息确认率
  - 分母：`master.t_project_product` 有效记录总数
  - 分子：`record_no` 非空的有效记录数
- 审核通过率
  - 分母：已确认记录数
  - 分子：`check_status = 1` 且 `supplier_check_status = 1 or is null`

### 3.3 区市地图与区域统计

当前项目表没有标准化区市编码字段，因此采用“项目地址文本匹配 + 固定青岛 10 区市字典”的方式生成区域统计：

- `市南区`
- `市北区`
- `黄岛区`
- `崂山区`
- `李沧区`
- `城阳区`
- `即墨区`
- `胶州市`
- `平度市`
- `莱西市`

其中：

- 地图展示名称允许将 `黄岛区` 映射为 `西海岸新区`
- `regions` 查询先对 `project_product` 按项目聚合，再按区市汇总，避免直接大表关联造成超时
- 区市维度返回字段为：
  - `regionCode`
  - `regionName`
  - `projectTotal`
  - `involvedProjectTotal`
  - `fillTotal`

### 3.4 图表

- 各区市建材产品填报数量
  - 当前实现为饼图
  - 数据来源：`fillTotal`
- 各产品类别填报数量
  - 当前实现为柱状图
  - 数据来源：`product_type -> base_dictionarytype`
- 各产品类别每月提报数量
  - 当前实现为折线图
  - 月份口径：`coalesce(filling_time, create_time)`
  - 默认展示近 12 个月内填报量前 8 的产品类别

### 3.5 榜单

- 最近项目填报审核
  - 取最近填报或创建时间倒序的建材填报记录
- 最新缺陷建材产品
  - 取 `master.t_quality_trace` 中 `conclusion_mark = 'n'` 的最新记录

## 4. 接口设计

当前主调用接口仅保留以下 5 个：

- `GET /materials/dashboard/summary`
  - 返回汇总卡片数据
- `GET /materials/dashboard/rates`
  - 返回 `confirmationRate`、`approvalRate`
- `GET /materials/dashboard/regions`
  - 返回区市地图和区市填报统计
- `GET /materials/dashboard/types`
  - 返回 `typeStats`、`monthlyTypeTrend`
- `GET /materials/dashboard/lists`
  - 返回 `projectAuditList`、`defectProductList`

前端加载策略：

- 页面挂载后并行调用 `summary / rates / regions / types / lists`
- 使用 `Promise.allSettled`
- 任一接口失败时：
  - 失败模块回落为空数据
  - 其他成功模块继续渲染
  - 控制台记录失败日志，便于联调定位

## 5. 前端设计

### 5.1 页面入口与打开方式

- 菜单点击后以独立页面打开大屏
- 当前承载路由为 `/screen/dashboard`
- 不在普通业务页签内部嵌套打开

### 5.2 页面结构

- 顶部：标题区
- 左侧
  - 平台汇总概览
  - 各区市建材产品填报数量
  - 各产品类别填报数量
- 中部
  - 审核核心指标
  - 3D 区市地图
- 右侧
  - 最近项目填报审核
  - 最新缺陷建材产品
  - 各产品类别每月提报数量

### 5.3 视觉与交互

- 页面背景使用固定尺寸背景图 `bg.png`
- 常规模块使用 `border.png` 边框图
- 地图区域不使用外框面板
- 地图使用 `@antv/l7` + `@antv/l7-maps`
- 地图支持：
  - 3D 挤出
  - 悬浮弹窗
  - 区市标签偏移
  - 边界线与高亮
- 右上、右中榜单支持：
  - 自动向上滚动
  - 悬浮暂停
  - 移出恢复
  - 隐藏滚动条

## 6. 风险与限制

1. 区市归属当前仍基于项目地址文本匹配，不是结构化行政区编码
2. 页面对接口失败采用模块级降级，能提高可用性，但需要结合日志排查失败模块
3. 当前为在线聚合查询；若后续数据量继续上升，可再补物化汇总层
