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

- 新建 `materials-project-product` 变更。
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
- **工程项目列表显示修正**：工程进度、施工单位、质量监督机构、有无填报、是否对接一体化平台编码等字段统一按字典标签或关联名称展示，不再直接展示原始 ID 或空值
- **查询条件联动**：产品类别/产品名称/产品规格三级 Select 联动查询、产品类别基于 `system_product` 树状结构、新增生产单位名称模糊查询、新增采购数量范围查询、新增信息确认单位下拉
- **新增/编辑表单**：工程名称查询优化（不限数量）、选择后自动带出施工单位名称和施工许可证、产品图片上传限制调整、进场时间限制、输入框提示文字完善
- **审核交互与状态提示**：审核复用“查看”弹窗，审核态字段全部 disabled，右上角提供“审核通过 / 审核不通过”按钮；点击“审核不通过”后再弹出二次原因填写弹窗；信息确认状态 hover 内容按代理商/生产企业分组展示公司、联系人、电话，并将不通过类别与原因展示在对应企业块下方
- **业务逻辑**：确认流程细化为
  - 有代理商时：代理商先确认，代理商通过后再由生产单位确认，双方都通过后状态才为“已确认”
  - 无代理商时：直接由生产单位确认，生产单位通过后状态直接为“已确认”
  - 后端需强校验所选代理商必须隶属于所选生产单位
  - 默认待信息确认状态、移除批量删除按钮
- **字典数据与历史兼容**：确认"有无备案证号"、"信息确认状态"、"监理申请"、"信息确认单位"、"信息确认不通过类别"字段值与字典对照；备案证号缺失时展示 `/`，`has_record_no=0` 展示“无”；信息确认不通过类别需同时兼容当前 `sys_dict(shbtgyylb)` 和历史 `base_dictionarydata.id`

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

- 本次已闭环：未审核记录可在“待确认 / 不通过 / 待再次确认”状态下编辑删除；“无备案证号”可继续保存；“生产批号 / 生产日期至少填写一项”已补齐校验；导出已补齐 2000 条上限控制。
- 本次补充：审核改为在查看弹窗内完成，不通过时再弹出原因填写弹窗。
- 本次补充：信息确认状态 hover 按代理商/生产企业分组展示，不通过类别与原因挂在对应企业块下方。
- 本次补充：备案证号缺失显示 `/`；信息确认不通过类别展示需兼容历史 `base_dictionarydata.id`。

## Audit Message Alignment Addendum

- 本变更确认建材产品审核提醒走的是站内消息，不是公告；消息需进入右上角铃铛的统一提醒入口，并支持跳转到 `/materials/product?messageBusinessId=...`。
- 施工单位新增建材产品时，若存在代理商，系统向代理商发送“待审核”消息；施工单位在“不通过后重提”时，系统再次向代理商发送“待再次审核”消息。普通编辑不自动重发审核消息。
- 若未选择代理商，则新增或重提后由系统直接向生产单位发送对应的待确认或待再次确认消息。
- 代理商执行“审核通过”或“审核不通过”后，系统需向施工单位补发一条审核结果消息，便于施工单位在消息中心和铃铛入口查看处理结果。
- 若当前待处理审核方超过 48 小时仍未完成审核，系统需补发一条 `timeout` 超时提醒消息；有代理商且代理商仍待处理时提醒代理商，无代理商或代理商已通过后由生产单位待处理时提醒生产单位。
- 超时提醒按“待审核阶段”计数：同一待审核阶段超过 48 小时后只发送 1 次；若记录因重提或流转进入新的待审核阶段，则重新开始 48 小时计时，并在新阶段内最多再次发送 1 次。
- 超时提醒属于审核消息链路的一部分，使用现有消息中心能力承载，不单独扩展公告模块。

## Impact

- OpenSpec
  - `openspec/changes/materials-project-product/.openspec.yaml`
  - `openspec/changes/materials-project-product/proposal.md`
  - `openspec/changes/materials-project-product/design.md`
  - `openspec/changes/materials-project-product/tasks.md`
  - `openspec/changes/materials-project-product/issues.md`
  - `openspec/changes/materials-project-product/specs/materials_project_callback/spec.md`
  - `openspec/changes/materials-project-product/specs/materials_product_callback/spec.md`
  - `openspec/changes/materials-project-product/specs/quality_trace_dependency_gate/spec.md`
- SQL
  - `openspec/changes/materials-project-product/sql/indexes/base_indexes.sql`
  - `openspec/changes/materials-project-product/sql/menu/base_menu.sql`
  - `openspec/changes/materials-project-product/sql/tables/create_t_project_product.sql`
  - `openspec/changes/materials-project-product/sql/migrate/migrate_t_project_product.sql`
  - `openspec/changes/materials-project-product/sql/migrate/sync_runtime_dicts.sql`
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
