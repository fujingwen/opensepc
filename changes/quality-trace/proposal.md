# 质量追溯模块

## Why

当前 `quality-trace` 提案只覆盖了“抽测缺陷建材产品”单页，且仍以旧库字段命名为准，和当前仓库、原型截图、数据库真实情况均不一致：

- 原型实际包含 4 个页面：
  - 抽测缺陷建材产品
  - 检测缺陷建材产品
  - 缺陷建材使用情况
  - 缺陷建材厂家
- `master.t_quality_trace` 已存在且已完成历史迁移，真实字段为 `batch_no`，不是旧提案中的 `batch`
- `master.t_product_relation` 现已落地，但当前只承接了历史 `legacy_check_product_id`，`quality_trace_id` 尚未形成稳定回填
- “检测缺陷建材产品 / 缺陷建材使用情况 / 缺陷建材厂家”这 3 个页面存在外部数据接入可能，当前无法仅凭现有主库数据完全还原其业务语义

因此需要将提案修订为“四页完整方案 + 分层实施方案”：

- 对可确认的数据能力先真实落地
- 对仍依赖外部数据的数据口径先保留前端 UI 和标准接口契约

## What Changes

- 将 `quality-trace` 变更扩展为 4 个页面的完整模块
- 修正 `t_quality_trace` 的字段口径，统一使用真实字段 `batch_no`
- 回写 `master.t_product_relation` 的当前落地事实：表和历史数据已存在，但仍属于弱关联承接态
- 为“检测缺陷建材产品”补充复检合格所需字段
- 将“缺陷建材使用情况”“缺陷建材厂家”定义为外部数据优先接入页：
  - 前端页面本次完成
  - 后端先提供占位接口与统一返回结构
  - 等外部数据源明确后再切换实现
- 补齐 4 个页面对应的菜单、权限点、接口与 SQL 资产

## Capabilities

### quality_trace_spot_testing

抽测缺陷建材产品管理：

- 查询
- 导入
- 删除
- 标记“有无对比数据”

### quality_trace_detect_testing

检测缺陷建材产品管理：

- 查询
- 删除
- 复检合格
- 查看复检附件

### quality_trace_usage

缺陷建材使用情况：

- 查询
- 隐藏
- 查看对应填报信息
- 查看附件

### quality_trace_factory

缺陷建材厂家：

- 查询
- 展示平台生产厂家与检验检测生产厂家差异

## Data Strategy

### 1. 主库真实落地部分

- `master.t_quality_trace`
  - 作为质量追溯主表继续保留
  - 本次在提案中补齐复检相关字段设计
- `master.t_project_product`
  - 用于承接“缺陷建材使用情况”中的项目、产品、闭环状态、附件、监理核对时间等信息
- `master.t_project`
  - 用于补齐工程名称、工程进度、工程地址
- `master.t_companyinfo`
  - 用于补齐生产厂家名称、厂家区域等信息

### 2. 历史关系承接部分

- `master.t_product_relation` 已存在，当前 1058 条记录全部保留了 `legacy_check_product_id`
- 当前真实库中仍无法直接证明 `legacy_check_product_id -> t_quality_trace.id/original_id`
- 因此本次提案继续保留“弱关联承接”口径，不在文档中虚构一条未经验证的强关系

### 3. 外部数据优先接入部分

以下页面数据口径先按“外部数据接口优先”设计：

- 检测缺陷建材产品
- 缺陷建材使用情况
- 缺陷建材厂家

本次实现要求：

- 前端页面 UI 完整可用
- 后端提供统一分页接口与占位返回
- 当配置了真实外部数据源后，可在不改前端契约的前提下切换数据来源

## SQL Assets

- `sql/tables/base_t_quality_trace.sql`
- `sql/tables/base_t_product_relation.sql`
- `sql/indexes/idx_t_quality_trace.sql`
- `sql/indexes/idx_t_product_relation.sql`
- `sql/migrate/migrate_t_quality_trace.sql`
- `sql/migrate/migrate_t_product_relation.sql`
- `sql/menu/menu_quality_trace.sql`
- `sql/dict/dict_quality_trace.sql`

## Impact

### Backend

- 新增质量追溯控制器、服务、Mapper
- 接口分为：
  - 主库落地接口
  - 外部数据占位接口

### Frontend

- 新增 `quality` 模块下 4 个页面
- 统一查询区、表格区、分页区与操作弹窗

### Database

- 修订 `t_quality_trace` 提案口径
- 新增 `t_product_relation` 的 `master` 方案
- 菜单、权限点、字典 SQL 全量补齐
