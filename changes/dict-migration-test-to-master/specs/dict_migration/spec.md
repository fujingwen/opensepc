# 字典迁移规格

## ADDED Requirements

### Requirement: 旧系统非树形字典类型迁移到新系统

系统 SHALL 将 `test.base_dictionarytype` 中 `F_IsTree = 0` 且未删除的字典类型迁移到 `master.sys_dict_type`。

#### Scenario: 迁移字典类型

- **Given** `test.base_dictionarytype` 中存在 `F_IsTree = 0` 的字典类型
- **When** 执行迁移脚本
- **Then** 应将字典类型写入 `master.sys_dict_type`
- **Then** `dict_type` 应为源表的 `F_EnCode`
- **Then** `dict_name` 应为源表的 `F_FullName`
- **Then** 不应覆盖目标表中已有的同编码数据

### Requirement: 字典数据随类型一同迁移

系统 SHALL 将对应的字典数据从 `test.base_dictionarydata` 迁移到 `master.sys_dict_data`。

#### Scenario: 迁移字典数据

- **Given** 字典类型已迁移到 `master.sys_dict_type`
- **When** 执行迁移脚本
- **Then** 应将关联的字典数据写入 `master.sys_dict_data`
- **Then** `dict_value` 应为源数据的 `F_EnCode`
- **Then** `dict_label` 应为源数据的 `F_FullName`
- **Then** `dict_type` 应为所属类型的 `F_EnCode`

### Requirement: 清理旧的建材模块手动字典

系统 SHALL 在迁移前删除 `master.sys_dict_type` 中建材模块手动创建的字典数据。

#### Scenario: 清理旧数据

- **Given** `master.sys_dict_type` 中存在建材模块手动创建的字典（dict_id 201-305）
- **When** 执行清理脚本
- **Then** 应删除这些字典类型及对应的字典数据
- **Then** 不应删除其他字典数据
