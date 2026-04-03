## Why

当前“工程项目”“建材产品”“质量追溯”三块能力的主数据链路并不一致，已经出现设计方向和实际承载表脱节的问题：

- 现有功能应统一围绕 `master.t_project`、`master.t_project_product` 开发。
- 实际数据库主承载表应统一为 `master.t_project`、`master.t_project_product`。
- 真实业务数据已经主要沉淀在 `test.t_project`、`test.t_project_product`，其中 `test.t_project_product` 已有大规模数据。
- 质量追溯四个页面里，“缺陷建材使用情况”必须依赖“工程项目 -> 建材产品 -> 质量追溯”完整链路，因此必须统一到 `t_project` / `t_project_product`。

因此需要先做一个统一的回调变更，把工程项目与建材产品的主链路纠正到 `master.t_project`、`master.t_project_product`，再以此作为质量追溯模块落地前提。

## Supersedes

本变更已整合并替代以下两个旧提案，后续不再以它们为继续开发依据：

- ~~`materials-project`~~（工程项目，已合并到本变更第一阶段）
- ~~`materials-product`~~（建材产品，已合并到本变更第一阶段）

## What Changes

- 新建 `materials-project-product-callback` 变更。
- 第一阶段：工程项目主链路回调。
  - 在 `master` schema 建立 `t_project`。
  - 将 `test.t_project` 迁移到 `master.t_project`。
  - 将工程项目相关后端与前端统一到 `t_project`。
- 第一阶段：建材产品主链路回调。
  - 统一以 `master.t_project_product` 作为建材产品主表。
  - 将建材产品相关后端与前端统一到 `t_project_product`。
  - 保留现有 `/materials/project`、`/materials/product` 业务入口，避免页面菜单和调用方大面积调整。
- 第二阶段：质量追溯依赖约束。
  - 明确质量追溯四页必须建立在 `t_project`、`t_project_product` 主链路稳定之后。
  - 将“抽测缺陷建材产品”“检测缺陷建材产品”“缺陷建材使用情况”“缺陷建材厂家”定义为后续变更，不在本次直接实现。
- 明确旧方向变更的状态：
  - `materials-project`、`materials-product` 中旧表口径不再作为继续开发依据。

## Capabilities

### New Capabilities

- `materials_project_callback`
  - 系统可基于 `master.t_project` 提供工程项目查询、详情、维护能力。
  - 系统可从 `test.t_project` 将历史工程项目数据迁移到 `master.t_project`。
- `materials_product_callback`
  - 系统可基于 `master.t_project_product` 提供建材产品查询、详情、维护能力。
  - 系统可保持现有建材填报模块入口不变，但底层统一切换到 `t_project_product`。
- `quality_trace_dependency_gate`
  - 系统在需求与实现层面明确质量追溯四页依赖项目/产品主链路，不允许绕过该前置条件直接定版。

### Capability Details

#### 1. 工程项目回调

- 主表：`master.t_project`
- 数据来源：`test.t_project`
- 页面入口：继续使用 `materials/project/index`
- 接口入口：继续使用 `/materials/project`
- 约束：
  - 查询、详情、新增、编辑、删除全部围绕 `t_project`
  - 工程项目仅以 `t_project` 作为主读写表

#### 2. 建材产品回调

- 主表：`master.t_project_product`
- 数据来源：优先延续既有 `test.t_project_product -> master.t_project_product` 迁移成果
- 页面入口：继续使用 `materials/product/index`
- 接口入口：继续使用 `/materials/product`
- 约束：
  - 列表、详情、编辑、导出等能力全部围绕 `t_project_product`
  - 如需项目信息，统一关联 `t_project`
  - 建材产品仅以 `t_project_product` 作为主读写表

#### 2.1 建材产品前端改造

基于 issues.md 中梳理的15个问题，本次变更需同步完成以下前端改造：

- **Table 表格改造**：进场时间精确到年月日、增加生产单位名称和代理商名称字段、隐藏生产单位地址、字典字段规范化显示、代理商名称空值处理、信息确认状态固定右侧
- **查询条件联动**：产品类别/产品名称/产品规格三级 Select 联动查询、产品类别基于 `system_product` 树状结构、新增生产单位名称模糊查询、新增采购数量范围查询、新增信息确认单位下拉
- **新增/编辑表单**：工程名称查询优化（不限数量）、选择后自动带出施工单位名称和施工许可证、产品图片上传限制调整、进场时间限制、输入框提示文字完善
- **业务逻辑**：确认流程（代理商确认 -> 生产单位确认）、默认待信息确认状态、移除批量删除按钮
- **字典数据**：确认"有无备案证号"、"信息确认状态"、"监理申请"字段值与字典对照

#### 3. 质量追溯前置条件

- 质量追溯四页拆分为后续阶段能力：
  - 抽测缺陷建材产品
  - 检测缺陷建材产品
  - 缺陷建材使用情况
  - 缺陷建材厂家
- 其中“缺陷建材使用情况”必须依赖：
  - `t_project`
  - `t_project_product`
  - 后续迁移后的 `t_quality_trace`
- 本次变更不直接落质量追溯页面代码，只固化前置顺序与数据主链路。

## Manual Alignment

对照《青岛市建设工程材料信息管理平台操作手册》，当前建材产品实现与手册还存在以下差异：

- 手册要求未审核记录可编辑、删除；当前实现仅允许首轮“不通过”后编辑/删除。
- 手册允许“无备案证号”场景继续保存并改为按生产单位录入；当前后端仍把 `recordNo` 作为新增必填项。
- 手册要求“生产批号 / 生产日期”至少填写一项；当前未形成明确校验。
- 手册要求导出最多 2000 条；当前提案和实现都未约束导出上限。

## Impact

- OpenSpec
  - `openspec/changes/materials-project-product-callback/.openspec.yaml`
  - `openspec/changes/materials-project-product-callback/proposal.md`
  - `openspec/changes/materials-project-product-callback/design.md`
  - `openspec/changes/materials-project-product-callback/tasks.md`
  - `openspec/changes/materials-project-product-callback/issues.md`
  - `openspec/changes/materials-project-product-callback/specs/materials_project_callback/spec.md`
  - `openspec/changes/materials-project-product-callback/specs/materials_product_callback/spec.md`
  - `openspec/changes/materials-project-product-callback/specs/quality_trace_dependency_gate/spec.md`
- SQL
  - `openspec/changes/materials-project-product-callback/sql/indexes/base_indexes.sql`
  - `openspec/changes/materials-project-product-callback/sql/menu/base_menu.sql`
  - `openspec/changes/materials-project-product-callback/sql/tables/create_t_project_product.sql`
  - `openspec/changes/materials-project-product-callback/sql/migrate/migrate_t_project_product.sql`
  - `openspec/changes/materials-project/sql/tables/base_t_project.sql`
  - `openspec/changes/materials-project/sql/migrate/migrate_t_project.sql`
- Backend
  - `construction-material-backend/hny-modules/hny-materials/src/main/java/com/hny/materials/controller/MatProjectController.java`
  - `construction-material-backend/hny-modules/hny-materials/src/main/java/com/hny/materials/controller/MatProductController.java`
  - 相关 domain / bo / vo / mapper / service / mapper xml 文件
- Frontend
  - `construction-material-web/src/views/materials/project/index.vue`
  - `construction-material-web/src/views/materials/product/index.vue`
  - `construction-material-web/src/api/materials/project.js`
  - `construction-material-web/src/api/materials/product.js`
  - 建材产品前端涉及的文件（根据 issues.md 问题清单）：
    - Table 表格组件改造
    - 查询条件组件（产品联动、工程名称、生产单位等）
    - 新增/编辑表单组件（图片上传、时间限制、提示文字等）
    - 确认流程相关消息通知
