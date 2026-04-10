# Kingbase Master 缺表补齐规格

## ADDED Requirements

### Requirement: Kingbase Master 必需表完整性

系统 SHALL 在 KingbaseES `building_supplies_supervision` 库的 `master` schema 中提供当前运行所必需的基础表。

#### Scenario: 检查必需表存在性

- **Given** 目标库为 KingbaseES `building_supplies_supervision`
- **When** 检查 `master` schema 基础表
- **Then** 系统应存在 `base_message`
- **Then** 系统应存在 `base_message_receive`
- **Then** 系统应存在 `base_message_template`
- **Then** 系统应存在 `sys_dict_type`
- **Then** 系统应存在 `sys_logininfor`
- **Then** 系统应存在 `t_product_relation`

### Requirement: Kingbase Master 需具备等价运行结构

系统 SHALL 为上述表提供与 PostgreSQL 源库一致或兼容等价的主键、默认值和关键索引。

#### Scenario: 补齐消息与追溯关键索引

- **Given** KingbaseES 中已创建缺失表
- **When** 执行结构补齐
- **Then** `base_message` 应具备主键和消息查询所需索引
- **Then** `base_message_receive` 应具备主键和收件箱查询所需索引
- **Then** `t_product_relation` 应具备主键以及 `product_id`、`quality_trace_id`、`hidden_flag` 索引

#### Scenario: 兼容 `sys_dict_type` 默认值

- **Given** `sys_dict_type.dict_id` 在源库依赖默认值函数
- **When** 在 KingbaseES 中补齐该表
- **Then** 迁移方案应提供与源库兼容的 ID 生成能力
- **Then** 不应因默认值函数缺失导致新增字典类型失败

### Requirement: Kingbase Master 需完成数据对齐

系统 SHALL 将 PostgreSQL 源库中上述缺失表的历史数据迁移到 KingbaseES。

#### Scenario: 迁移缺失表历史数据

- **Given** PostgreSQL 源库中上述 6 张表存在历史数据
- **When** 执行迁移脚本
- **Then** KingbaseES 中对应表的数据应被导入
- **Then** 静态表迁移后目标表行数应与源表一致
- **Then** 对 `base_message`、`base_message_receive`、`sys_logininfor` 这类运行期持续写入表，应记录迁移完成时的基线和当前差异说明，而不是长期要求持续逐表等量
- **Then** 大表迁移应支持分批执行和校验
