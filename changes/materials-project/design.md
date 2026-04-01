## Context

工程项目管理页面需要基于 `t_project` 实现一体化工程编码下拉选择、表单字段调整、导出功能增强等需求。

当前状态：

1. `master.t_project` 表已创建，字段覆盖施工许可证、工程名称、工程进度、施工单位等 23 个字段。
2. `master.jck_t_gc_sgxkz` 已存在，18,775 条记录，作为一体化工程编码数据源。
3. 后端 `MatProjectController` 路径保持 `/materials/project` 不变，底层已改为读写 `t_project`。
4. 前端 `views/materials/project/index.vue` 已完成一体化工程编码下拉、导出按钮等基本改造。

## Goals / Non-Goals

**Goals**

- 工程项目 CRUD 完整基于 `master.t_project`。
- 一体化工程编码下拉选择功能可用（打开 dialog 立即加载，支持按许可证号或工程名称过滤）。
- 新增表单字段规则正确：施工许可证/发证日期非必填，有无填报/对接状态不显示。
- 列表操作按钮：新增、导出、导出已开工未填报项目表。
- 字典数据从旧 F_Id 映射为新短编码。
- 历史数据从 `test.t_project` 迁移到 `master.t_project`。

**Non-Goals**

- 本次不涉及建材产品页面（`t_project_product`），该部分在 `materials-project-product-callback` 提案中管理。
- 本次不涉及质量追溯模块。
- 本次不处理消息通知、通知公告等其他模块。

## Decisions

### 1. 主表统一为 `master.t_project`

原因：

- `test.t_project` 有完整历史数据（3,746 条），且后续质量追溯依赖该表。
- 工程项目主数据统一以 `master.t_project` 为准，避免并行口径。

设计决策：

- 使用已有的 `master.t_project`，字段与 `test.t_project` 对齐，补足 `tenant_id`、`create_dept`、审计字段、逻辑删除字段。
- `MatProjectController`、`MatProjectMapper` 等现有入口不改路径，只改底层映射。

### 2. 一体化工程编码通过下拉选择关联

原因：

- 工程项目与施工许可证存在天然关联关系（`construction_permit` ↔ `sgxkz_zh`）。
- test.t_project 中 3,186/3,746 条可通过此关系匹配到 `jck_t_gc_sgxkz`。

设计决策：

- 数据源：`master.jck_t_gc_sgxkz`（已存在，无需迁移）。
- 后端：`GET /materials/project/sgxkzPage` 分页查询接口，返回 `gc_code`、`sgxkz_gcmc`(projectName)、`sgxkz_zh`(permit)、`sgxkz_sgdw`(constructionUnit)。
- 前端：`el-select` filterable + remote，打开 dialog 时立即加载第一页（空关键词触发），支持按许可证号或工程名称模糊搜索。
- 选中后自动填充 `construction_permit` 和 `is_integrated = '1'`。
- 下拉每行展示三个字段：`gc_code`（工程编码）、`sgxkz_gcmc`（工程名称）、`sgxkz_zh`（许可证号）。

### 3. 字典值映射方案

原因：

- 旧数据使用 `F_Id`（长数字 ID）作为字典值，新系统使用 `F_EnCode`（短编码）。

设计决策：

- 通过 `test.base_dictionarydata` 表的 `F_Id`（旧值）与 `F_EnCode`（新值）建立映射。
- 逐字段执行 UPDATE：`project_progress`、`project_nature`、`structure_type`、`quality_supervision_agency`。
- 迁移脚本：`sql/migrate/migrate_dict_values_in_t_project.sql`。

### 4. 新增表单字段规则

设计决策：

- 施工许可证、施工许可证发证日期：**非必填**（新增时）。
- 有无填报、是否对接一体化平台编码：**不显示**（新增时，由系统自动设置）。
- 一体化工程编码：作为表单第一个字段，span=24，非必填。

### 5. 列表操作按钮

设计决策：

- 保留：新增、导出、导出已开工未填报项目表。
- 移除：批量删除按钮、列表多选列。
- 导出已开工未填报：过滤条件为工程进度排除 `shqzbjd`（施工前准备阶段）和 `tfkwjjkzhjd`（土方开挖及基坑支护阶段），且 `has_report = '0'`。

### 6. 兼容策略

- 菜单路径保留 `materials/project`。
- 控制器路径保留 `/materials/project`。
- 通过 mapper、domain、vo 调整吸收底层表结构变化，降低前端改动面。

## Backend Design

### 控制器：MatProjectController

保留路径 `/materials/project`，主要接口：

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/list` | 分页查询工程项目 |
| GET | `/{id}` | 查询工程项目详情 |
| POST | `/` | 新增工程项目 |
| PUT | `/` | 修改工程项目 |
| DELETE | `/{ids}` | 删除工程项目 |
| GET | `/sgxkzPage` | 一体化工程编码分页查询 |
| POST | `/export` | 导出工程项目列表 |
| POST | `/exportUnreported` | 导出已开工未填报项目表 |

### Mapper：MatProjectMapper

- 主查询：`FROM t_project`，LEFT JOIN `t_companyinfo` 获取施工单位名称。
- 一体化编码查询：`FROM jck_t_gc_sgxkz`，过滤 `sgxkz_zh IS NOT NULL AND sgxkz_zh != '' AND sgxkz_zh != '0'`。
- 导出已开工未填报：`WHERE project_progress NOT IN ('shqzbjd', 'tfkwjjkzhjd') AND has_report = '0'`。

### Service：IMatProjectService / MatProjectServiceImpl

- `selectMatProjectPageList`：分页查询，支持按施工许可证、工程名称、工程进度、质量监督机构、施工单位、有无填报、对接状态筛选。
- `selectSgxkzPage`：一体化编码分页查询，支持按关键词模糊搜索（匹配 `sgxkz_gcmc` 或 `sgxkz_zh`）。
- `selectUnreportedProjects`：查询已开工未填报项目列表。
- `insertMatProject` / `updateMatProject`：新增/修改，底层读写 `t_project`。

## Frontend Design

### 页面：views/materials/project/index.vue

**搜索区**

- 工程名称（input）、施工许可证（input）、工程进度（select gcjd）、质量监督机构（select zljdjg）、施工单位名称（input）、有无填报（select has_report）、是否对接一体化平台编码（select is_integrated）。

**列表区**

- 序号、工程名称、施工许可证、工程进度、工程地址、施工单位、施工单位负责人、施工单位负责人联系方式、质量监督机构、有无填报、对接一体化平台编码、创建时间、操作（查看/修改/删除）。
- 无多选列。

**操作按钮**

- 新增（`materials:project:add`）
- 导出（`materials:project:export`）
- 导出已开工未填报项目表（`materials:project:export`）

**新增/编辑 Dialog**

- 一体化工程编码（el-select filterable remote，span=24，打开 dialog 立即加载）
  - 下拉每行：`gc_code - 工程名称 - 许可证号`
  - 提示文字："注：可使用施工许可证号或工程名称过滤"
  - 选中后自动填充施工许可证、设置 is_integrated='1'
- 施工许可证（非必填）
- 施工许可证发证日期（非必填）
- 工程名称（必填）
- 工程性质（字典 gcxz，必填）
- 建筑面积（必填）
- 工程进度（字典 gcjd，必填）
- 工程地址（必填）
- 工程结构型式（字典 gcjgxs，必填）
- 质量监督机构（字典 zljdjg，必填）
- 施工单位（必填）
- 施工单位负责人（必填）
- 施工单位负责人联系方式（必填，手机号校验）
- 有无填报：**不显示**（新增时）
- 是否对接一体化平台编码：**不显示**（新增时）
- 备注

**详情 Dialog**

- 使用 el-descriptions 展示所有字段，含字典标签渲染。

### API：api/materials/project.js

| 函数 | 方法 | 路径 | 说明 |
|------|------|------|------|
| `listProject` | GET | `/materials/project/list` | 分页查询 |
| `getProject` | GET | `/materials/project/{id}` | 查询详情 |
| `addProject` | POST | `/materials/project` | 新增 |
| `updateProject` | PUT | `/materials/project` | 修改 |
| `delProject` | DELETE | `/materials/project/{id}` | 删除 |
| `listSgxkzPage` | GET | `/materials/project/sgxkzPage` | 一体化编码分页 |
| `exportProject` | POST | `/materials/project/export` | 导出列表 |
| `exportUnreported` | POST | `/materials/project/exportUnreported` | 导出已开工未填报 |

## SQL Design

### 执行顺序

1. `sql/tables/base_t_project.sql` — 建表（已执行）
2. `sql/migrate/migrate_t_project.sql` — 数据迁移（`test.t_project` → `master.t_project`）
3. `sql/migrate/migrate_dict_values_in_t_project.sql` — 字典值映射（F_Id → 短编码）

### `master.t_project` 核心字段

| 分类 | 字段 |
|------|------|
| 主键/租户 | id, tenant_id |
| 施工许可 | construction_permit, permit_issue_date |
| 工程信息 | project_name, project_nature, building_area, project_progress, project_address, structure_type |
| 监督/施工 | quality_supervision_agency, construction_unit, construction_unit_manager, manager_contact |
| 状态 | has_report, is_integrated |
| 备注 | remarks |
| 审计 | create_by, create_time, update_by, update_time, del_flag, create_dept |

### 关联关系

```text
t_project.construction_permit  ←→  jck_t_gc_sgxkz.sgxkz_zh
```

## Risks / Trade-offs

1. **字典映射不完整**：如果旧数据中存在 `F_Id` 在 `test.base_dictionarydata` 中找不到对应记录的情况，迁移后字段值会残留旧 ID。需在迁移后验证数据完整性。
2. **一体化编码匹配率**：test.t_project 中 3,186/3,746 条可匹配到 `jck_t_gc_sgxkz`，约 15% 无法匹配，这部分项目的 `is_integrated` 字段值不会被自动设置。
3. **表单体验**：一体化编码下拉数据量较大（约 17,872 条有效记录），分页加载 + 远程搜索是必要的，但首次加载可能较慢。
4. **施工单位字段**：spec 中要求施工单位为下拉选择（来自 `t_companyinfo`），当前实现仍为 disabled 输入框，后续需调整。
