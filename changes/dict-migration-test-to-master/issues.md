## 审查时间

- 2026-04-03

## 已完成事项

1. ~~清理脚本已从“按 `dict_id 201-305` 直接物理删除”调整为“冲突检查并跳过，不删除已有手动字典”，proposal/spec/SQL 口径已同步。~~
2. ~~`sql/migrate/migrate_dict.sql` 已对 `sys_dict_data(dict_type, dict_value)` 增加 `NOT EXISTS` 去重判断，脚本具备幂等性。~~

## 未完成问题

### 中优先级

#### 1. 设计文档中的迁移结果统计与当前实库不一致

- 源表 `test.base_dictionarytype/base_dictionarydata` 的实际统计仍为 `38 / 292`。
- 当前目标库中本次迁移生成的数据为 `38 / 300`。
- 差异集中在 `zljdjg`，目标库多出的 8 条数据备注写明来自 `test.base_organize`。
- 这意味着当前环境结果已不再是“只由本提案两张源表迁移得到”的纯结果，design/spec 口径需要回写。

#### 2. 允许迁移空字典类型的行为尚未写成明确验收约束

- 当前迁移进 `master.sys_dict_type` 的 38 个类型里，有 3 个没有任何 `sys_dict_data`：
  - `FunctionExample`
  - `qdjc`
  - `workFlow`
- 脚本行为本身没有问题，但 proposal/design 没有说明“允许迁移空字典类型”，验收时容易产生歧义。

#### 3. 新旧 `dict_type` 编码切换缺少完整验收闭环

- design 已写明编码会从 `project_progress/project_nature/...` 切换为 `gcjd/gcxz/...`。
- 当前工程项目页面和 `master.t_project` 已基本切换到新编码。
- 但 proposal 仍停留在“需要确认前后端引用一致”的风险提示，没有明确哪些模块必须全部切换完成，也没有形成可核验的验收项。

## 数据库核对

1. 已连接开发库 `building_supplies_supervision`。
2. 已核对 `test.base_dictionarytype`、`test.base_dictionarydata`、`master.sys_dict_type`、`master.sys_dict_data`、`master.t_project`。
3. 当前数据库事实：
   - 源表非树形字典类型：38
   - 源表对应字典数据：292
   - 目标表本次迁移生成的字典类型：38
   - 目标表本次迁移生成的字典数据：300
   - `dict_id 201-305` 范围残留：0
   - `sys_dict_data` 约束/索引：无
