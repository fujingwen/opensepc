# 质量追溯问题记录

## 审查时间

- 2026-04-03

## 已确认事实

1. `master.t_quality_trace` 已存在且已有业务数据，不需要再新建空表。
2. 真实字段名是 `batch_no`，不是旧提案中的 `batch`。
3. `test.t_product_relation` 只存在于 `test`，`master` 中没有对应关系表。
4. 当前无法直接证明 `test.t_product_relation.F_CheckProductId` 与 `t_quality_trace.id/original_id` 存在稳定的一一对应关系。
5. “检测缺陷建材产品 / 缺陷建材使用情况 / 缺陷建材厂家”存在外部数据接入可能。

## 未完成问题

1. 当前 `specs/` 目录结构不规范，`openspec validate quality-trace` 无法作为正式验收依据。
2. 提案涉及的四个页面验收与回写未收口，proposal/design/spec/tasks 仍没有把当前真实实现状态写清楚。
3. “缺陷建材使用情况”“缺陷建材厂家”仍偏占位页或外部数据优先方案，尚未形成稳定的数据闭环。
4. `test.t_product_relation` 到主库质量追溯记录的映射关系仍不明确，历史迁移口径存在不确定性。

## 数据库核对

1. `master.t_quality_trace` 当前共有 616 条记录。
2. 其中 `conclusion_mark = 'n'` 的记录有 560 条，说明当前数据仍以未完成或未形成最终结论的状态为主。
