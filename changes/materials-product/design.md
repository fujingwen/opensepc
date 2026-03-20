## Context

当前系统已有工程项目管理功能，施工单位可以创建和管理工程项目。现在需要在工程项目下新增建材产品管理功能，用于施工单位填报建材产品信息，包括产品基本信息、生产单位信息、供应商信息、采购信息及相关证明材料。该功能将在现有的 `hny-materials` 模块下实现，遵循现有的模块架构和代码规范。后端使用 Spring Boot 3.2.6 + MyBatis-Plus 3.5.7，前端使用 Vue 3.4.31 + Element Plus 2.7.6。

## Goals / Non-Goals

**Goals:**

- 实现建材产品的增删改查功能
- 提供多条件查询功能（施工单位名称、工程名称、产品类别、产品名称、产品规格、采购数量范围、进场时间范围、填报时间范围等）
- 实现表单验证（必填项、数量验证等）
- 支持字典数据（信息确认状态、信息确认超时、信息确认不通过类别、有无备案证号、工程进度）
- 支持文件上传（产品合格证、出厂检验报告、性能检验报告、实物照片）
- 实现导出功能
- 集成菜单权限控制
- 预留审核功能接口

**Non-Goals:**

- 不实现审核功能的完整业务逻辑（审核流程暂不实现）
- 不涉及建材产品与其他模块的复杂关联
- 不涉及建材产品的历史版本管理
- 不实现产品类别、产品名称、产品规格的三级联动（数据来源待确认，先用 input 实现）

## Decisions

### 数据库设计

**mat_product 表**

```sql
CREATE TABLE "master"."mat_product" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_mat_product'),
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "project_id" bigint NOT NULL,
  "construction_unit_name" varchar(200) NOT NULL,
  "project_progress" varchar(50) NOT NULL,
  "product_category" varchar(100),
  "product_name" varchar(200) NOT NULL,
  "unit" varchar(20),
  "production_unit_name" varchar(200),
  "production_unit_region" varchar(100),
  "production_unit_address" varchar(500),
  "supplier_name" varchar(200),
  "production_batch_number" varchar(100),
  "production_date" date,
  "purchase_quantity" decimal(18,2) NOT NULL,
  "purchase_price" decimal(18,2),
  "product_certificate" varchar(500),
  "factory_inspection_report" varchar(1000),
  "performance_inspection_report" varchar(2000),
  "product_photo" varchar(500),
  "entry_time" date,
  "agent_name" varchar(200),
  "supervision_request" varchar(500),
  "has_certificate_number" varchar(10),
  "certificate_number" varchar(100),
  "info_confirm_status" varchar(50),
  "info_confirm_timeout" varchar(10),
  "info_confirm_fail_type" varchar(50),
  "info_confirm_unit" varchar(200),
  "quality_supervision_agency" varchar(200),
  "del_flag" char(1) DEFAULT '0',
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_time" timestamp NOT NULL DEFAULT now(),
  "create_by" varchar(50),
  "update_by" varchar(50),
  PRIMARY KEY ("id")
);

DROP INDEX IF EXISTS "master"."idx_product_tenant_id";
CREATE INDEX "idx_product_tenant_id" ON "master"."mat_product" ("tenant_id");

DROP INDEX IF EXISTS "master"."idx_product_project_id";
CREATE INDEX "idx_product_project_id" ON "master"."mat_product" ("project_id");

DROP INDEX IF EXISTS "master"."idx_product_construction_unit";
CREATE INDEX "idx_product_construction_unit" ON "master"."mat_product" ("construction_unit_name");

DROP INDEX IF EXISTS "master"."idx_product_name";
CREATE INDEX "idx_product_name" ON "master"."mat_product" ("product_name");

DROP INDEX IF EXISTS "master"."idx_product_entry_time";
CREATE INDEX "idx_product_entry_time" ON "master"."mat_product" ("entry_time");

DROP INDEX IF EXISTS "master"."idx_product_confirm_status";
CREATE INDEX "idx_product_confirm_status" ON "master"."mat_product" ("info_confirm_status");

COMMENT ON COLUMN "master"."mat_product"."id" IS '主键ID';
COMMENT ON COLUMN "master"."mat_product"."project_id" IS '工程项目ID';
COMMENT ON COLUMN "master"."mat_product"."construction_unit_name" IS '施工单位名称';
COMMENT ON COLUMN "master"."mat_product"."project_progress" IS '工程进度';
COMMENT ON COLUMN "master"."mat_product"."product_category" IS '产品类别';
COMMENT ON COLUMN "master"."mat_product"."product_name" IS '产品名称';
COMMENT ON COLUMN "master"."mat_product"."unit" IS '单位';
COMMENT ON COLUMN "master"."mat_product"."production_unit_name" IS '生产单位名称';
COMMENT ON COLUMN "master"."mat_product"."production_unit_region" IS '生产单位省市区';
COMMENT ON COLUMN "master"."mat_product"."production_unit_address" IS '生产单位详细地址';
COMMENT ON COLUMN "master"."mat_product"."supplier_name" IS '供应商名称';
COMMENT ON COLUMN "master"."mat_product"."production_batch_number" IS '生产批号';
COMMENT ON COLUMN "master"."mat_product"."production_date" IS '生产日期';
COMMENT ON COLUMN "master"."mat_product"."purchase_quantity" IS '采购数量';
COMMENT ON COLUMN "master"."mat_product"."purchase_price" IS '采购单价';
COMMENT ON COLUMN "master"."mat_product"."product_certificate" IS '产品合格证';
COMMENT ON COLUMN "master"."mat_product"."factory_inspection_report" IS '出厂检验报告';
COMMENT ON COLUMN "master"."mat_product"."performance_inspection_report" IS '性能检验报告';
COMMENT ON COLUMN "master"."mat_product"."product_photo" IS '实物照片';
COMMENT ON COLUMN "master"."mat_product"."entry_time" IS '进场时间';
COMMENT ON COLUMN "master"."mat_product"."agent_name" IS '代理商名称';
COMMENT ON COLUMN "master"."mat_product"."supervision_request" IS '监理申请';
COMMENT ON COLUMN "master"."mat_product"."has_certificate_number" IS '有无备案证号';
COMMENT ON COLUMN "master"."mat_product"."certificate_number" IS '备案证号';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_status" IS '信息确认状态';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_timeout" IS '信息确认超时';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_fail_type" IS '信息确认不通过类别';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_unit" IS '信息确认单位';
COMMENT ON COLUMN "master"."mat_product"."quality_supervision_agency" IS '质量监督机构';
COMMENT ON COLUMN "master"."mat_product"."del_flag" IS '删除标志(0-存在,2-删除)';
COMMENT ON COLUMN "master"."mat_product"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."mat_product"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."mat_product"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."mat_product"."update_by" IS '更新人';
COMMENT ON TABLE "master"."mat_product" IS '建材产品表';
```

**序列**

```sql
CREATE SEQUENCE IF NOT EXISTS "master"."seq_mat_product"
  START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
```

### 菜单和权限设计

**菜单结构**

```
建材填报管理 (materials)
└── 建材产品
    materials:product:list
    materials/product/index
    ├── 查询: materials:product:query
    ├── 新增: materials:product:add
    ├── 修改: materials:product:edit
    ├── 删除: materials:product:remove
    ├── 详情: materials:product:detail
    ├── 导出: materials:product:export
    └── 审核: materials:product:audit
```

**菜单SQL**

```sql
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000200, '建材产品', 2000001, 2, 'product', 'materials/product/index', 1, 0, 'C', '0', '0', 'materials:product:list', 'example', 103, 1, now(), NULL, NULL, '建材产品管理页面')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000201, '查询', 5000200, 1, '', '', 1, 0, 'F', '0', '0', 'materials:product:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000202, '新增', 5000200, 2, '', '', 1, 0, 'F', '0', '0', 'materials:product:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000203, '修改', 5000200, 3, '', '', 1, 0, 'F', '0', '0', 'materials:product:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000204, '删除', 5000200, 4, '', '', 1, 0, 'F', '0', '0', 'materials:product:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000205, '详情', 5000200, 5, '', '', 1, 0, 'F', '0', '0', 'materials:product:detail', '#', 103, 1, now(), NULL, NULL, ''),
  (5000206, '导出', 5000200, 6, '', '', 1, 0, 'F', '0', '0', 'materials:product:export', '#', 103, 1, now(), NULL, NULL, ''),
  (5000207, '审核', 5000200, 7, '', '', 1, 0, 'F', '0', '0', 'materials:product:audit', '#', 103, 1, now(), NULL, NULL, '');
```

**字典SQL**

```sql
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (105, '000000', '信息确认状态', 'info_confirm_status', 103, now(), '建材填报管理-建材产品-信息确认状态')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (10, '000000', 1, '待信息确认', '1', 'info_confirm_status', '', 'warning', 'Y', 103, now(), ''),
  (11, '000000', 2, '信息确认通过', '2', 'info_confirm_status', '', 'success', 'N', 103, now(), ''),
  (12, '000000', 3, '信息确认不通过', '3', 'info_confirm_status', '', 'danger', 'N', 103, now(), ''),
  (13, '000000', 4, '待再次信息确认', '4', 'info_confirm_status', '', 'warning', 'N', 103, now(), ''),
  (14, '000000', 5, '信息确认再次不通过', '5', 'info_confirm_status', '', 'danger', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (106, '000000', '信息确认超时', 'info_confirm_timeout', 103, now(), '建材填报管理-建材产品-信息确认超时')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (15, '000000', 1, '是', '1', 'info_confirm_timeout', '', 'danger', 'N', 103, now(), ''),
  (16, '000000', 2, '否', '2', 'info_confirm_timeout', '', 'success', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (107, '000000', '信息确认不通过类别', 'info_confirm_fail_type', 103, now(), '建材填报管理-建材产品-信息确认不通过类别')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (17, '000000', 1, '资料不全（不符）', '1', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (18, '000000', 2, '疑似假冒', '2', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (19, '000000', 3, '采购数量不符', '3', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (20, '000000', 4, '品牌填写错误', '4', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (21, '000000', 5, '填报规格与实际供货规格不符', '5', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (22, '000000', 6, '图片清晰度不够，无法辨识', '6', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (23, '000000', 7, '其他', '7', 'info_confirm_fail_type', '', '', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (108, '000000', '有无备案证号', 'has_certificate_number', 103, now(), '建材填报管理-建材产品-有无备案证号')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (24, '000000', 1, '有', '1', 'has_certificate_number', '', 'success', 'N', 103, now(), ''),
  (25, '000000', 2, '无', '2', 'has_certificate_number', '', 'danger', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (109, '000000', '建材产品工程进度', 'product_project_progress', 103, now(), '建材填报管理-建材产品-工程进度')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (26, '000000', 1, '工程安装阶段', '1', 'product_project_progress', '', '', 'N', 103, now(), ''),
  (27, '000000', 2, '测试1', '2', 'product_project_progress', '', '', 'N', 103, now(), ''),
  (28, '000000', 3, '测试2', '3', 'product_project_progress', '', '', 'N', 103, now(), '');
```

### 后端API设计

**建材产品API**

- GET /materials/product/list - 分页查询（支持多条件查询），权限：materials:product:query
- GET /materials/product/{id} - 获取详情，权限：materials:product:detail
- POST /materials/product - 新增，权限：materials:product:add
- PUT /materials/product - 修改，权限：materials:product:edit
- DELETE /materials/product/{ids} - 删除，权限：materials:product:remove
- POST /materials/product/export - 导出，权限：materials:product:export
- PUT /materials/product/audit - 审核，权限：materials:product:audit（暂不实现）

### 前端设计

**页面结构**

- 使用 Element Plus 的 Table 组件展示数据列表
- 使用 Dialog 组件实现新增/修改/详情弹窗
- 使用 Form 组件实现表单验证
- 使用 ElMessage 进行操作反馈
- 使用 Upload 组件实现文件上传

**建材产品页面**

**查询条件**

| 字段名 | 类型 | 查询方式 |
|-------|------|---------|
| 施工单位名称 | input | 模糊查询 |
| 工程名称 | input | 模糊查询 |
| 产品类别 | input | 模糊查询（数据来源待确认） |
| 产品名称 | input | 模糊查询 |
| 产品规格 | input | 模糊查询（数据来源待确认） |
| 生产单位名称 | input | 模糊查询 |
| 采购数量 | input range | 范围查询（最小值~最大值） |
| 进场时间 | date range | 范围查询（开始时间~结束时间） |
| 填报时间 | date range | 范围查询（开始时间~结束时间） |
| 信息确认状态 | select | 字典查询 |
| 信息确认超时 | select | 字典查询 |
| 信息确认不通过类别 | select | 字典查询 |
| 信息确认单位 | input | 模糊查询（数据来源待确认） |
| 质量监督机构 | input | 模糊查询（数据来源待确认） |
| 有无备案证号 | select | 字典查询 |

**列表展示字段**

| 字段名 | 显示格式 |
|-------|---------|
| 序号 | 自增序号 |
| 施工单位名称 | 文本 |
| 工程名称 | 文本 |
| 产品类别 | 文本 |
| 质量监督机构 | 文本 |
| 产品名称 | 文本 |
| 产品规格 | 文本 |
| 工程进度 | 文本 |
| 采购数量 | 数字 |
| 采购单价 | 数字 |
| 进场时间 | YYYY-MM-DD |
| 填报时间 | YYYY-MM-DD HH:mm:ss |
| 生产单位名称 | 文本 |
| 代理商名称 | 文本 |
| 供应商名称 | 文本 |
| 最后更新时间 | YYYY-MM-DD HH:mm:ss |
| 监理申请 | 文本 |
| 有无备案证号 | 字典标签 |
| 备案证号 | 文本 |
| 信息确认状态 | 字典标签 |
| 操作 | 编辑、删除、审核、详情 |

**新增页面字段**

| 字段名 | 类型 | 必填 | 长度限制 | 说明 |
|-------|------|------|---------|------|
| 工程名称 | select | 是 | - | 数据来源：mat_project 表 |
| 施工单位名称 | input | 是 | 200 | - |
| 工程进度 | select | 是 | - | 字典：product_project_progress |
| 产品类别 | input | 否 | 100 | 数据来源待确认 |
| 产品名称 | input | 是 | 200 | - |
| 单位 | input | 否 | 20 | 如：m |
| 生产单位名称 | input | 否 | 200 | - |
| 生产单位省市区 | RegionSelect | 否 | 100 | 非必填 |
| 生产单位详细地址 | input | 否 | 500 | 非必填 |
| 供应商名称 | input | 否 | 200 | 有提示文字 |
| 生产批号 | input | 否 | 100 | - |
| 生产日期 | date | 否 | - | 非必填，有提示文字 |
| 采购数量 | input-number | 是 | - | 必填 |
| 采购单价 | input-number | 否 | - | 有提示文字 |
| 产品合格证 | upload | 否 | - | 最多1张 |
| 出厂检验报告 | upload | 否 | - | 最多2张 |
| 性能检验报告 | upload | 否 | - | 最多8张 |
| 实物照片 | upload | 否 | - | 最多1张 |

**编辑页面字段**

与新增页面字段相同，但仅信息确认状态为"待信息确认"时可编辑。

**详情页面字段**

所有字段只读展示，包括创建时间、更新时间等审计字段。

**表单验证规则**

- 工程名称：必填
- 施工单位名称：必填，最大长度200
- 工程进度：必填
- 产品名称：必填，最大长度200
- 采购数量：必填，大于0

**操作逻辑**

- 编辑/删除：仅信息确认状态为"待信息确认"时可操作
- 审核：预留功能，暂不实现

## Risks / Trade-offs

**字典数据来源未确认:**

- 风险：产品类别、产品名称、产品规格的数据来源不明确，无法实现三级联动
- 缓解措施：先用 input 实现，后续根据实际数据源进行调整

**文件上传存储:**

- 风险：文件上传需要考虑存储位置和访问方式
- 缓解措施：使用系统现有的文件上传机制，存储路径保存到数据库

**查询性能:**

- 风险：多条件查询可能影响性能
- 缓解措施：为常用查询字段创建索引，使用 MyBatis-Plus 的分页插件

**审核功能预留:**

- 风险：审核功能暂不实现，但需要预留接口和数据结构
- 缓解措施：在表结构中预留审核相关字段，API 预留审核接口

**数据一致性:**

- 风险：删除工程项目时可能影响关联的建材产品
- 缓解措施：添加逻辑删除标记，不进行物理删除
