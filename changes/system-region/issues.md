# system-region 审查问题记录

## 审查时间

- 2026-04-01

## 结论

`system-region` 已有部分代码落地，但当前实现与提案/设计/spec 仍存在多处偏差，暂不建议按“已符合提案”关闭。

## 高优先级问题

### 1. 删除实现不是提案要求的标记删除

- 提案/spec 要求删除时将行政区划记录标记为已删除。
- 当前后端实现调用 `baseMapper.deleteBatchIds(ids)`，属于物理删除。
- 实体虽有 `deleteMark` 字段，但未启用逻辑删除能力。

影响：

- 与提案中的删除语义不一致。
- 删除后数据不可恢复，也不利于审计追踪。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/BaseProvinceServiceImpl.java`
- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/BaseProvince.java`

### 2. 查询接口默认只查根节点，导致搜索结果不完整

- 提案/spec 要求支持按名称、编码、状态查询行政区划数据。
- 当前 `/system/region/list` 在未传 `parentId` 时会默认追加 `parentId = "-1"` 条件。
- 前端搜索表单只传 `fullName`、`enCode`、`enabledMark`，因此搜索实际只能命中顶级节点。

影响：

- 市、区、街道等非根节点无法通过普通搜索查出。
- 与“按名称/编码/状态查询行政区划”的预期不一致。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/BaseProvinceServiceImpl.java`
- `construction-material-web/src/views/system/region/index.vue`

### 3. 编码查询不是模糊查询

- spec 中明确要求支持按编码模糊查询。
- 当前后端对 `enCode` 使用的是 `eq` 精确匹配，不是 `like`。

影响：

- 用户输入部分编码时无法命中结果。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/BaseProvinceServiceImpl.java`

### 4. 设计中约定的 `/system/region/treeselect` 接口缺失

- design 明确列出 `GET /system/region/treeselect` 用于树形选择。
- 当前控制器仅实现了 `/list`、`/{id}`、新增、修改、删除。

影响：

- 树选择数据与列表查询数据未分离。
- 当前前端组件通过复用 `/list` 勉强工作，但不符合设计约定。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/BaseProvinceController.java`

## 中优先级问题

### 5. `/system/region/list` 权限与设计不一致

- design 要求列表查询权限为 `system:region:query`。
- 当前控制器为 `/list` 配置的是 `system:region:list`。

影响：

- 只具备查询权限的角色可能无法访问列表接口。
- 权限模型与提案不一致。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/BaseProvinceController.java`

### 6. RegionSelect 交互未完全符合 common_region_picker 规格

- 规格要求包含 Tab 切换、底部路径展示、取消/确定、清空、编辑回显等完整交互。
- 当前 `RegionSelect` 为 Popover 三列直选。
- 选择市级或区级后会立即提交并关闭，没有明确的“确定”步骤，也没有底部路径展示。

影响：

- 与 spec 中定义的组件行为不一致。
- 后续业务接入时可能出现交互预期偏差。

相关文件：

- `construction-material-web/src/components/RegionSelect/index.vue`

### 7. RegionDialog 编辑回显未完成，且暂未接入业务页面

- spec 要求组件在编辑场景下可回显并自动定位已选节点。
- 当前 `initFromValue()` 只有注释，没有实际回显逻辑。
- 目前仓库内未检索到业务页面使用该组件。

影响：

- `common_region_dialog` 能力尚未真正闭环。

相关文件：

- `construction-material-web/src/components/RegionDialog/index.vue`

### 8. RegionNameFillUtil 未接入实际业务

- design 要求实现后台地区名称自动填充能力。
- 当前仅存在工具类定义，未检索到任何调用点。

影响：

- “工具类已创建”不等于“能力已落地”。
- 业务模块仍无法实际获得自动填充收益。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/utils/RegionNameFillUtil.java`

### 9. 代码字段类型与真实库表不一致

- 代码中 `BaseProvince.type`、`BaseProvinceBo.type`、`BaseProvinceVo.type` 使用的是 `Integer` 语义。
- 实际数据库 `master.base_province.type` 字段类型为 `character varying`。

影响：

- 当前查询条件依赖框架做隐式类型转换，存在兼容性和可维护性风险。
- 后续新增/修改时，类型映射可能引发脏数据或查询行为不稳定。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/BaseProvince.java`
- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/bo/BaseProvinceBo.java`
- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/vo/BaseProvinceVo.java`

### 10. 根节点数据存在 `parent_id is null` 记录，当前代码会漏查

- 实际表数据中共有 2 条记录 `parent_id is null`，同时有 30 条记录 `parent_id = '-1'`。
- 当前后端无 `parentId` 时只查询 `parentId = '-1'`，不会覆盖 `parent_id is null` 的根节点数据。

影响：

- 实际根节点数据会被静默遗漏。
- 前端树形首屏与真实库表不一致。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/BaseProvinceServiceImpl.java`

### 11. 数据表缺少主键/唯一约束/索引，且已存在重复编码

- 连接数据库后未查到 `master.base_province` 上的约束与索引。
- 实际数据中 `en_code='110228001'` 存在 4 条重复记录。
- 当前代码仅在应用层做 `enCode` 唯一校验，但数据库层无法兜底。

影响：

- 并发写入或外部导入时仍可能产生重复编码。
- `selectOne` 类查询在重复数据场景下存在不确定性。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/BaseProvinceServiceImpl.java`

### 12. 删除标记现状与实现假设不一致

- 实际表中 `delete_mark` 45334 条记录全部为 `null`，`0/1/2` 均为 0 条。
- `del_flag` 字段全部为 `0`。
- 当前代码主要依赖 `delete_mark = 0 or is null` 作为有效数据条件，但删除实现却是物理删除。

影响：

- 当前“删除标记”方案尚未真正投入使用。
- 后续若切换软删，需要先统一真实删除字段语义。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/BaseProvince.java`
- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/BaseProvinceServiceImpl.java`

## 验证记录

- 已执行：`openspec validate system-region`
- 结果：通过
- 已执行：`npm run build:prod`（frontend）
- 结果：通过
- 已执行：连接 PostgreSQL 开发库并核对 `master.base_province`
- 核对结果摘要：
  - 表存在：`master.base_province`
  - 总记录数：`45334`
  - `parent_id = '-1'`：`30`
  - `parent_id is null`：`2`
  - `delete_mark is null`：`45334`
  - `del_flag != 0`：`0`
  - 重复 `en_code` 示例：`110228001` 出现 `4` 次
  - 约束/索引：未查到

## 备注

- 本次记录聚焦“是否符合提案/设计/spec”，不是单纯检查代码是否存在。
- 后续建议按“删除语义 -> 查询语义 -> 接口补齐 -> 组件行为补齐”的顺序修复。
