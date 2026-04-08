# 产品字典问题记录

## 审查时间

- 2026-04-03

## 本轮结论

1. 当前 `issues.md` 原有“已删除 `sys_product` 代码并完成清理”的结论已与仓库和数据库现实冲突，不能继续作为本提案的验收依据。

## 未完成问题

1. 当前仓库中 `system-product` 相关前后端代码仍存在，且已有实际业务实现，本 change 中“已删除相关代码”的说法失真。
2. 当前数据库中 `master.sys_product` 表仍存在且有 38476 条数据，说明“产品能力仅依赖字典表”的方向并未成为系统真实状态。
3. `system-product-dict` 与 `system-product` 两个 change 对同一领域给出了互斥方向，proposal/design/issues 尚未收口边界。
4. 若继续保留本 change，需要回写真实策略：
   - 是仅保留“历史字典迁移/兼容说明”
   - 还是承认产品树、产品名、规格已独立演进为 `system-product` 正式模型

## 审查依据

1. 代码核对：`system-product` 对应前后端实现当前仍在仓库中。
2. 数据库核对：`master.sys_product` 当前共有 38476 条记录，`del_flag` 分布为 `0 = 38470`、`2 = 6`。
