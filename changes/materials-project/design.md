## Context

当前系统需要工程项目管理功能，用于管理工程项目的基本信息、施工进度、施工单位等关键数据。该功能将在现有的 `hny-materials` 模块下实现，遵循现有的模块架构和代码规范。后端使用 Spring Boot 3.2.6 + MyBatis-Plus 3.5.7，前端使用 Vue 3.4.31 + Element Plus 2.7.6。

## Goals / Non-Goals

**Goals:**

- 实现工程项目的增删改查功能
- 提供多条件查询功能（工程名称、施工许可证、工程进度等）
- 实现表单验证（必填项、手机号格式验证等）
- 支持字典数据（工程进度、工程性质、工程结构型式等）
- 集成菜单权限控制

**Non-Goals:**

- 不涉及工程项目与其他模块的复杂关联
- 不涉及工程项目的工作流审批功能
- 不涉及工程项目的历史版本管理

## Decisions

### 数据库设计

**mat_project 表**

```sql
CREATE TABLE "master"."mat_project" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_mat_project'),
  "construction_permit" varchar(100) NOT NULL,
  "permit_issue_date" date NOT NULL,
  "project_name" varchar(200) NOT NULL,
  "project_nature" varchar(50) NOT NULL,
  "building_area" decimal(10,2) NOT NULL,
  "project_progress" varchar(50) NOT NULL,
  "project_address" varchar(500) NOT NULL,
  "structure_type" varchar(50) NOT NULL,
  "quality_supervision_agency" varchar(200) NOT NULL,
  "construction_unit" varchar(200) NOT NULL,
  "construction_unit_manager" varchar(100) NOT NULL,
  "manager_contact" varchar(20) NOT NULL,
  "has_report" varchar(10) NOT NULL,
  "is_integrated" varchar(10) NOT NULL,
  "remarks" text,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_time" timestamp NOT NULL DEFAULT now(),
  "create_by" varchar(50),
  "update_by" varchar(50),
  "del_flag" char(1) DEFAULT '0',
  PRIMARY KEY ("id")
);

DROP INDEX IF EXISTS "master"."idx_project_name";
CREATE INDEX "idx_project_name" ON "master"."mat_project" ("project_name");

DROP INDEX IF EXISTS "master"."idx_construction_permit";
CREATE INDEX "idx_construction_permit" ON "master"."mat_project" ("construction_permit");

DROP INDEX IF EXISTS "master"."idx_construction_unit";
CREATE INDEX "idx_construction_unit" ON "master"."mat_project" ("construction_unit");

COMMENT ON COLUMN "master"."mat_project"."id" IS '主键ID';
COMMENT ON COLUMN "master"."mat_project"."construction_permit" IS '施工许可证';
COMMENT ON COLUMN "master"."mat_project"."permit_issue_date" IS '施工许可证发证日期';
COMMENT ON COLUMN "master"."mat_project"."project_name" IS '工程名称';
COMMENT ON COLUMN "master"."mat_project"."project_nature" IS '工程性质';
COMMENT ON COLUMN "master"."mat_project"."building_area" IS '建筑面积（平方米）';
COMMENT ON COLUMN "master"."mat_project"."project_progress" IS '工程进度';
COMMENT ON COLUMN "master"."mat_project"."project_address" IS '工程地址';
COMMENT ON COLUMN "master"."mat_project"."structure_type" IS '工程结构型式';
COMMENT ON COLUMN "master"."mat_project"."quality_supervision_agency" IS '质量监督机构';
COMMENT ON COLUMN "master"."mat_project"."construction_unit" IS '施工单位';
COMMENT ON COLUMN "master"."mat_project"."construction_unit_manager" IS '施工单位负责人';
COMMENT ON COLUMN "master"."mat_project"."manager_contact" IS '施工单位负责人联系方式';
COMMENT ON COLUMN "master"."mat_project"."has_report" IS '有无填报';
COMMENT ON COLUMN "master"."mat_project"."is_integrated" IS '是否对接一体化平台编码';
COMMENT ON COLUMN "master"."mat_project"."remarks" IS '备注';
COMMENT ON COLUMN "master"."mat_project"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."mat_project"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."mat_project"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."mat_project"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."mat_project"."del_flag" IS '删除标志(0-存在,2-删除)';
COMMENT ON TABLE "master"."mat_project" IS '工程项目表';
```

**序列**

```sql
CREATE SEQUENCE IF NOT EXISTS "master"."seq_mat_project"
  START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
```

### 菜单和权限设计

**菜单结构**

```
建材管理 (materials)
└── 工程项目
    materials:project:list
    materials/project/index
    ├── 查询: materials:project:query
    ├── 新增: materials:project:add
    ├── 修改: materials:project:edit
    ├── 删除: materials:project:remove
    └── 详情: materials:project:detail
```

**菜单SQL**

```sql
-- ----------------------------
-- Menu and Permission SQL for Engineering Project Module
-- ----------------------------

-- 二级菜单（工程项目）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000100, '工程项目', 2000001, 1, 'project', 'materials/project/index', 1, 0, 'C', '0', '0', 'materials:project:list', 'example', 103, 1, now(), NULL, NULL, '工程项目管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 工程项目按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000101, '查询', 5000100, 1, '', '', 1, 0, 'F', '0', '0', 'materials:project:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000102, '新增', 5000100, 2, '', '', 1, 0, 'F', '0', '0', 'materials:project:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000103, '修改', 5000100, 3, '', '', 1, 0, 'F', '0', '0', 'materials:project:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000104, '删除', 5000100, 4, '', '', 1, 0, 'F', '0', '0', 'materials:project:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000105, '详情', 5000100, 5, '', '', 1, 0, 'F', '0', '0', 'materials:project:detail', '#', 103, 1, now(), NULL, NULL, '');

-- 权限关联（示例数据，实际应根据系统角色配置）
INSERT INTO "master"."sys_role_menu" (role_id, menu_id, create_time)
VALUES
  (1, 5000100, now()),  -- 管理员角色拥有工程项目菜单权限
  (1, 5000101, now()),  -- 管理员角色拥有工程项目查询权限
  (1, 5000102, now()),  -- 管理员角色拥有工程项目新增权限
  (1, 5000103, now()),  -- 管理员角色拥有工程项目修改权限
  (1, 5000104, now()),  -- 管理员角色拥有工程项目删除权限
  (1, 5000105, now());  -- 管理员角色拥有工程项目详情权限
```

**字典SQL**

```sql
-- ----------------------------
-- Dictionary Data for Engineering Project Module
-- ----------------------------

-- Add unique constraint on dict_id if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'sys_dict_type_dict_id_key'
    ) THEN
        ALTER TABLE "master"."sys_dict_type" 
        ADD CONSTRAINT sys_dict_type_dict_id_key UNIQUE (dict_id);
    END IF;
END $$;

-- 工程进度字典
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (100, '000000', '工程进度', 'project_progress', 103, now(), '建材填报管理-工程项目-工程项目进度')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (1, '000000', 1, '施工前准备阶段', '1', 'project_progress', '', '', 'N', 103, now(), ''),
  (2, '000000', 2, '土方开挖及基坑支护阶段', '2', 'project_progress', '', '', 'N', 103, now(), ''),
  (3, '000000', 3, '基础施工阶段', '3', 'project_progress', '', '', 'N', 103, now(), ''),
  (4, '000000', 4, '总体结构 1/2 前阶段', '4', 'project_progress', '', '', 'N', 103, now(), ''),
  (5, '000000', 5, '总体结构 1/2 后阶段', '5', 'project_progress', '', '', 'N', 103, now(), ''),
  (6, '000000', 6, '装饰安装阶段', '6', 'project_progress', '', '', 'N', 103, now(), ''),
  (7, '000000', 7, '竣工预验阶段', '7', 'project_progress', '', '', 'N', 103, now(), ''),
  (8, '000000', 8, '停工', '8', 'project_progress', '', '', 'N', 103, now(), '');

-- 有无填报字典
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (101, '000000', '有无填报', 'has_report', 103, now(), '建材填报管理-工程项目-有无填报')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (1, '000000', 1, '有', '1', 'has_report', '', '', 'N', 103, now(), ''),
  (2, '000000', 2, '无', '2', 'has_report', '', '', 'N', 103, now(), '');

-- 是否对接一体化平台编码字典
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (102, '000000', '是否对接一体化平台编码', 'is_integrated', 103, now(), '建材填报管理-工程项目-是否对接一体化平台编码')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (1, '000000', 1, '是', '1', 'is_integrated', '', '', 'N', 103, now(), ''),
  (2, '000000', 2, '否', '2', 'is_integrated', '', '', 'N', 103, now(), '');

-- 工程性质字典（数据来源待确认）
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (103, '000000', '工程性质', 'project_nature', 103, now(), '建材填报管理-工程项目-工程性质')
ON CONFLICT (dict_id) DO NOTHING;

-- 工程结构型式字典（数据来源待确认）
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (104, '000000', '工程结构型式', 'project_structure', 103, now(), '建材填报管理-工程项目-工程结构型式')
ON CONFLICT (dict_id) DO NOTHING;
```

### 后端API设计

**通用API规范**

- 所有接口使用Sa-Token进行身份验证
- 统一返回格式：{ code, msg, data }
- 分页查询使用Page对象

**工程项目API**

- GET /materials/project/list - 分页查询（支持多条件查询），权限：materials:project:query
- GET /materials/project/{id} - 获取详情，权限：materials:project:detail
- POST /materials/project - 新增，权限：materials:project:add
- PUT /materials/project - 修改，权限：materials:project:edit
- DELETE /materials/project/{id} - 删除，权限：materials:project:remove

### 前端设计

**页面结构**

- 使用Element Plus的Table组件展示数据列表
- 使用Dialog组件实现新增/修改/详情弹窗
- 使用Form组件实现表单验证
- 使用ElMessage进行操作反馈

**工程项目页面**

**查询条件**

- 工程名称（模糊查询）
- 施工许可证（模糊查询）
- 工程进度（下拉选择，字典）
- 质量监督机构（下拉选择，数据来源待确认）
- 施工单位名称（模糊查询）
- 有无填报（下拉选择，字典）
- 是否对接一体化平台编码（下拉选择，字典）

**列表展示字段**

- 序号
- 工程名称
- 施工许可证
- 工程进度
- 施工单位
- 有无填报
- 对接一体化平台编码
- 创建时间
- 操作（详情、编辑、删除）

**新增页面字段**

- 施工许可证（input，必填，最大长度100）
- 施工许可证发证日期（date-picker，必填）
- 工程名称（input，必填，最大长度200）
- 工程性质（select，必填，字典）
- 建筑面积（input-number，必填，单位：平方米）
- 工程进度（select，必填，字典）
- 工程地址（input，必填，最大长度500）
- 工程结构型式（select，必填，字典）
- 质量监督机构（select，必填，数据来源待确认）
- 施工单位（input，必填，最大长度200，不可编辑）
- 施工单位负责人（input，必填，最大长度100）
- 施工单位负责人联系方式（input，必填，最大长度20，验证手机号格式）
- 备注（textarea，非必填）

**编辑页面字段**

- 施工许可证（可编辑）
- 施工许可证发证日期（可编辑）
- 工程名称（可编辑）
- 工程性质（可编辑）
- 建筑面积（可编辑）
- 工程进度（可编辑）
- 工程地址（可编辑）
- 工程结构型式（可编辑）
- 质量监督机构（可编辑）
- 施工单位（不可编辑）
- 施工单位负责人（可编辑）
- 施工单位负责人联系方式（可编辑）
- 备注（可编辑）

**详情页面字段**

- 施工许可证（只读）
- 施工许可证发证日期（只读）
- 工程名称（只读）
- 工程性质（只读）
- 建筑面积（只读）
- 工程进度（只读）
- 工程地址（只读）
- 工程结构型式（只读）
- 质量监督机构（只读）
- 施工单位（只读）
- 施工单位负责人（只读）
- 施工单位负责人联系方式（只读）
- 备注（只读）
- 创建时间（只读）
- 更新时间（只读）

**表单验证规则**

- 施工许可证：必填，最大长度100
- 施工许可证发证日期：必填
- 工程名称：必填，最大长度200
- 工程性质：必填
- 建筑面积：必填，大于0
- 工程进度：必填
- 工程地址：必填，最大长度500
- 工程结构型式：必填
- 质量监督机构：必填
- 施工单位：必填，最大长度200
- 施工单位负责人：必填，最大长度100
- 施工单位负责人联系方式：必填，使用正则验证手机号格式 `^1[3-9]\\d{9}$`

### 数据验证策略

**手机号验证**

- 前端：使用正则表达式验证 `^1[3-9]\\d{9}$`
- 后端：使用相同的正则表达式进行二次验证

**必填字段验证**

- 前端：使用 Element Plus 的表单验证规则
- 后端：使用 JSR-303 注解（`@NotBlank`、`@NotNull` 等）进行验证

## Risks / Trade-offs

**字典数据来源未确认:**

- 风险：工程性质、工程结构型式、质量监督机构的数据来源不明确
- 缓解措施：先创建字典表，后续根据实际数据源进行调整

**施工单位回显逻辑:**

- 风险：需要从当前登录账号获取施工单位信息
- 缓解措施：使用 Sa-Token 的 `StpUtil.getLoginIdAsLong()` 获取当前用户ID，再查询用户所属单位

**查询性能:**

- 风险：多条件查询可能影响性能
- 缓解措施：为常用查询字段创建索引，使用 MyBatis-Plus 的分页插件

**数据一致性:**

- 风险：删除工程项目时可能影响关联数据
- 缓解措施：添加逻辑删除标记，不进行物理删除
- 说明：工程项目会关联建材产品（未实现），如果关联了建材产品则不应该被删除（先逻辑删除）
