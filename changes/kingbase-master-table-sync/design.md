# Kingbase Master 缺表补齐设计

## Context

本设计仅聚焦 KingbaseES `building_supplies_supervision.master` 与 PostgreSQL 同名库 `master` schema 的缺失表补齐，不扩展新的业务需求。

2026-04-07 首轮比对时，已确认的差异为：

- PostgreSQL 存在但 KingbaseES 不存在：
  - `base_message`
  - `base_message_receive`
  - `base_message_template`
  - `sys_dict_type`
  - `sys_logininfor`
  - `t_product_relation`
- KingbaseES 额外存在：
  - `base_region`

其中额外表 `base_region` 不属于本次变更处理范围。

截至 2026-04-10，上述 6 张表已全部在金仓开发库落地，本设计需要按当前现实回写为“迁移完成后的验收设计”。

## Design Goals

- 让 KingbaseES `master` schema 与当前项目运行所需表保持可运行一致
- 优先复用 PostgreSQL 源库的真实表结构，而不是只按文档推导
- 控制迁移后的长期维护风险，避免继续沿用“缺表待迁移”的过时口径
- 为收尾验收提供明确的结构校验、样本校验与链路校验口径

## Non-Goals

- 不删除 KingbaseES 中比源库多出的表
- 不对现有业务表做字段扩展
- 不改动现有接口契约
- 不重新发起一轮全量迁移

## Table Strategy

### 1. `base_message`

用途：

- 消息发送主表

迁移策略：

- 直接按 PostgreSQL 源库真实结构建表
- 同步主键与消息相关索引
- 迁移全部现有数据

### 2. `base_message_receive`

用途：

- 消息收件箱表

迁移策略：

- 直接按 PostgreSQL 源库真实结构建表
- 同步主键与查询索引
- 因数据量较大，采用分批导入

### 3. `base_message_template`

用途：

- 消息模板表

迁移策略：

- 补齐结构和主键
- 当前源库无数据，但仍需建表以满足设计完整性

### 4. `sys_dict_type`

用途：

- 字典类型表

迁移策略：

- 按源库真实结构建表
- 保留 `dict_id` 为主业务标识
- 对 `generate_snowflake_id()` 默认值做兼容处理

兼容方案优先级建议：

1. 优先在 KingbaseES 中补齐 `generate_snowflake_id()` 等价函数
2. 如果函数补齐风险过高，再将默认值改为显式插入或应用层赋值

### 5. `sys_logininfor`

用途：

- 登录访问记录表

迁移策略：

- 按源库结构直接建表
- 数据量较小，可整体导入

### 6. `t_product_relation`

用途：

- 质量追溯产品关联表

迁移策略：

- 按源库真实结构建表
- 同步主键和 3 个查询索引：
  - `product_id`
  - `quality_trace_id`
  - `hidden_flag`
- 迁移全部历史数据

## Constraints And Indexes

当前 PostgreSQL 源库中已确认：

- `base_message` 主键：`id`
- `base_message_receive` 主键：`id`
- `base_message_template` 主键：`id`
- `sys_dict_type` 唯一键：`dict_id`
- `t_product_relation` 主键：`id`

应同步的关键索引包括：

- `base_message`
  - `sender_id`
  - `message_type`
  - `send_time`
  - `del_flag`
- `base_message_receive`
  - `message_id`
  - `receiver_user_id`
  - `message_type`
  - `business_type`
  - `send_time`
  - `del_flag`
- `t_product_relation`
  - `product_id`
  - `quality_trace_id`
  - `hidden_flag`

## Migration Phases

### Phase 1: Structure Confirmation

- 确认 KingbaseES 中 6 张表均已存在
- 确认主键、唯一键、必要索引现状与 PostgreSQL 源库对齐
- 确认 `sys_dict_type` 的当前运行方式不再被默认值函数缺失阻塞

### Phase 2: Data Baseline Confirmation

- 对静态表确认当前行数与源库一致
- 对动态表记录当前基线差异
- 保留抽样记录，避免后续再把“动态增长”误判为“迁移失败”

### Phase 3: Runtime Validation

- 表存在性校验
- 行数校验
- 索引校验
- 抽样数据一致性校验
- 关键 SQL/接口链路校验

## Validation Rules

迁移完成后至少验证：

- KingbaseES 中 6 张表全部存在
- 静态表与源库行数一致；动态表完成当前基线记录
- `base_message_receive` 抽样消息记录内容一致
- `sys_dict_type` 可新增字典类型，不因默认值函数缺失报错
- `t_product_relation` 可被质量追溯查询正常访问

## Rollback Considerations

如果迁移阶段出现问题，回滚应按以下原则执行：

- 优先回滚本次新增表中的导入数据
- 保留执行日志与校验结果
- 不影响 KingbaseES 中其他既有对象
- 大表导入失败时只回滚本批次，不清空已验证通过的数据批次，除非确认需要全量重跑
