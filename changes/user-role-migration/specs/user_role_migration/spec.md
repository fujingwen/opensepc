# 用户角色迁移规格

## ADDED Requirements

### Requirement: 用户基础映射迁移

系统 SHALL 支持将源库中的用户基础数据迁移到 `master.sys_user`，并保留稳定的来源映射。

#### Scenario: 迁移用户基础数据

- **GIVEN** 源库存在 `test.base_user`
- **WHEN** 执行用户迁移脚本
- **THEN** 系统应将用户写入 `master.sys_user`
- **THEN** 已成功迁移的用户应保留 `original_id`

### Requirement: 组织与岗位映射迁移

系统 SHALL 支持将源库中的组织和岗位数据迁移到主库对应表。

#### Scenario: 迁移组织和岗位

- **WHEN** 执行组织和岗位迁移脚本
- **THEN** 系统应将组织写入 `master.sys_dept`
- **THEN** 系统应将岗位写入 `master.sys_post`
- **THEN** 已迁移记录应保留稳定的来源映射字段

### Requirement: 用户角色关系迁移

系统 SHALL 支持将源库中的用户角色关系迁移到 `master.sys_user_role`。

#### Scenario: 迁移用户角色关系

- **GIVEN** 源库存在用户与角色关系数据
- **WHEN** 执行关系迁移脚本
- **THEN** 系统应将关系写入 `master.sys_user_role`
- **THEN** 迁移结果应可用于后续角色权限计算
