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

### Requirement: 冲突字典只标记不删除

系统 SHALL 在迁移前检查目标库中与待迁移编码冲突的字典，但不得删除已有手动字典数据。

#### Scenario: 检查冲突数据

- **Given** `master.sys_dict_type` 或 `master.sys_dict_data` 中已存在与源表编码冲突的记录
- **When** 执行迁移前检查脚本
- **Then** 系统应输出冲突记录供人工核查
- **Then** 系统不得删除目标库中已有字典数据
- **Then** 后续迁移应跳过这些冲突编码
