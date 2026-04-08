## Context

当前材料填报模块存在“业务入口已建、主数据方向不准”的问题：

1. 工程项目与建材产品需要统一到 `t_project`、`t_project_product`。
2. 数据层真实规模和后续迁移方案已经转向 `t_project`、`t_project_product`。
3. 质量追溯模块依赖项目与产品主链路，尤其“缺陷建材使用情况”需要稳定的项目产品关系。

本变更先矫正主链路，再允许质量追溯继续推进。

## Goals / Non-Goals

**Goals**

- 在 `master` schema 建立并启用 `t_project` 作为工程项目主表。
- 将工程项目读写链路统一到 `t_project`。
- 将建材产品读写链路统一到 `t_project_product`。
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
- 工程项目主数据统一以 `master.t_project` 为准。
- 质量追溯中的使用情况页需要项目主表稳定存在。

设计决策：

- 新建 `master.t_project`。
- 字段优先与 `test.t_project` 对齐，并补足 `tenant_id`、`create_dept`、审计字段、逻辑删除字段。
- `MatProjectController`、`MatProjectMapper` 等现有入口不改路径，只改底层映射。

### 2. 建材产品主表统一为 `master.t_project_product`

原因：

- `t_project_product` 已经承载大量真实数据。
- 如果不统一到 `t_project_product`，会与后续质量追溯、项目使用情况统计产生双轨数据问题。

设计决策：

- `/materials/product` 继续保留。
- 底层查询、详情、编辑、导出统一改为面向 `t_project_product`。
- 需要项目信息时，通过 `project_id -> t_project.id` 关联。

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

- `MatProjectMapper.xml` 使用 `FROM t_project`
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
- 关联表统一使用 `t_project`
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
- 列表与详情中的 `project_progress`、`quality_supervision_agency`、`has_report`、`is_integrated` 等字段必须展示业务标签，不得直接输出历史字典 ID
- `construction_unit` 必须展示关联后的施工单位名称，不得回显原始 ID

### 2. 建材产品页

- 保留 `views/materials/product/index.vue`
- 保留原有多条件查询布局
- 调整接口字段映射：
  - 项目名称、施工单位、工程进度
  - 产品名称、规格、厂家、批号
  - 信息确认状态等
- 审核态复用详情弹窗布局，所有表单控件只读，审核操作入口位于弹窗右上角
- 信息确认状态 hover 内容按代理商/生产单位分组展示企业、联系人、电话与失败信息

## SQL Design

### 1. 执行顺序

1. `openspec/changes/materials-project/sql/tables/base_t_project.sql`
2. `openspec/changes/materials-project/sql/migrate/migrate_t_project.sql`
3. `sql/tables/create_t_project_product.sql`
4. `sql/indexes/base_indexes.sql`
5. `sql/menu/base_menu.sql`
6. `sql/migrate/migrate_t_project_product.sql`
7. `sql/migrate/sync_runtime_dicts.sql`

### 2. `master.t_project`

`t_project` 的建表与迁移 SQL 已拆分回 `materials-project` 变更统一维护，本提案不再保留重复副本，避免出现两套脚本口径漂移。

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

- `openspec/changes/materials-project/sql/migrate/migrate_t_project.sql` 负责项目表迁移
- `sql/migrate/migrate_t_project_product.sql` 负责产品表迁移
- `sql/migrate/sync_runtime_dicts.sql` 负责修正 `shbtgyylb` 字典漂移并回填 `info_confirm_unit_type`
- 本提案已删除过期的 `t_project` 重复 SQL 文件，后续不得再从本目录执行项目表建表/迁移脚本

## Frontend Design Details

### 1. 建材产品列表页 Table 改造

| 字段 | 显示要求 | 数据来源 |
|------|---------|---------|
| 进场时间 | 精确到年月日 | `approach_time` |
| 填报时间 | 精确到时分秒 | `create_time` |
| 生产单位名称 | 必显示 | 关联 `t_companyinfo` 通过 `manufacturer_id` |
| 代理商名称 | 必显示，空显示"无" | 关联 `t_companyinfo` 通过 `supplier_id` |
| 生产单位地址 | **隐藏** | - |
| 监理申请 | 字典：是/否 | `is_pass_by_request` |
| 备案证号 | 缺失时显示 `/` | `record_no` |
| 有无备案证号 | 字典，`0` 显示“无” | `has_record_no` |
| 信息确认状态 | 字典，固定在右侧 | `check_status` |

### 2. 查询条件联动设计

产品类别、产品名称、产品规格三级联动：

- **产品类别**：`system_product` 表，`node_type=category`，树状结构查询，返回所有子集
- **产品名称**：选中产品类别后，返回该类别下的第一层级节点；后端需兼容历史 `sys_product` 中 `tree_path` 不完整但 `category_id` 仍正确的记录
- **产品规格**：选中产品名称后，返回该节点下的剩余层级

新增查询条件：
- 生产单位名称：input，模糊查询（关联 `t_companyinfo`）
- 采购数量范围：两个 input，最小值和最大值
- 信息确认单位：select（生产单位/监理单位），需确认字典是否存在

### 3. 新增/编辑表单设计

#### 3.1 工程名称选择
- 查询全部数据（不限1000行）
- 只返回 `id` 和 `projectName`
- 选择后根据 `project_id` 查询项目基本信息
- 自动带出：施工单位名称、施工许可证（disabled）
- 工程进度字段可编辑

#### 3.2 产品类别/名称/规格联动
与查询条件逻辑相同

- 联动查询由 `system-product` 变更提供，服务端查询需同时兼容 `tree_path` 命中类别和 `category_id = categoryId` 两种历史数据口径

#### 3.3 字段位置调整
- 单位字段和产品规格字段互换位置

#### 3.4 图片上传限制
| 字段 | 限制 | 是否必填 |
|------|------|---------|
| 产品合格证 | 最多1张 | 必填 |
| 出厂检验报告 | 最多2张 | 必填 |
| 性能检验报告 | 最多8张 | 必填 |
| 实物照片(带产品标识) | 最多1张 | 必填 |

#### 3.5 时间限制
- 进场时间：限制今天之前（包含今天）

#### 3.6 提示文字
- 采购单价：`建设工程材料价格包括材料原价、包装费、运杂费（含损耗）、采购及保管费，为含增值税（可抵扣进项税额）的现款价格，反映了采集期内批量采购的平均价格水平。`
- 生产批号：`有生产批号必须填生产批号，没有可只填生产日期`
- 供应商名称：`供应商名称填写说明：1、产品为生产厂家直供，填无；2、产品由生产单位已设置的代理商直供，填无；3、其他请填写供应商名称`

### 4. 业务逻辑

#### 4.1 状态流转
- 新增时默认状态：待信息确认（`check_status=0`）

#### 4.2 确认流程（问题11）

当选择了生产单位但未选择代理商时：
1. 新增建材产品，状态为"待信息确认"
2. 直接给生产单位发送消息通知
3. 生产单位确认通过后，状态变更为"已确认"

当同时选择了生产单位和代理商时：
1. 新增建材产品，状态为"待信息确认"
2. 给代理商发送消息通知
3. 代理商确认建材产品信息
4. 代理商确认通过后，生产单位再次确认
5. 双方都确认通过后，状态变更为"已确认"

后端校验要求：
1. `supplier_id` 有值时，`manufacturer_id` 必须同时有值
2. `supplier_id` 对应代理商必须满足 `t_companyinfo.parent_id = manufacturer_id`
3. 不允许仅依赖前端下拉约束代理商与生产单位关系

#### 4.2.1 审核交互补充

- “查看”和“审核”共用同一详情弹窗
- 审核态下所有字段禁用，只允许在右上角执行“审核通过 / 审核不通过”
- 点击“审核不通过”后，弹出次级弹窗选择不通过类别并填写不通过原因

#### 4.2.2 状态悬浮提示补充

- hover 内容按代理商、生产单位两个企业块分组展示
- 公司、联系人、电话三个展示字段固定宽度、左对齐、超出换行
- 某一方审核不通过时，不通过类别与原因展示在该企业块内部，不与该企业信息再加分隔线
- 仅不同企业块之间保留分隔线

#### 4.3 按钮调整
- 移除批量删除按钮
- 保留单个删除按钮

### 5. 字典数据确认（问题5）

需确认以下字段的数据库值与字典对照：

| 字段 | 数据库字段 | 类型 |
|------|-----------|------|
| 有无备案证号 | `has_record_no` | integer |
| 信息确认状态 | `check_status` | integer |
| 监理申请 | `is_pass_by_request` | integer |
| 信息确认单位 | `info_confirm_unit` | integer |
| 信息确认不通过类别 | `check_first_fail_reason` / `supplier_check_first_fail_reason` | varchar |

已确认的补充事实：

- 新库 `info_confirm_unit_type` 曾缺少明细数据，需按旧库补齐 `1=生产单位`、`2=监理单位`
- 新库 `shbtgyylb` 曾存在 `sys_dict_type` 与 `sys_dict_data.dict_type` 不一致的问题，需按旧库修正
- `t_project_product.check_first_fail_reason` 与供应商对应字段存在历史值直接保存 `base_dictionarydata.id` 的情况，前端展示必须同时兼容 `sys_dict_data.dict_value` 和历史字典 ID

## Risks / Trade-offs

1. `t_project` 在 `master` 中当前尚不存在，先建表再改代码是必须步骤。
2. `t_project_product` 的真实字段口径需要与前端现有查询项逐一映射，回调过程可能暴露旧页面字段命名不一致问题。
3. 旧的 `materials-project`、`materials-product` OpenSpec 提案仍在仓库中，后续需要以本变更为准，避免团队继续误用旧文档。
4. 质量追溯如果绕过本变更直接开发，“缺陷建材使用情况”页面会出现高概率返工。
