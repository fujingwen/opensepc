# 问题记录

## 已确认

- `master.t_quality_trace` 已存在且已迁移，不需要再新建空表
- 真实字段名是 `batch_no`，不是旧提案中的 `batch`
- `test.t_product_relation` 只存在于 `test`，`master` 没有对应关系表
- 当前真实库里无法直接证明 `test.t_product_relation.F_CheckProductId` 与 `t_quality_trace.id/original_id` 的一一对应关系
- “检测缺陷建材产品 / 缺陷建材使用情况 / 缺陷建材厂家”存在外部数据接入可能

## 处理策略

- 抽测缺陷建材产品优先基于主库真实表落地
- 其余三个页面先按外部数据页实现 UI 和标准接口
- 后续若外部数据规则明确，可在不改前端页面结构的前提下替换接口实现
