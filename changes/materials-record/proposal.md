## Why

为了满足建材行业的管理需求，实现备案产品的规范化管理，提高工作效率和数据准确性。

## What Changes

- 实现备案产品的增删改查功能
- 数据模型基于现有数据库表 master.t_record_product
- 实现前端页面和后端API接口
- 集成到现有的权限管理体系中

## Capabilities

### New Capabilities

- `materials_record`: 备案产品的增删改查功能
  - 数据表：master.t_record_product
  - 关联表：master.t_companyinfo (生产企业，company_type=2)

### 功能详情

#### 1. 列表功能
- 分页查询备案产品列表
- 支持按以下条件搜索：
  - 生产企业名称（模糊查询）
  - 统一社会信用代码
  - 备案产品名称
  - 备案证号
  - 备案证状态（通过有效期计算）
- 显示字段：
  - 备案产品名称
  - 生产企业名称（关联查询）
  - 备案证号
  - 统一社会信用代码
  - 备案证有效期（开始日期 至 结束日期）
  - 备案证状态（根据结束日期计算：已过期/有效）
  - 创建时间
- 操作列：详情、修改、删除

#### 2. 新增功能
- 弹出框表单
- 字段：
  - 备案产品名称（必填）
  - 生产企业（下拉选择，数据来源于 master.t_companyinfo，company_type=2）
  - 备案证号（必填）
  - 统一社会信用代码
  - 备案证有效期（日期范围选择，只精确到年月日）
- 校验规则：
  - 备案证号不能与现有记录重复
- 自动设置 del_flag = 0

#### 3. 修改功能
- 弹出框表单（数据回显）
- 生产企业下拉选择
- 校验规则：
  - 备案证号不能与现有记录重复（排除自身）

#### 4. 详情功能
- 只读弹出框
- 显示字段：
  - 备案产品名称
  - 生产企业名称（直接回显，不需要请求接口）
  - 备案证号
  - 统一社会信用代码
  - 备案证有效期

#### 5. 删除功能
- 批量删除
- 业务规则：如果备案产品在项目产品表（master.t_project_product）中被使用（通过 record_no 关联），则无法删除

#### 6. 导入功能

- 下载导入模板
- 模板字段顺序：企业名称、产品名称、备案证号、有效期限、联系人、联系电话、地址
- 模板包含一行示例数据：
  - 企业名称：生产企业的名称
  - 产品名称：备案产品的名称
  - 备案证号：QJB-********
  - 有效期限：2021年03月08日—2023年03月07日
  - 联系人：[示例]
  - 联系电话：[示例]
  - 地址：[示例]
- 最后一列下一列显示"此行是示例数据，导入前请删除"
- 后端解析时按照模板格式解析数据
- 支持批量导入（最多1000条数据）
- 导入前预览数据，支持编辑和删除
- 支持覆盖已存在的数据选项

## 待确认事项

### 导入模板字段存储问题

**问题1：联系人、联系电话、地址字段存储**

- 导入模板中包含"联系人"、"联系电话"、"地址"三个字段
- 备案产品表（master.t_record_product）中并没有对应的字段来存储这些信息
- **待确认**：
  - 这些字段是否需要存储到数据库？
  - 如果需要存储，是否需要扩展数据库表结构？
  - 如果不需要存储，导入时是否需要忽略这些字段？

**问题2：企业名称匹配逻辑**

- 导入时根据"企业名称"字段匹配生产企业信息
- 匹配逻辑：在 t_companyinfo 表中查找 company_name 字段完全匹配的企业
- **待确认**：
  - 如果企业名称匹配不上，应该如何处理？
  - 选项A：报错提示"企业名称不存在，请先添加企业"
  - 选项B：允许导入，但 manufacture_id 为空
  - 选项C：模糊匹配，提供候选企业供用户选择
  - 选项D：自动创建新的企业记录

## 数据关联

### 关联查询
- 列表查询使用 LEFT JOIN 关联 t_companyinfo 表
- 根据 manufacture_id 关联查询 company_name 作为 manufactureName

### 外键关系
- t_record_product.manufacture_id → t_companyinfo.id

## 技术实现

### 后端
- MatRecordController: REST接口
- MatRecordService/IMatRecordService: 业务逻辑
- MatRecordMapper: 数据访问
- MatRecordMapper.xml: 自定义SQL（关联查询）

### 前端
- materials/record/index.vue: 备案产品管理页面
- materials/record.js: API调用

### 类型转换
- 使用 LongStringTypeHandler 处理 create_by/update_by 字段（String类型）

### 数据校验
- 新增/修改时检查备案证号唯一性
- 删除时检查是否被项目产品引用

## Impact

- 后端：新增 MatRecordController、MatRecordService、MatRecordMapper、MatCompanyInfoController 等文件
- 前端：新增备案产品管理页面 materials/record/index.vue
- 数据库：使用已迁移的 master.t_record_product 表（6602条数据）+ master.t_companyinfo 表（company_type=2的企业）
- 权限：新增 materials:record 系列权限配置
## 2026-04-01 补充说明

- 生产企业的唯一业务关联字段以 `manufacture_id` 为准，关联 `master.t_companyinfo.id`。
- `manufactur` 视为历史遗留字段，不再作为新增、编辑、查询、回显、校验的主依据。
- 备案证状态按有效期计算，状态字典统一使用 `certificate_status`。
- 导入能力按 `batch-import-dialog` 提案组件能力落地。
- `record_no` 需要严格保证不可重复，不能只依赖应用层校验。
- `send_flag` 是否作为正式查询/展示字段，需单独确认后再决定是否纳入本提案验收范围。
