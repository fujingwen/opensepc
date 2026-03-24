# 产品管理（字典替换）- 详细设计

## 1. 功能概述

产品管理是系统管理模块下的一个子模块，用于管理建筑材料产品数据。采用专用 sys_product 表存储数据，左侧为产品类别树，右侧为产品数据树。

## 2. 页面设计

### 2.1 布局结构

采用左右分栏布局：

- 左侧：产品类别树（node_type = 'category'）
- 右侧：产品数据列表（根据左侧选中类别动态加载，包含 product 和 spec 两种类型）

### 2.2 左侧产品类别树

- 展示产品类别层级结构
- 支持名称搜索
- 点击类别选中，右侧加载该类别下的产品数据

**查询条件**：

| 字段 | 类型 | 说明 |
|------|------|------|
| fullName | String | 名称（模糊查询） |

**表格列字段**：

| 列 | 字段 | 说明 |
|----|------|------|
| 类别名称 | fullName | 产品类别名称 |

**返回字段**：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键ID |
| parentId | Long | 父级ID（顶级为 0） |
| fullName | String | 产品类别名称 |
| enCode | String | 编码 |
| nodeType | String | 节点类型（category-类别，product-产品） |
| categoryId | Long | 类别ID |
| specification | String | 规格 |
| unit | String | 单位 |
| sortCode | Integer | 排序码 |
| enabledMark | Integer | 状态（1-正常 0-停用） |
| remark | String | 备注 |
| hasChildren | Boolean | 是否有子节点 |
| children | List | 子节点列表 |

### 2.3 右侧产品数据列表

- 根据左侧选中的产品类别，加载对应的产品数据
- 使用树形表格展示（通过 children 字段连接子节点）
- 支持名称和状态查询
- 支持展开/收起全部

**查询条件**：

| 字段 | 类型 | 说明 |
|------|------|------|
| fullName | String | 名称（模糊查询） |
| enabledMark | Integer | 状态（精确匹配） |

**表格列字段**：

| 列 | 字段 | 说明 |
|----|------|------|
| 序号 | - | 序号（type="index"） |
| 名称 | fullName | 产品名称 |
| 编码 | enCode | 编码 |
| 排序 | sortCode | 排序码 |
| 状态 | enabledMark | 状态（使用字典标签显示） |
| 操作 | - | 新增、编辑、删除按钮 |

**返回字段**：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键ID |
| parentId | Long | 父级ID |
| fullName | String | 产品名称 |
| enCode | String | 编码 |
| nodeType | String | 节点类型（category-类别，product-产品） |
| categoryId | Long | 所属类别ID |
| specification | String | 规格 |
| unit | String | 单位 |
| sortCode | Integer | 排序码 |
| enabledMark | Integer | 状态（1-正常 0-停用） |
| remark | String | 备注 |
| hasChildren | Boolean | 是否有子节点 |
| children | List | 子节点列表 |

### 2.4 操作按钮

- **新增类别**：点击左侧"新增类别"按钮，新增产品类别
- **新增**：点击右侧"新增"按钮，以选中行作为父级新增子数据
- **编辑**：编辑当前行数据
- **删除**：删除当前行数据（如有子元素则不允许删除）
- **展开**：展开右侧树形表格所有行
- **收起**：收起右侧树形表格所有行

## 3. 数据结构设计

### 3.1 表结构

使用现有的 sys_product 表：

| 表名 | 用途 | 说明 |
|------|------|------|
| sys_product | 产品表 | 已存在，存储产品类别和产品数据 |

### 3.2 产品表（sys_product）

现有表结构：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键ID |
| parent_id | bigint | 父级ID |
| tree_path | varchar(500) | 树路径 |
| node_type | varchar(20) | 节点类型（category-类别，product-产品） |
| category_id | bigint | 类别ID |
| full_name | varchar(200) | 名称 |
| en_code | varchar(100) | 编码 |
| specification | varchar(200) | 规格 |
| unit | varchar(20) | 单位 |
| sort_code | integer | 排序码 |
| enabled_mark | smallint | 状态（1-正常 0-停用） |
| remark | varchar(500) | 备注 |
| tenant_id | varchar(20) | 租户编号 |
| del_flag | char(1) | 删除标志（0-正常 2-删除） |

### 3.3 数据层级说明

sys_product 表存储三种类型的数据：

| node_type | 层级 | 说明 |
|-----------|------|------|
| category | 第一层 | 产品类别（左侧树），如：建筑钢材、防水材料 |
| product | 第二层 | 产品名称（右侧第1层），如：螺纹钢、HPB300 |
| spec | 第三层及以下 | 产品规格（右侧第2层及以下），如：厚度10mm |

**category_id 规则**：所有属于同一顶级类别的数据，category_id 应指向该顶级类别的 id。

## 4. API 设计

### 4.1 产品类别列表（左侧类别树）

```
GET /system/product/category/list
```

查询参数：

| 参数 | 类型 | 说明 |
|------|------|------|
| fullName | String | 名称（模糊查询） |

响应：

```json
{
  "code": 200,
  "data": [
    {
      "id": 1,
      "parentId": 0,
      "fullName": "建材名称",
      "enCode": "jcmc",
      "nodeType": "category",
      "categoryId": 0,
      "sortCode": 1,
      "enabledMark": 1,
      "hasChildren": true,
      "children": []
    }
  ]
}
```

### 4.2 产品列表（右侧产品列表）

```
GET /system/product/list/{categoryId}
```

查询参数：

| 参数 | 类型 | 说明 |
|------|------|------|
| fullName | String | 名称（模糊查询） |
| enabledMark | Integer | 状态（精确匹配） |

响应：

```json
{
  "code": 200,
  "data": [
    {
      "id": 2,
      "parentId": 1,
      "fullName": "建筑钢材",
      "enCode": "jzgc",
      "sortCode": 1,
      "enabledMark": 1,
      "description": "说明",
      "categoryId": 1,
      "hasChildren": true,
      "children": [
        {
          "id": 3,
          "parentId": 2,
          "fullName": "螺纹钢",
          "enCode": "lwz",
          "sortCode": 1,
          "enabledMark": 1,
          "categoryId": 1,
          "hasChildren": false,
          "children": []
        }
      ]
    }
  ]
}
```

### 4.3 新增产品类别

```
POST /system/product/category
```

请求体：

```json
{
  "parentId": 0,
  "fullName": "建筑钢材",
  "enCode": "jzgc",
  "categoryId": 0,
  "sortCode": 1,
  "enabledMark": 1,
  "description": "说明"
}
```

### 4.4 修改产品类别

```
PUT /system/product/category
```

### 4.5 删除产品类别

```
DELETE /system/product/category/{id}
```

### 4.6 新增产品

```
POST /system/product
```

请求体：

```json
{
  "parentId": 1,
  "fullName": "螺纹钢",
  "enCode": "lwz",
  "categoryId": 1,
  "sortCode": 1,
  "enabledMark": 1,
  "description": "说明"
}
```

### 4.7 修改产品

```
PUT /system/product
```

### 4.8 删除产品

```
DELETE /system/product/{id}
```

**删除规则**：

- 如果要删除的节点存在子节点，则不允许删除
- 前端检查 children 数组是否有数据
- 后端检查是否有子数据记录
- 返回提示信息："该数据存在子元素，无法删除"

## 5. 前端组件设计

### 5.1 页面组件

- `views/system/product/index1.vue` - 产品管理主页面（使用 sys_product 表）

### 5.2 API 接口

- `api/system/product.js` - 产品管理 API（index1.vue 使用）

### 5.3 懒加载接口（供其他页面使用）

为了支持在其他页面中懒加载产品数据，提供以下接口：

| 接口 | 方法 | 说明 |
|------|------|------|
| `/system/product/lazy/{parentId}` | GET | 根据父ID懒加载子节点数据 |

该接口返回指定父级ID下的所有子节点数据，用于：
- 产品选择弹窗中的树形组件
- 懒加载表格
- 级联选择器

### 5.4 组件交互

1. 页面加载时，调用 `listCategory()` 加载左侧产品类别树
2. 点击左侧类别，调用 `listProduct(categoryId, queryParams)` 加载右侧数据
3. 点击"新增类别"：新增产品类别记录到 sys_product 表
4. 点击右侧"新增"：以选中行作为父级新增子数据到 sys_product 表
5. 点击"展开"/"收起"：使用 toggleRowExpansion 控制表格行展开

### 5.4 使用的模板

参考模板：`openspec/templates/frontend-left-right-template.md`

该模板提供了左右分栏布局的标准实现，包括：

- 左侧树组件
- 右侧树形表格
- 搜索表单
- 操作按钮
- 弹窗表单

## 6. 权限设计

使用现有产品管理菜单的权限标识：

| 权限标识 | 说明 |
|---------|------|
| system:product:list | 查询 |
| system:product:query | 详情 |
| system:product:add | 新增 |
| system:product:edit | 修改 |
| system:product:remove | 删除 |

## 7. 菜单设计

使用现有的"产品管理"菜单，组件路径改为 `system/product/index1`

## 8. 状态字典

使用系统字典 `sys_region_status`：

| 值 | 标签   | 说明         |
|----|--------|--------------|
| 1  | 正常   | 正常启用状态 |
| 0  | 停用   | 已停用状态   |

## 9. 后端树形结构组织

后端使用 HashMap 在 O(n) 时间内组织树形结构：

1. 查询所有数据
2. 使用 HashMap 按 parentId 分组
3. 递归构建树形结构
4. 返回带 children 和 hasChildren 字段的树形数据

## 10. 与原提案的关系

### 10.1 代码独立性

- 原有基于字典表的 system-product 提案代码保持不变
- index.vue 继续使用 dictionary.js API 操作字典表
- index1.vue 使用 product.js API 操作 sys_product 表

### 10.2 共存设计

两个页面可以同时存在：
- `/system/product/index` - 使用字典表的产品管理
- `/system/product/index1` - 使用 sys_product 表的产品管理

## 11. 后续扩展

### 11.1 建材产品关联

后续在建材产品模块中选择产品时，被选择的产品不能被删除。

实现方式：

- 在删除产品前，检查是否被建材产品关联
- 如果有关联，则不允许删除，返回提示信息："该产品已被建材产品使用，无法删除"

### 11.2 扩展字段

如需支持产品与其他业务表的关联，可以在产品表中预留扩展字段。
