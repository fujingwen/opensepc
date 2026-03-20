# 备案产品增删改查功能规范

## 1. 功能概述

实现备案产品的增删改查功能，包括：

- 列表查询（支持分页、多条件查询）
- 新增备案产品
- 编辑备案产品
- 删除备案产品（支持批量删除）
- 导出备案产品（支持选择部分数据导出）

## 2. 数据模型

### 表结构

**表名**: `mat_record`

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| `id` | `BIGINT` | `PRIMARY KEY` | 主键ID |
| `enterprise_name` | `VARCHAR(255)` | `NOT NULL` | 生产企业名称 |
| `social_credit_code` | `VARCHAR(18)` | | 统一社会信用代码 |
| `product_name` | `VARCHAR(255)` | `NOT NULL` | 备案产品名称 |
| `certificate_number` | `VARCHAR(100)` | | 备案证号 |
| `start_validity` | `DATE` | `NOT NULL` | 备案证有效期开始日期 |
| `end_validity` | `DATE` | `NOT NULL` | 备案证有效期结束日期 |
| `certificate_status` | `VARCHAR(20)` | | 备案证状态（字典） |
| `del_flag` | `CHAR(1)` | | 删除标志（0存在 2删除） |
| `tenant_id` | `VARCHAR(20)` | | 租户编号 |
| `create_by` | `VARCHAR(64)` | | 创建者 |
| `create_time` | `DATETIME` | | 创建时间 |
| `update_by` | `VARCHAR(64)` | | 更新者 |
| `update_time` | `DATETIME` | | 更新时间 |

### 字典配置

**字典类型**: `certificate_status`
**字典名称**: 备案证状态
**配置方式**: 在前端"系统管理-字典管理"中配置
**字典值**:

| 字典标签 | 字典值 | 样式类 | 是否默认 | 排序 |
|---------|-------|--------|---------|------|
| 未过期 | 0 | success | Y | 1 |
| 已过期 | 1 | danger | N | 2 |

**调用方式**: `const { certificate_status } = proxy.useDict('certificate_status')`

## 3. 接口设计

### 3.1 列表查询

**请求路径**: `/materials/record/list`
**请求方法**: `GET`
**参数**:

- `enterpriseName` (String): 生产企业名称（模糊查询）
- `socialCreditCode` (String): 统一社会信用代码（精确查询）
- `productName` (String): 备案产品名称（模糊查询）
- `certificateNumber` (String): 备案证号（模糊查询）
- `certificateStatus` (String): 备案证状态（字典查询）
- `pageNum` (Integer): 页码
- `pageSize` (Integer): 每页条数

**响应**:

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "total": 100,
    "rows": [
      {
        "id": 1,
        "enterpriseName": "XX建材有限公司",
        "socialCreditCode": "91110000XXXXXXXXXX",
        "productName": "XX水泥",
        "certificateNumber": "BC20230001",
        "startValidity": "2023-01-01",
        "endValidity": "2025-12-31",
        "certificateStatus": "0",
        "createTime": "2023-01-01 10:00:00"
      }
    ]
  }
}
```

### 3.2 获取详情

**请求路径**: `/materials/record/{id}`
**请求方法**: `GET`
**参数**:

- `id` (Long): 备案产品ID

**响应**:

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "id": 1,
    "enterpriseName": "XX建材有限公司",
    "socialCreditCode": "91110000XXXXXXXXXX",
    "productName": "XX水泥",
    "certificateNumber": "BC20230001",
    "startValidity": "2023-01-01",
    "endValidity": "2025-12-31",
    "certificateStatus": "0"
  }
}
```

### 3.3 新增备案产品

**请求路径**: `/materials/record`
**请求方法**: `POST`
**参数**:

```json
{
  "enterpriseName": "XX建材有限公司",
  "socialCreditCode": "91110000XXXXXXXXXX",
  "productName": "XX水泥",
  "certificateNumber": "BC20230001",
  "startValidity": "2023-01-01",
  "endValidity": "2025-12-31",
  "certificateStatus": "0"
}
```

**响应**:

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": null
}
```

### 3.4 编辑备案产品

**请求路径**: `/materials/record`
**请求方法**: `PUT`
**参数**:

```json
{
  "id": 1,
  "enterpriseName": "XX建材有限公司",
  "socialCreditCode": "91110000XXXXXXXXXX",
  "productName": "XX水泥",
  "certificateNumber": "BC20230001",
  "startValidity": "2023-01-01",
  "endValidity": "2025-12-31",
  "certificateStatus": "0"
}
```

**响应**:

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": null
}
```

### 3.5 删除备案产品

**请求路径**: `/materials/record/{ids}`
**请求方法**: `DELETE`
**参数**:

- `ids` (Long[]): ID数组

**响应**:

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": null
}
```

### 3.6 导出备案产品

**请求路径**: `/materials/record/export`
**请求方法**: `POST`
**参数**:

- `enterpriseName` (String): 生产企业名称（模糊查询）
- `socialCreditCode` (String): 统一社会信用代码（精确查询）
- `productName` (String): 备案产品名称（模糊查询）
- `certificateNumber` (String): 备案证号（模糊查询）
- `certificateStatus` (String): 备案证状态（字典查询）
- `ids` (List<Long>): 选中的ID列表（可选，如果不传则导出所有符合条件的数据）

**响应**: Excel文件下载

## 4. 前端实现

### 4.1 页面结构

- 搜索区域：包含生产企业名称、统一社会信用代码、备案产品名称、备案证号、备案证状态等搜索条件
- 操作按钮：新增、批量删除、导出
- 数据表格：展示备案产品列表（支持多选）
- 分页组件：分页控制

### 4.2 组件使用

- 表单：`el-form`
- 表格：`el-table`
- 分页：`Pagination`（全局组件）
- 日期选择：`el-date-picker`（使用daterange类型，用于备案证有效期）
- 字典标签：`DictTag`（全局组件）
- 工具栏：`right-toolbar`（全局组件）

### 4.3 API调用

```javascript
import request from '@/utils/request'

export function listRecord(query) {
  return request({
    url: '/materials/record/list',
    method: 'get',
    params: query
  })
}

export function getRecord(id) {
  return request({
    url: '/materials/record/' + id,
    method: 'get'
  })
}

export function addRecord(data) {
  return request({
    url: '/materials/record',
    method: 'post',
    data: data
  })
}

export function updateRecord(data) {
  return request({
    url: '/materials/record',
    method: 'put',
    data: data
  })
}

export function delRecord(ids) {
  return request({
    url: '/materials/record/' + ids,
    method: 'delete'
  })
}

export function exportRecord(query) {
  return request({
    url: '/materials/record/export',
    method: 'post',
    data: query
  })
}
```

### 4.4 前端实现要点

1. **字典使用**：使用 `proxy.useDict('certificate_status')` 调用字典
2. **文件下载**：使用 `proxy.download('materials/record/export', { ...queryParams.value, ids: ids.value }, filename)` 下载文件
3. **表单 label-width**：根据最长文本计算（字数*20，最小120px）
4. **输入框**：所有输入框都添加 `clearable` 属性
5. **批量操作**：只保留批量删除，不保留批量修改
6. **导出功能**：传递 `ids` 参数，支持选择部分数据导出
7. **日期范围选择器**：使用 `el-date-picker type="daterange"`，并实现 `@change` 事件处理

## 5. 验证规则

### 前端验证

- **生产企业名称**：必填，非空验证
- **备案产品名称**：必填，非空验证
- **备案证有效期**：必填，日期范围格式验证
- **统一社会信用代码**：18位数字和字母组合验证
- **备案证状态**：使用字典值验证

### 后端验证

- **生产企业名称**：`@NotNull` 注解验证
- **备案产品名称**：`@NotNull` 注解验证
- **备案证有效期**：`@NotNull` 注解验证开始日期和结束日期
- **统一社会信用代码**：正则表达式验证
- **备案证状态**：枚举值验证

## 6. 权限配置

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

## 7. ADDED Requirements

### Requirement: 备案产品数据模型

系统 SHALL 设计备案产品的数据模型，包括数据库表结构和字段定义。

#### Scenario: 设计备案产品数据模型

- **Given** 需要存储备案产品信息
- **When** 设计数据库表结构
- **Then** 创建 `mat_record` 表
- **Then** 包含生产企业名称、统一社会信用代码、备案产品名称等字段
- **Then** 将备案证有效期拆分为开始日期和结束日期（start_validity和end_validity）
- **Then** 添加备案证状态字段（字典类型）
- **Then** 添加删除标志字段（del_flag）用于逻辑删除

### Requirement: 备案证状态字典

系统 SHALL 配置备案证状态的字典数据，包括字典类型、名称和字典值。

#### Scenario: 配置备案证状态字典

- **Given** 备案证状态需要使用字典管理
- **When** 配置字典数据
- **Then** 创建 `certificate_status` 字典类型
- **Then** 添加未过期（0）和已过期（1）两个字典值
- **Then** 设置对应样式类为 success 和 danger

### Requirement: 备案产品CRUD接口

系统 SHALL 实现备案产品的增删改查接口，包括列表查询、新增、编辑和删除功能。

#### Scenario: 实现备案产品CRUD接口

- **Given** 前端需要操作备案产品数据
- **When** 开发后端接口
- **Then** 实现列表查询、新增、编辑、删除接口
- **Then** 支持模糊查询和精确查询
- **Then** 支持批量删除
- **Then** 支持导出功能（可选择部分数据导出）

### Requirement: 备案产品前端页面

系统 SHALL 实现备案产品的前端管理页面，包括搜索、表格展示和操作功能。

#### Scenario: 实现备案产品前端页面

- **Given** 用户需要管理备案产品
- **When** 开发前端页面
- **Then** 创建备案产品管理页面
- **Then** 实现搜索、表格展示、分页功能
- **Then** 实现新增、编辑、删除操作
- **Then** 实现批量删除和导出功能
- **Then** 集成字典标签和日期选择器
- **Then** 所有输入框添加 clearable 属性
- **Then** 表单 label-width 根据最长文本计算

### Requirement: Excel导出功能

系统 SHALL 实现备案产品的Excel导出功能，支持选择部分数据导出。

#### Scenario: 实现Excel导出功能

- **Given** 用户需要导出备案产品数据
- **When** 开发导出功能
- **Then** 创建 Excel 导出 VO 类（MatRecordExcelVO）
- **Then** 实现导出接口，支持传递 ids 参数
- **Then** 如果传入了 ids，导出选中的数据
- **Then** 如果没有传入 ids，导出查询条件下的所有数据
- **Then** 前端传递 ids 参数，支持选择部分数据导出
