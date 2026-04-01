## Context

建材填报模块的字典数据需要从旧系统 `test` schema 迁移到新系统 `master` schema。当前 `master` 中存在少量手动创建的字典数据（dict_id 201-305），数据内容与旧系统不一致，需要清理后重新导入。

## Goals / Non-Goals

**Goals**

- 将旧系统全部非树形字典类型及数据迁移到新系统
- 清理不一致的手动字典数据
- 保持新系统其他字典数据不变

**Non-Goals**

- 本次不迁移树形字典（F_IsTree = 1）
- 本次不修改前端/后端对字典编码的引用（需另外确认编码一致性）
- 本次不处理旧系统字典的父子层级结构

## Decisions

### 1. 使用 dict_type 编码（F_EnCode）作为关联键

迁移后使用源表的 `F_EnCode` 作为 `master.sys_dict_type.dict_type`，字典数据也通过此编码关联。经查询确认源表编码与目标表现有编码无冲突（0 条重复）。

### 2. 使用自增起始 ID 避免主键冲突

源表使用 varchar ID，目标表使用 bigint snowflake ID。迁移时使用 `2034535000000010001` 起始的自增 ID，确保不与现有数据冲突。

### 3. 先清理后迁移

先删除建材模块手动创建的字典（dict_id 201-305），再执行迁移，避免同一业务字典出现两套数据。

## 数据规模

| 项目 | 数量 |
|------|------|
| 源字典类型（非树形） | 38 |
| 源字典数据 | 292 |
| 待清理目标字典类型 | ~9 |
| 待清理目标字典数据 | ~45 |

## 字段映射

### test.base_dictionarytype → master.sys_dict_type

| 源字段 | 目标字段 | 转换规则 |
|--------|----------|----------|
| - | dict_id | 自增 bigint，起始 2034535000000010001 |
| '000000' | tenant_id | 固定值 |
| F_FullName | dict_name | 直接映射 |
| F_EnCode | dict_type | 直接映射 |
| 103 | create_dept | 固定值 |
| 1 | create_by | 固定值 |
| now() | create_time | 当前时间 |
| F_Description | remark | 直接映射 |

### test.base_dictionarydata → master.sys_dict_data

| 源字段 | 目标字段 | 转换规则 |
|--------|----------|----------|
| - | dict_code | 自增 bigint，起始 2034535000000020001 |
| '000000' | tenant_id | 固定值 |
| F_SortCode | dict_sort | 直接映射 |
| F_FullName | dict_label | 直接映射 |
| F_EnCode | dict_value | 直接映射 |
| 父类型.F_EnCode | dict_type | 通过关联父类型获取 |
| F_IsDefault | is_default | 1→Y，其他→N |
| 103 | create_dept | 固定值 |
| 1 | create_by | 固定值 |
| now() | create_time | 当前时间 |
| F_Description | remark | 直接映射 |

## SQL Design

### 执行顺序

1. `sql/migrate/cleanup_old_dict.sql` — 清理旧手动数据
2. `sql/migrate/migrate_dict.sql` — 迁移字典类型和数据

## Risks / Trade-offs

1. 迁移后 dict_type 编码会从原来的 `project_progress` 等变为 `gcjd` 等，前端和后端代码中的引用需要同步更新。
2. 部分字典类型为系统管理类（如 portalDesigner、flowForm），迁移后可能在新系统中不需要，但不影响功能。
