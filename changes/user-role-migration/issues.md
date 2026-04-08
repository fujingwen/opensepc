# 用户角色迁移问题记录

## 审查时间

- 2026-04-03

## 未完成问题

1. 当前 `specs/` 目录结构不规范，`openspec validate user-role-migration` 无法通过。
2. proposal 当前仍偏“待执行”状态，但数据库现实已显示迁移处于“部分完成但未闭环”，文档状态与实际不一致。
3. `master.sys_user` 当前共有 4940 条记录，而 `test.base_user` 有 5233 条，仍存在 293 条差额，迁移范围尚未完全闭合。
4. `master.sys_user.original_id` 非空仅 4915 条，说明仍有部分主库用户未保留稳定的源用户映射。
5. `master.sys_user_role` 当前共有 4940 条记录，但角色映射完整性与异常用户的补偿策略尚未在提案中写清楚。
6. rollback 验证仍未完成，当前提案缺少可复核的回滚演练记录。

## 数据库核对

1. `master.sys_user = 4940`
2. `master.sys_user.original_id is not null = 4915`
3. `master.sys_user_role = 4940`
4. `test.base_user = 5233`
