# 用户角色迁移问题记录

## 审查时间

- 2026-04-03

## 未完成问题

1. proposal 当前仍偏“待执行”状态，但数据库现实已显示迁移处于“部分完成但未闭环”，文档状态与实际不一致。
2. 当前以源库 PostgreSQL `test.base_user = 5233` 对比金仓开发库 `master.sys_user = 4937`，仍存在 296 条差额，迁移范围尚未完全闭合。
3. `master.sys_user.original_id` 非空仅 4915 条，说明仍有部分主库用户未保留稳定的源用户映射。
4. `master.sys_user_role` 当前共有 4938 条记录，但角色映射完整性与异常用户的补偿策略尚未在提案中写清楚。
5. rollback 验证仍未完成，当前提案缺少可复核的回滚演练记录。

## 数据库核对

1. 金仓开发库 `master.sys_user = 4937`
2. `master.sys_user.original_id is not null = 4915`
3. 金仓开发库 `master.sys_user_role = 4938`
4. PostgreSQL 源库 `test.base_user = 5233`
