# 质量追溯模块设计

## 1. 页面结构

质量追溯模块共 4 个页面：

1. 抽测缺陷建材产品
2. 检测缺陷建材产品
3. 缺陷建材使用情况
4. 缺陷建材厂家

左侧菜单结构：

```text
质量追溯
├── 抽测缺陷建材产品
├── 检测缺陷建材产品
├── 缺陷建材使用情况
└── 缺陷建材厂家
```

## 2. 数据分层

### 2.1 主库落地页

#### 抽测缺陷建材产品

数据来源：

- `master.t_quality_trace`

查询条件：

- 产品名称
- 生产批号
- 生产厂家

列表字段：

- 工程名称
- 检测项目
- 检验产品名称
- 生产厂家
- 生产批号
- 检测日期
- 报告日期
- 检验参数
- 结论
- 有无对比数据

行为：

- 导入
- 删除

其中“有无对比数据”先按关系表是否存在记录计算。

### 2.2 外部数据优先页

#### 检测缺陷建材产品

页面行为：

- 查询
- 删除
- 复检合格

弹窗字段：

- 备注，必填
- 附件，必填

数据策略：

- 优先走外部数据接口
- 若未接入外部数据，则返回占位分页数据

为了兼容未来落库，`t_quality_trace` 预留以下字段：

- `recheck_status`
- `recheck_remark`
- `recheck_attachment`
- `recheck_time`
- `recheck_by`

#### 缺陷建材使用情况

页面字段：

- 工程名称
- 工程进度
- 工程地址
- 产品名称
- 生产批号
- 生产厂家
- 检验检测生产厂家
- 是否复检合格
- 是否闭环
- 类别
- 核对时间

操作：

- 隐藏
- 对应填报的信息
- 附件

数据策略：

- 优先走外部数据接口
- 若后续切回主库统计，可基于 `t_project_product + t_project + t_companyinfo + t_product_relation`

闭环相关字段优先复用：

- `t_project_product.is_pass_by_request`
- `t_project_product.jl_unit`
- `t_project_product.pass_reason`
- `t_project_product.jl_unit_check_time`
- `t_project_product.file_url`

#### 缺陷建材厂家

页面字段：

- 建材平台生产厂家
- 检验检测生产厂家
- 产品名称
- 生产批号
- 检测项目
- 检测日期

数据策略：

- 优先走外部数据接口
- 若后续切回主库统计，可基于“缺陷建材使用情况”做厂家维度聚合

## 3. 表设计

### 3.1 master.t_quality_trace

当前真实字段：

- `id`
- `original_id`
- `check_organize`
- `project_no`
- `project_name`
- `product_name`
- `factory_name`
- `batch_no`
- `check_project_name`
- `data_status`
- `is_collect`
- `conclusion_mark`
- `conclusion`
- `report_time`
- `check_time`
- `enabled_mark`
- 审计字段

本次提案补充字段：

- `recheck_status integer default 0`
- `recheck_remark varchar(1000)`
- `recheck_attachment varchar(500)`
- `recheck_time timestamp`
- `recheck_by varchar(50)`

### 3.2 master.t_product_relation

设计目的：

- 承接 `test.t_product_relation`
- 记录产品与缺陷追溯记录的关系
- 承接“隐藏”状态

建议字段：

- `id varchar(50)`
- `tenant_id varchar(50) default '000000'`
- `product_id varchar(50)`
- `legacy_check_product_id varchar(50)`
- `quality_trace_id varchar(50)`
- `status integer default 1`
- `hidden_flag integer default 0`
- `hidden_by varchar(50)`
- `hidden_time timestamp`
- `create_by`
- `create_time`
- `update_by`
- `update_time`
- `del_flag`
- `create_dept`

说明：

- `legacy_check_product_id` 用于保留 `test` 历史值
- `quality_trace_id` 用于未来补齐与 `master.t_quality_trace` 的真实关联
- 本提案不把两者强行等同

## 4. 接口设计

统一前缀：

- `/materials/qualityTrace`

### 4.1 抽测缺陷建材产品

- `GET /spot/page`
- `POST /spot/import`
- `DELETE /spot/{ids}`

### 4.2 检测缺陷建材产品

- `GET /detect/page`
- `DELETE /detect/{ids}`
- `POST /detect/recheck`

### 4.3 缺陷建材使用情况

- `GET /usage/page`
- `POST /usage/hide`

### 4.4 缺陷建材厂家

- `GET /factory/page`

## 5. 前端设计

统一遵循现有后台风格：

- 顶部查询区
- 中部工具栏
- 底部表格 + 分页

### 5.1 外部数据占位约定

对于外部数据优先页面，接口即使暂未接入真实外部源，也必须返回：

```json
{
  "rows": [],
  "total": 0,
  "source": "external-placeholder"
}
```

这样前端无需额外分支即可先完成 UI 联调。
