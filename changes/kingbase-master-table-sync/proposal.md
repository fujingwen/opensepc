# Kingbase Master 缺表补齐

## Why

截至 2026-04-07，对以下两个库的 `master` schema 做了实际对比：

- PostgreSQL `192.168.0.77:15432/building_supplies_supervision`
- KingbaseES `192.168.0.67:54323/building_supplies_supervision`

对比结果表明：

- PostgreSQL `master` schema 有 `112` 张基础表
- KingbaseES `master` schema 有 `107` 张基础表
- KingbaseES 缺少以下 `6` 张表：
  - `base_message`
  - `base_message_receive`
  - `base_message_template`
  - `sys_dict_type`
  - `sys_logininfor`
  - `t_product_relation`

这些表并非纯历史残留对象，而是当前项目运行依赖的一部分：

- 消息中心依赖 `base_message`、`base_message_receive`
- 消息模板方案依赖 `base_message_template`
- 字典能力依赖 `sys_dict_type`
- 登录日志能力依赖 `sys_logininfor`
- 质量追溯能力依赖 `t_product_relation`

如果不先补齐这些表，当前金仓环境会出现以下问题：

- 消息中心相关查询和写入无法落库
- 字典类型管理能力不完整
- 登录日志无法与当前代码结构对齐
- 质量追溯关联查询无法稳定运行
- 已完成的 OpenSpec 设计在金仓库无法完整落地

## What Changes

本次变更先定义“提案与迁移边界”，后续按提案执行实际迁移。

本次提案要求后续迁移阶段完成：

- 在 KingbaseES `master` schema 中补齐缺失的 `6` 张表
- 保持表名、主键、核心字段、默认值、索引与 PostgreSQL 源库一致或兼容等价
- 对需要兼容改写的对象单独处理，不做无验证照搬
- 对缺失表中的历史数据执行迁移与校验

本次提案不包含：

- 删除 KingbaseES 中额外存在的 `base_region`
- 清理 PostgreSQL 中其他非本次差集对象
- 修改业务功能范围
- 修改前端交互或接口契约

## Scope

### 1. 消息相关表

- `master.base_message`
- `master.base_message_receive`
- `master.base_message_template`

这些表用于承接当前消息中心设计与历史消息迁移方向。

### 2. 系统基础表

- `master.sys_dict_type`
- `master.sys_logininfor`

其中：

- `sys_dict_type` 为系统字典类型表，已有数据 `152` 行
- `sys_logininfor` 为系统访问记录表，已有数据 `2444` 行

### 3. 质量追溯关联表

- `master.t_product_relation`

该表在 PostgreSQL 中已有 `1058` 行，当前质量追溯查询已直接依赖。

## Current Data Snapshot

源库 PostgreSQL 中相关表的现状如下：

- `base_message`: `22` 行
- `base_message_receive`: `177258` 行
- `base_message_template`: `0` 行
- `sys_dict_type`: `152` 行
- `sys_logininfor`: `2444` 行
- `t_product_relation`: `1058` 行

其中 `base_message_receive` 体量最大，约 `54 MB`，后续迁移时应采用可回滚、可校验的批量导入方案。

## Compatibility Risks

### 1. `sys_dict_type` 默认值依赖函数

PostgreSQL 源库中：

- `master.sys_dict_type.dict_id` 默认值依赖 `public.generate_snowflake_id()`

已确认 KingbaseES 当前库中未发现该函数。因此后续迁移不能直接照搬默认值，必须二选一：

- 在 KingbaseES 中补齐兼容函数
- 或将默认值改为应用侧赋值/显式写入

### 2. 表缺失并非单纯文档差异

当前代码已直接依赖缺失表，后续迁移必须优先保证：

- DDL 先到位
- 索引同步到位
- 数据迁移后再做功能验证

### 3. 数据口径需保持现有 OpenSpec 一致

已有变更中已经明确以下方向：

- `message-center` 依赖 `base_message` / `base_message_receive` / `base_message_template`
- `quality-trace` 依赖 `t_product_relation`
- `dict-migration-test-to-master` 依赖 `sys_dict_type`

因此后续迁移不能重新发明表结构，必须优先遵循现有设计资产和真实源库结构。

## Proposed Execution Order

后续迁移阶段建议按以下顺序执行：

1. 在 KingbaseES 中补齐缺失表结构
2. 补齐主键、唯一键、必要索引
3. 单独处理 `sys_dict_type` 的默认值兼容问题
4. 迁移小表数据
   - `base_message`
   - `base_message_template`
   - `sys_dict_type`
   - `sys_logininfor`
   - `t_product_relation`
5. 分批迁移大表数据
   - `base_message_receive`
6. 执行行数校验、抽样校验、代码链路验证

## Impact

- OpenSpec
  - `openspec/changes/kingbase-master-table-sync/**`
- Database
  - KingbaseES `master` schema
- Backend runtime
  - 消息中心
  - 字典类型管理
  - 登录日志
  - 质量追溯

## Success Criteria

后续迁移完成后，应满足：

- 金仓 `master` schema 中存在上述 `6` 张表
- 表结构与 PostgreSQL 源库一致或兼容等价
- 相关索引与约束齐全
- 数据行数与源库对齐
- 消息中心、字典、登录日志、质量追溯相关查询链路可运行
