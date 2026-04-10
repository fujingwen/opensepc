# 质量追溯问题记录

## 审查时间

- 2026-04-03

## 已确认事实

1. `master.t_quality_trace` 已存在且已有业务数据，不需要再新建空表。
2. 真实字段名是 `batch_no`，不是旧提案中的 `batch`。
3. `master.t_product_relation` 已存在且共有 1058 条记录，但 `quality_trace_id` 当前全部为空，仅保留了 `legacy_check_product_id`。
4. 当前仍无法直接证明 `legacy_check_product_id` 与 `t_quality_trace.id/original_id` 存在稳定的一一对应关系。
5. `master.t_quality_trace` 当前 616 条活动记录中，`batch_no` 与 `product_name` 均为空，抽测/检测页的“生产批号”“检验产品名称”展示与查询主要依赖历史迁移数据补录。
6. “检测缺陷建材产品 / 缺陷建材使用情况 / 缺陷建材厂家”存在外部数据接入可能。

## 未完成问题

1. 提案涉及的四个页面验收与回写未收口，proposal/design/spec/tasks 仍没有把当前真实实现状态写清楚。
2. “缺陷建材使用情况”“缺陷建材厂家”仍偏占位页或外部数据优先方案，尚未形成稳定的数据闭环。
3. `master.t_product_relation` 虽已落表，但 `quality_trace_id` 尚未回填，当前仍主要依赖 `legacy_check_product_id` 做弱关联判断，历史迁移口径存在不确定性。
4. `master.t_quality_trace` 当前 `batch_no`、`product_name` 普遍为空，导致抽测/检测页面的关键筛选字段可用性不足。

## 数据库核对

1. `master.t_quality_trace` 当前共有 616 条记录。
2. 其中 `conclusion_mark = 'n'` 的记录有 560 条，说明当前数据仍以未完成或未形成最终结论的状态为主。
3. `master.t_product_relation` 当前共有 1058 条记录，其中 `quality_trace_id is null = 1058`、`legacy_check_product_id is not null = 1058`。
4. `master.t_quality_trace` 当前 `batch_no` 为空 616 条、`product_name` 为空 616 条。
