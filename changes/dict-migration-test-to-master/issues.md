## 2026-04-01 提案符合性复审（代码 + 数据库）

### 高优先级

#### 1. 迁移脚本对 `sys_dict_data` 不是幂等的，重复执行会直接插入重复字典数据

- `migrate_dict.sql` 在迁移字典类型时用了 `NOT EXISTS` 防重，见 `sql/migrate/migrate_dict.sql:17-42`。
- 但迁移字典数据时没有对 `dict_type + dict_value` 做任何去重判断，只要目标库里存在该 `dict_type`，就会再次插入整批数据，见 `sql/migrate/migrate_dict.sql:49-87`。
- 我核对了当前数据库，`master.sys_dict_data` 没有唯一约束，也没有任何索引，因此这不是“数据库会兜底拦住”的情况。
- 这和提案里“迁移前清理旧数据、迁移后验证结果”的预期不匹配，一旦脚本重复跑或只执行了第 2 步，就会把同一批字典数据重复写入。

#### 2. 清理脚本按 `dict_id 201-305` 物理删除，策略过于脆弱，和提案的“只清理建材模块手动字典”不完全等价

- `cleanup_old_dict.sql` 直接按 `dict_id >= 201 AND dict_id <= 305` 删除 `sys_dict_type/sys_dict_data`，见 `sql/migrate/cleanup_old_dict.sql:7-14`。
- 这依赖“建材模块手动字典恰好都在 201-305 且只有它们在这个范围内”这一额外前提，但 proposal/spec 并没有把这个前提做成可验证条件。
- 当前库里确实已经没有 201-305 范围残留数据，但脚本本身仍有误删同区间其他字典的风险。

### 中优先级

#### 3. 设计文档里的迁移结果统计与当前实库不一致，`zljdjg` 多出 8 条

- design 里写的源数据规模是“非树形字典类型 38 条、字典数据 292 条”。
- 我连库核对后，源表 `test.base_dictionarytype/base_dictionarydata` 的实际统计仍然是 `38 / 292`，这部分和 design 一致。
- 但目标库里本次迁移生成的记录是 `38 / 300`。
- 差异全部集中在 `zljdjg`：
  - 源表 `zljdjg` 只有 9 条
  - 目标表 `zljdjg` 有 17 条
  - 多出来的 8 条备注明确写着“从 `test.base_organize` 迁移”
- 这说明当前环境里的最终状态，不是“只由本提案的两张字典源表迁移得到”的纯结果；如果把当前数据库状态当成这份提案的验收结果，会和 design/spec 口径不一致。

#### 4. 迁移了 3 个无字典项的类型，proposal 没说明这是预期行为

- 当前迁移进 `master.sys_dict_type` 的 38 个类型里，有 3 个类型没有任何 `sys_dict_data`：
  - `FunctionExample`
  - `qdjc`
  - `workFlow`
- 这 3 个类型在源表 `test.base_dictionarytype` 中也确实存在，且没有对应的未删除字典项。
- 脚本行为本身和 SQL 一致，但 proposal/design 没说明“允许迁移空字典类型”，验收时容易产生歧义。

#### 5. `dict_type` 编码风格迁移后发生了明显变化，但提案只把它当风险提示，没有形成验收闭环

- design 已经写明：编码会从 `project_progress/project_nature/...` 变成 `gcjd/gcxz/...`。
- 当前前端工程项目页面确实已经改成新编码，见 `construction-material-web/src/views/materials/project/index.vue:289-295`。
- 数据库 `master.t_project` 里的相关字段当前也已不再存旧系统长数字 ID，说明这部分迁移配套基本完成。
- 但 proposal 只写“需要确认前后端引用一致”，没有把“哪些模块必须全部切换完成”写成明确验收项，导致这项任务更像口头约定，而不是可核验的规格。

### 已核对结果

- 已连接开发库：`building_supplies_supervision`
- 已核对表：
  - `test.base_dictionarytype`
  - `test.base_dictionarydata`
  - `master.sys_dict_type`
  - `master.sys_dict_data`
  - `master.t_project`
- 当前数据库事实：
  - 源表非树形字典类型：38
  - 源表对应字典数据：292
  - 目标表本次迁移生成的字典类型：38
  - 目标表本次迁移生成的字典数据：300
  - `dict_id 201-305` 范围残留：0
  - `sys_dict_data` 约束/索引：无

### 额外说明

- 就“前后端是否已经在用新编码”这一点看，`materials-project` 页面当前使用 `gcjd/gcxz/gcjgxs/zljdjg`，这部分与迁移后的编码方向是一致的。
- 这次审查的主要问题不在“有没有迁进去”，而在“脚本是否稳妥可重跑”以及“当前库状态是否还能被视为这份提案单独产出的结果”。
