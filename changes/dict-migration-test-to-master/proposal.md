## Why

工程项目页面使用的字典数据（如工程进度、工程性质、工程结构型式等）之前在 `master.sys_dict_type` / `master.sys_dict_data` 中手动配置，但数据与业务实际不一致。真实字典数据来源于旧系统 `test.base_dictionarytype` / `test.base_dictionarydata`，需要统一迁移，避免字典数据重复维护和不一致。

## What Changes

- 将 `test.base_dictionarytype` 中 `F_IsTree = 0`（非树形）的记录迁移到 `master.sys_dict_type`
- 将 `test.base_dictionarydata` 中对应的字典数据迁移到 `master.sys_dict_data`
- 迁移前仅检查并标记 `master.sys_dict_type` / `master.sys_dict_data` 中与待迁移编码冲突的手动数据
- 不删除目标表中的已有数据，冲突项单独输出并跳过迁移

## Capabilities

### New Capabilities

- `dict_migration`
  - 系统字典数据完整来源于旧系统，建材填报模块可直接使用

### Capability Details

#### 1. 字典类型迁移

- 源表：`test.base_dictionarytype`（`F_IsTree = 0` 且未删除的记录）
- 目标表：`master.sys_dict_type`
- 字段映射：
  - `F_EnCode` → `dict_type`
  - `F_FullName` → `dict_name`
  - `F_Description` → `remark`
  - `F_SortCode` → 自定义排序
  - 补充 `tenant_id` = `'000000'`，`create_dept` = `103`

#### 2. 字典数据迁移

- 源表：`test.base_dictionarydata`（关联已迁移的字典类型且未删除的记录）
- 目标表：`master.sys_dict_data`
- 字段映射：
  - `F_EnCode` → `dict_value`
  - `F_FullName` → `dict_label`
  - `F_Description` → `remark`
  - `F_SortCode` → `dict_sort`
  - `F_IsDefault` → `is_default`（1→Y，其他→N）
  - 父类型 `F_EnCode` → `dict_type`
  - 补充 `tenant_id` = `'000000'`，`create_dept` = `103`

#### 3. 冲突检查与跳过策略

- 检查 `master.sys_dict_type` 中是否存在与源表 `F_EnCode` 冲突的 `dict_type`
- 检查 `master.sys_dict_data` 中是否存在同 `dict_type + dict_value` 的冲突数据
- 冲突项只做标记与输出，不做删除
- 迁移脚本跳过已有编码，保持目标库现有数据不变

## Impact

- OpenSpec
  - `openspec/changes/dict-migration-test-to-master/.openspec.yaml`
  - `openspec/changes/dict-migration-test-to-master/proposal.md`
  - `openspec/changes/dict-migration-test-to-master/design.md`
  - `openspec/changes/dict-migration-test-to-master/tasks.md`
  - `openspec/changes/dict-migration-test-to-master/issues.md`
  - `openspec/changes/dict-migration-test-to-master/specs/dict_migration/spec.md`
- SQL
  - `openspec/changes/dict-migration-test-to-master/sql/migrate/migrate_dict.sql`
  - `openspec/changes/dict-migration-test-to-master/sql/migrate/cleanup_old_dict.sql`
- Backend
  - 需要确认后端代码中引用的 `dict_type` 编码与迁移后的一致
- Frontend
  - 需要确认前端字典组件引用的 `dict_type` 编码与迁移后的一致
