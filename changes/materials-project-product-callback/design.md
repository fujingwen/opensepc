## Context

当前材料填报模块存在“业务入口已建、主数据方向不准”的问题：

1. 代码层仍以 `mat_project`、`mat_product` 为核心。
2. 数据层真实规模和后续迁移方案已经转向 `t_project`、`t_project_product`。
3. 质量追溯模块依赖项目与产品主链路，尤其“缺陷建材使用情况”需要稳定的项目产品关系。

本变更先矫正主链路，再允许质量追溯继续推进。

## Goals / Non-Goals

**Goals**

- 在 `master` schema 建立并启用 `t_project` 作为工程项目主表。
- 将工程项目读写链路从 `mat_project` 回调到 `t_project`。
- 将建材产品读写链路从 `mat_product` 回调到 `t_project_product`。
- 在 OpenSpec 层面明确质量追溯四页依赖顺序。
- 尽量保持已有菜单路径、接口路径、前端页面入口不变。

**Non-Goals**

- 本次不直接实现质量追溯四个页面。
- 本次不直接迁移 `test.t_quality_trace` 到 `master.t_quality_trace`。
- 本次不重做建材填报所有业务字段，只先完成主承载表和关联方向矫正。
- 本次不处理消息通知、通知公告等其他模块。

## Decisions

### 1. 工程项目主表统一为 `master.t_project`

原因：

- `test.t_project` 有完整历史数据。
- `master.mat_project` 数据极少，不能继续作为后续模块依赖。
- 质量追溯中的使用情况页需要项目主表稳定存在。

设计决策：

- 新建 `master.t_project`。
- 字段优先与 `test.t_project` 对齐，并补足 `tenant_id`、`create_dept`、审计字段、逻辑删除字段。
- `MatProjectController`、`MatProjectMapper` 等现有入口不改路径，只改底层映射。

### 2. 建材产品主表统一为 `master.t_project_product`

原因：

- `t_project_product` 已经承载大量真实数据。
- 继续开发 `mat_product` 会与后续质量追溯、项目使用情况统计产生双轨数据问题。

设计决策：

- `/materials/product` 继续保留。
- 底层查询、详情、编辑、导出统一改为面向 `t_project_product`。
- 需要项目信息时，通过 `project_id -> t_project.id` 关联，而不是 `mat_project`。

### 3. 质量追溯作为第二阶段能力

四页中依赖程度不同：

- “抽测缺陷建材产品”“检测缺陷建材产品”主要依赖 `t_quality_trace`。
- “缺陷建材使用情况”强依赖 `t_project + t_project_product + t_quality_trace`。
- “缺陷建材厂家”需要质量追溯与厂家口径统一。

设计决策：

- 本次仅定义依赖门槛，不直接开发质量追溯页面。
- 后续质量追溯变更必须引用本次回调后的主数据链路。

### 4. 兼容策略

- 菜单路径保留 `materials/project`、`materials/product`。
- 控制器路径保留 `/materials/project`、`/materials/product`。
- 尽量通过 mapper、domain、vo 调整吸收底层表结构变化，降低前端改动面。

## Backend Design

### 1. 工程项目

- 保留控制器：`MatProjectController`
- 调整服务与 mapper 指向 `t_project`
- 主要接口保持不变：
  - `GET /materials/project/list`
  - `GET /materials/project/{id}`
  - `POST /materials/project`
  - `PUT /materials/project`
  - `DELETE /materials/project/{ids}`

关键改造点：

- `MatProjectMapper.xml` 的 `FROM mat_project` 改为 `FROM t_project`
- 统一处理 `tenant_id`、`del_flag`
- BO/VO 字段名向 `t_project` 实际列名对齐

### 2. 建材产品

- 保留控制器：`MatProductController`
- 调整服务与 mapper 指向 `t_project_product`
- 主要接口保持不变：
  - `GET /materials/product/list`
  - `GET /materials/product/{id}`
  - `POST /materials/product`
  - `PUT /materials/product`
  - `DELETE /materials/product/{ids}`
  - `POST /materials/product/export`

关键改造点：

- `MatProductMapper.xml` 的主表改为 `t_project_product`
- 关联表从 `mat_project` 改为 `t_project`
- 梳理原页面使用的查询条件与 `t_project_product` 字段映射关系

## Frontend Design

### 1. 工程项目页

- 保留 `views/materials/project/index.vue`
- 保留搜索区、列表、详情/编辑弹窗交互
- 调整返回字段适配：
  - 施工许可
  - 工程名称
  - 工程进度
  - 质量监督机构
  - 施工单位等

### 2. 建材产品页

- 保留 `views/materials/product/index.vue`
- 保留原有多条件查询布局
- 调整接口字段映射：
  - 项目名称、施工单位、工程进度
  - 产品名称、规格、厂家、批号
  - 信息确认状态等

## SQL Design

### 1. 执行顺序

1. `sql/tables/base_t_project.sql`
2. `sql/indexes/base_indexes.sql`
3. `sql/menu/base_menu.sql`
4. `sql/migrate/migrate_t_project.sql`

### 2. `master.t_project`

表职责：

- 承载迁移后的工程项目主数据
- 作为 `t_project_product`、后续 `t_quality_trace`、质量追溯使用情况页的统一关联入口

核心字段：

- `id`
- `tenant_id`
- `construction_permit`
- `permit_issue_date`
- `project_name`
- `project_progress`
- `project_address`
- `quality_supervision_agency`
- `construction_unit`
- `create_by/create_time/update_by/update_time`
- `del_flag`
- `create_dept`

### 3. 数据迁移

`migrate_t_project.sql` 负责：

- 从 `test.t_project` 补录到 `master.t_project`
- `tenant_id` 缺失时补默认值 `'000000'`
- `del_flag` 缺失时补 `0`
- `create_dept` 缺失时补 `'103'`

## Risks / Trade-offs

1. `t_project` 在 `master` 中当前尚不存在，先建表再改代码是必须步骤。
2. `t_project_product` 的真实字段口径需要与前端现有查询项逐一映射，回调过程可能暴露旧页面字段命名不一致问题。
3. 旧的 `materials-project`、`materials-product` OpenSpec 提案仍在仓库中，后续需要以本变更为准，避免团队继续误用旧文档。
4. 质量追溯如果绕过本变更直接开发，“缺陷建材使用情况”页面会出现高概率返工。
