# System Region - 行政区划管理

## ADDED Requirements

### Requirement: 行政区划删除使用逻辑删除

系统 SHALL 在删除行政区划时使用 `del_flag` 作为统一删除标记。

#### Scenario: 删除行政区划

- **WHEN** 用户删除某条行政区划记录
- **THEN** 系统将该记录的 `del_flag` 更新为 `2`
- **AND** 系统不再依赖 `delete_mark` 作为删除语义

### Requirement: 行政区划编码必须在活动数据中唯一

系统 SHALL 保证活动数据中的 `en_code` 唯一。

#### Scenario: 新增时编码重复

- **WHEN** 用户新增行政区划，且活动数据中已存在相同 `en_code`
- **THEN** 系统拒绝保存并提示编码已存在

#### Scenario: 修改时编码重复

- **WHEN** 用户修改行政区划，且除当前记录外的活动数据中已存在相同 `en_code`
- **THEN** 系统拒绝保存并提示编码已存在

### Requirement: 行政区划字段映射遵循实表设计

系统 SHALL 按 `master.base_province` 的真实表结构建模行政区划数据。

#### Scenario: 映射 type 字段

- **WHEN** 系统读写 `type` 字段
- **THEN** 按字符串类型处理，而不是整数类型

#### Scenario: 映射删除标记

- **WHEN** 系统读写删除状态
- **THEN** 使用 `del_flag`
- **AND** `0` 表示正常
- **AND** `2` 表示删除

### Requirement: 页面列表接口与详情查询权限分离

系统 SHALL 区分页面访问权限和详情查询权限。

#### Scenario: 页面列表

- **WHEN** 用户访问 `/system/region/list`
- **THEN** 系统校验 `system:region:list` 或企业基础数据查询权限
- **AND** 至少兼容 `base:production:list`、`base:construction:list`、`base:agent:list`

#### Scenario: 详情查询

- **WHEN** 用户访问 `/system/region/{id}`
- **THEN** 系统校验 `system:region:query` 或企业基础数据查询权限
- **AND** 至少兼容 `base:production:list`、`base:construction:list`、`base:agent:list`
