## Context

当前项目是一个基于Spring Boot和Vue的后台管理系统，需要新增建材填报管理模块，实现备案产品的增删改查功能。根据需求，模块包含三个业务模块：工程项目、建材产品、备案产品，本次优先实现备案产品的管理功能。

## Goals / Non-Goals

**Goals:**

- 创建建材填报管理模块，包含三个业务模块：工程项目、建材产品、备案产品
- 实现备案产品的增删改查功能
- 设计备案产品的数据模型，包含生产企业名称、统一社会信用代码、备案产品名称、备案证号、备案证有效期、备案证状态等字段
- 实现前端页面和后端API接口
- 集成到现有的权限管理体系中

**Non-Goals:**

- 本次不实现工程项目和建材产品的管理功能
- 不修改现有系统的核心架构
- 不涉及第三方系统集成

## Decisions

1. **模块结构设计**
   - 后端：在hny-modules下新增hny-materials模块
   - 前端：在src/views下新增materials目录
   - 理由：遵循现有的模块划分规范，保持代码结构清晰

2. **数据模型设计**
   - 表名：master.t_record_product
   - 字段（与数据库表字段一一对应）：
     - id (主键)
     - record_product_name (备案产品名称)
     - manufactur (生产厂家名称)
     - manufacture_id (生产企业ID，外键关联master.t_companyinfo.id)
     - record_no (备案证号)
     - begin_time (备案证有效期开始时间)
     - end_time (备案证有效期结束时间)
     - enabled_mark (是否可用)
     - social_credit_code (统一社会信用代码)
     - send_flag (发送标志)
     - del_flag (删除标志，逻辑删除)
     - delete_time (删除时间)
     - delete_by (删除人)
     - create_by, create_time, update_by, update_time (审计字段)
     - tenant_id (租户ID，默认值：000000)
     - create_dept (创建部门，默认值：103)
   - 关联关系：manufacture_id 外键关联 master.t_companyinfo(id)，且 company_type = 2 (生产企业)
   - 理由：基于现有数据库表结构迁移，保持字段一致

## 数据验证规则

### 前端验证

- **备案产品名称 (record_product_name)**：必填，非空验证
- **生产厂家 (manufactur)**：必填，非空验证
- **备案证号 (record_no)**：必填，非空验证
- **有效期开始时间 (begin_time)**：必填，日期验证
- **有效期结束时间 (end_time)**：必填，日期验证，需大于开始时间
- **统一社会信用代码 (social_credit_code)**：18位数字和字母组合验证
- **是否可用 (enabled_mark)**：数字验证 (0-否, 1-是)

### 后端验证

- **备案产品名称**：`@NotBlank` 注解验证
- **生产厂家**：`@NotBlank` 注解验证
- **备案证号**：`@NotBlank` 注解验证
- **有效期**：`@NotNull` 注解验证开始时间和结束时间
- **统一社会信用代码**：正则表达式验证格式

## 权限设计

- 菜单：建材填报管理 -> 备案产品管理
- 权限：materials:record:list, materials:record:query, materials:record:add, materials:record:edit, materials:record:remove
- 理由：遵循现有的权限管理体系，细粒度控制操作权限

## 权限配置明细

### 菜单管理配置

在前端"系统管理-菜单管理"中配置以下菜单：

| 菜单名称 | 排序 | 权限标识 | 组件路径 | 状态 |
|---------|------|---------|---------|------|
| **建材填报管理** | 100 | 无 | 无 | 正常 |
| └─ **备案产品管理** | 1 | materials:record:list | materials/record/index | 正常 |
| ├─ 备案产品查询 | 1 | materials:record:query | 无 | 正常 |
| ├─ 备案产品新增 | 2 | materials:record:add | 无 | 正常 |
| ├─ 备案产品修改 | 3 | materials:record:edit | 无 | 正常 |
| └─ 备案产品删除 | 4 | materials:record:remove | 无 | 正常 |

### 权限字符串格式

- **格式**：模块:页面:操作（三级）
- **示例**：
  - 页面权限：materials:record:list
  - 查询按钮：materials:record:query
  - 新增按钮：materials:record:add
  - 修改按钮：materials:record:edit
  - 删除按钮：materials:record:remove

### 实现方式

**前端实现**：

- 菜单权限：根据后端返回动态确定，不需要在路由配置中设置 `meta.permissions`
- 按钮权限：使用 `v-hasPermi="['materials:record:add']"` 指令
- API 调用：在组件中通过 `@/api/materials/record.js` 调用接口

**后端实现**：

- Controller 方法上使用 `@SaCheckPermission("materials:record:list")` 注解
- Service 层实现业务逻辑
- Mapper 层实现数据访问

## 查询条件配置

### 备案产品管理页面查询条件

| 字段名称 | 查询方式 | 控件类型 | 备注 |
|---------|---------|---------|------|
| 生产厂家 | 模糊查询 | 输入框 | manufactur |
| 统一社会信用代码 | 精确查询 | 输入框 | social_credit_code |
| 备案产品名称 | 模糊查询 | 输入框 | record_product_name |
| 备案证号 | 精确查询 | 输入框 | record_no |
| 有效期开始时间 | 范围查询 | 日期选择器 | begin_time |
| 有效期结束时间 | 范围查询 | 日期选择器 | end_time |
| 是否可用 | 精确查询 | 下拉选择 | enabled_mark (0-否, 1-是) |
| 发送标志 | 精确查询 | 下拉选择 | send_flag |

## 技术实现

- 后端：使用Spring Boot + MyBatis-Plus + Sa-Token
- 前端：使用Vue 3 + Element Plus + Axios
- 理由：与现有技术栈保持一致，减少学习成本

## 字典配置

### 备案证状态字典配置

**字典类型配置**（在系统管理-字典管理中配置）：

| 字段名 | 字段值 | 说明 |
|-------|-------|------|
| dict_name | 备案证状态 | 字典名称 |
| dict_type | record_status | 字典类型编码 |

**字典数据配置**（在系统管理-字典管理中配置）：

| 字典标签 | 字典值 | 样式类 | 是否默认 | 排序 |
|---------|-------|--------|---------|------|
| 有效 | 1 | success | Y | 1 |
| 无效 | 0 | danger | N | 2 |

### 发送标志字典配置

**字典类型配置**：

| 字段名 | 字段值 | 说明 |
|-------|-------|------|
| dict_name | 发送标志 | 字典名称 |
| dict_type | send_flag | 字典类型编码 |

**字典数据配置**：

| 字典标签 | 字典值 | 样式类 | 是否默认 | 排序 |
|---------|-------|--------|---------|------|
| 已发送 | 1 | success | Y | 1 |
| 未发送 | 0 | info | N | 2 |

## Risks / Trade-offs

1. **Risk**: 数据验证规则可能不够完善
   - Mitigation: 前端和后端双重验证，确保数据合法性

2. **Risk**: 前端页面样式与现有系统不一致
   - Mitigation: 使用标准前端页面模板（templates/frontend-page-template.md）生成代码，确保样式和功能与现有系统保持一致

3. **Risk**: 后端代码风格与现有系统不一致
   - Mitigation: 使用标准后端代码模板（templates/backend-code-template.md）生成代码，确保代码风格和架构与现有系统保持一致
