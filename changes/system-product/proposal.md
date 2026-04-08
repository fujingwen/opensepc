# 产品管理（字典替换）

## Why

目前系统中产品相关数据存储在字典表（base_dictionarytype 和 base_dictionarydata）中。为提供独立的产品管理能力，需要使用专用的 sys_product 表来存储产品数据，替代现有的字典表实现方案。

## What Changes

- 新建 sys_product 表用于存储产品数据（替代 base_dictionarytype 和 base_dictionarydata）
- 新增产品管理后端 API（sys_product 相关接口）
- 新增产品管理前端页面 index.vue（左右分栏布局）
- 后端组织树形结构返回给前端
- 支持按名称和状态查询
- 补充建材产品级联兼容规则：按产品类别查询产品名称时，后端需同时兼容 `tree_path` 命中类别与 `category_id = categoryId` 两种历史数据口径
- **原有基于字典表的实现保持不变，不删除不修改**

## Compatibility Notes

- 已核对旧库与新库 `master.sys_product` 记录数量一致，建材产品新增时“产品类别 -> 产品名称”下拉为空并非新旧库数据不一致，不需要从旧库同步整表
- 实际问题来自历史 `sys_product` 数据结构不规范：部分类别缺少标准第一层 `product` 节点，部分记录 `tree_path` 不完整，但 `category_id` 仍可用
- 因此实现与文档都必须明确：产品级联查询采用 `tree_path` + `category_id` 双通道兜底，而不是只依赖标准树路径

## Capabilities

### New Capabilities

- `system-product-dict`: 产品管理（系统管理 -> 产品管理页面，index.vue）
  - 使用专用 sys_product 表存储数据
  - 支持多级树状结构
  - 左侧产品类别树
  - 右侧产品数据列表
  - 支持新增类别、新增子级、编辑、删除
  - 支持按名称和状态查询

### Modified Capabilities

- (无)

## Impact

### 数据库

使用现有的 sys_product 表：

| 表名 | 说明 |
|------|------|
| sys_product | 产品表（已存在，存储产品类别和产品数据） |

现有表结构包含以下字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键ID |
| parent_id | bigint | 父级ID |
| tree_path | varchar(500) | 树路径 |
| node_type | varchar(20) | 节点类型 |
| category_id | bigint | 类别ID |
| full_name | varchar(200) | 名称 |
| en_code | varchar(100) | 编码 |
| specification | varchar(200) | 规格 |
| unit | varchar(20) | 单位 |
| sort_code | integer | 排序码 |
| enabled_mark | smallint | 状态（1-正常 0-停用） |
| remark | varchar(500) | 备注 |
| tenant_id | varchar(20) | 租户编号 |
| del_flag | char(1) | 删除标志 |

数据层级说明：

sys_product 表存储三种类型的数据：

| node_type | 层级 | 说明 | 示例 |
|-----------|------|------|------|
| category | 第一层 | 产品类别（左侧树） | 建筑钢材、防水材料 |
| product | 第二层 | 产品名称（右侧第一层） | 螺纹钢、HPB300 |
| spec | 第三层及以下 | 产品规格（右侧其他层） | 厚度、规格参数 |

category_id 使用规则：

- 所有属于同一顶级类别的数据，category_id 应指向该顶级类别的 id
- 例如：建筑钢材（id=1003, category_id=1004）的所有子产品，category_id 都应为 1003

### 后端（hny-system 模块）

| 文件路径 | 说明 |
|----------|------|
| domain/entity/SysProduct.java | 产品实体类 |
| domain/bo/SysProductBo.java | 产品业务对象 |
| domain/vo/SysProductVo.java | 产品视图对象 |
| mapper/SysProductMapper.java | Mapper接口 |
| resources/mapper/SysProductMapper.xml | Mapper XML |
| service/ISysProductService.java | 服务接口 |
| service/impl/SysProductServiceImpl.java | 服务实现 |
| controller/SysProductController.java | 控制器 |

### 前端

| 文件路径 | 说明 |
|----------|------|
| api/system/product.js | 产品管理 API |
| views/system/product/index.vue | 页面组件（左右分栏布局，使用 sys_product 表） |

> 说明：前端页面使用 index.vue（使用 sys_product 表）；原有基于字典表的实现保留在 index-dict.vue；API 接口复用 /system/product 路径，因为 index-dict.vue 使用字典表 API，而 index.vue 使用 sys_product 表 API（后端Controller路径相同但数据源不同）

### 使用的模板

前端页面参考模板：[frontend-left-right-template.md](../../templates/frontend-left-right-template.md)

该模板提供了左右分栏布局的标准实现，包括：

- 左侧树组件
- 右侧树形表格
- 搜索表单
- 操作按钮
- 弹窗表单

## Notes

### 数据存储说明

产品数据存储在现有的 sys_product 表中，采用三种 node_type 类型：

| node_type | 层级 | 说明 |
|-----------|------|------|
| category | 第一层 | 产品类别（如：建筑钢材、防水材料），显示在左侧树 |
| product | 第二层 | 产品名称（如：螺纹钢、HPB300），右侧第一层 |
| spec | 第三层及以下 | 产品规格（如：厚度10mm、规格参数），右侧其他层 |

**category_id 规则**：所有属于同一顶级类别的数据，category_id 应指向该顶级类别的 id。

### 页面布局设计

与 system-product 提案中的页面布局完全一致：

```
┌─────────────────────────────────────────────────────────────────┐
│  产品类别: [____________]                                        │
│  [+ 新增类别]                                                   │
├─────────────────────┬───────────────────────────────────────────┤
│   产品类别树        │  名称: [____________] [搜索] [重置]        │
│                     ├───────────────────────────────────────────┤
│  ┌───────────────┐  │  ┌────┬──────────┬──────┬─────┬────────┐│
│  │ 建材名称      │  │  │序号│ 名称     │ 编码 │ 排序 │ 操作   ││
│  │  ├─ 建筑钢材 │  │  ├────┼──────────┼──────┼─────┼────────┤│
│  │  └─ 防水材料 │  │  │ 1  │ 螺纹钢   │ HRB │  1  │新增编辑││
│  │               │  │  │ 2  │  ├─HPB300│ HRB │  1  │删除   ││
│  │               │  │  │ 3  │  └─HRB400│ HRB │  2  │       ││
│  └───────────────┘  │  └────┴──────────┴──────┴─────┴────────┘│
│                     │                                            │
│                     │  [+ 新增]  [展开]  [收起]                 │
└─────────────────────┴───────────────────────────────────────────┘
```

**说明**：

- 左侧：产品类别树（sys_product 表中类别记录），支持名称搜索，点击类别加载右侧数据
- 右侧：产品数据列表（sys_product 表中产品记录），树形表格展示
- 表格列：序号、名称、编码、排序、状态、操作
- 操作列：新增（子级）、编辑、删除
- 按钮：新增类别、新增、展开、收起

### 交互逻辑

1. 首次进入页面，加载左侧产品类别树（node_type = 'category'）
2. 点击左侧类别，右侧加载该类别下的所有产品数据（通过 category_id 关联）
3. 左侧支持名称模糊查询
4. 右侧支持名称和状态查询
5. 点击"新增类别"：在左侧新增产品类别（node_type = 'category'）
6. 点击右侧"新增"：
   - 在右侧第1层新增时，添加产品名称（node_type = 'product'）
   - 在右侧第2层及以下新增时，添加产品规格（node_type = 'spec'）
7. 点击"展开"/"收起"：展开或收起右侧树形表格

### 状态字典

使用系统字典 `sys_region_status`：

| 值 | 标签   | 说明         |
|----|--------|--------------|
| 1  | 正常   | 正常启用状态 |
| 0  | 停用   | 已停用状态   |

### API 设计

| 接口 | 方法 | 说明 |
|------|------|------|
| /system/product/category/list | GET | 获取产品类别列表（左侧类别树） |
| /system/product/list/{categoryId} | GET | 获取产品列表（右侧第一层数据），支持名称和状态查询 |
| /system/product/lazy/{parentId} | GET | 获取产品列表（懒加载），根据父ID查询子节点数据 |
| /system/product/category | POST | 新增产品类别 |
| /system/product | PUT | 修改产品（类别和产品共用） |
| /system/product/{id} | DELETE | 删除产品（类别和产品共用） |
| /system/product | POST | 新增产品 |
| /system/product/hasChild/{parentId} | GET | 检查是否有子节点 |
| /system/product/{id} | GET | 获取产品详情。|

> **说明**：编辑和删除类别与产品共用同一接口，通过 nodeType 区分数据类型。

### 查询参数说明

**产品列表查询参数**：

| 参数 | 类型 | 说明 |
|------|------|------|
| fullName | String | 名称（模糊查询） |
| enabledMark | Integer | 状态（精确匹配）|

### 返回字段说明

**左侧产品类别树返回字段**（SysProductVo）：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键ID |
| parentId | Long | 父级ID |
| fullName | String | 产品类别名称 |
| enCode | String | 编码 |
| sortCode | Integer | 排序码 |
| enabledMark | Integer | 状态（1-正常 0-停用） |
| categoryId | Long | 类别ID（用于关联右侧数据） |
| hasChildren | Boolean | 是否有子节点 |
| children | List | 子节点列表 |

**右侧产品数据树返回字段**（SysProductVo）：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键ID |
| parentId | Long | 父级ID |
| fullName | String | 产品名称 |
| enCode | String | 编码 |
| sortCode | Integer | 排序码 |
| enabledMark | Integer | 状态（1-正常 0-停用） |
| description | String | 说明 |
| categoryId | Long | 所属类别ID |
| hasChildren | Boolean | 是否有子节点 |
| children | List | 子节点列表 |

### 删除规则

- 如果要删除的节点存在子节点，则不允许删除
- 前端检查 children 数组是否有数据
- 后端检查是否有子数据记录
- 返回提示信息："该数据存在子元素，无法删除"

### 新增逻辑

1. **新增类别**：点击左侧"新增类别"按钮，新增产品类别记录到 sys_product 表
2. **新增子级**：在右侧选中某条数据后，点击"新增"按钮，以选中行作为父级新增子数据

### 与原提案的关系

- **原有基于字典表的实现保持不变**：原 system-product 提案中的代码不删除、不修改
- index.vue 使用新的 sys_product 表和 API
- 原 index.vue 继续使用字典表 API

### 后续扩展

- **建材产品关联**：后续在建材产品模块中选择产品时，被选择的产品不能被删除
  - 在删除产品前，检查是否被建材产品关联
  - 如果有关联，则不允许删除，返回提示信息："该产品已被建材产品使用，无法删除"

### 扩展功能（实际实现）

#### 前端扩展

1. **左侧类别树操作**
   - 每行显示编辑和删除按钮（鼠标悬停时显示）
   - 点击编辑按钮：弹出编辑弹窗，可修改名称、编码、排序、状态、说明
   - 点击删除按钮：检查是否有子节点和关联产品，无关联则确认删除

2. **新增类别时上级分类**
   - 使用 el-tree-select 树形选择器
   - 未选中左侧类别：显示"顶级分类"作为根，所有现有类别作为子节点
   - 选中左侧类别：显示当前选中类别及其所有子节点作为可选上级

3. **编辑类别时上级分类**
   - 上级分类显示为禁用状态，不可修改（显示父级名称，如果是顶级则显示"顶级分类"）

4. **新增产品时上级分类**
   - 显示当前选中类别及其右侧产品树（类别+产品+规格）
   - 允许在任意层级添加子元素

#### 后端扩展

1. **新增类别接口优化**
   - 保留前端传递的 parentId，不强制覆盖
   - 只有未传递 parentId 时才默认为 "0"

2. **nodeType 处理逻辑优化**
   - 新增时只有当 nodeType 为空时才根据父级自动设置
   - 前端明确传递 nodeType 时保留原值

#### 接口合并

编辑和删除类别与产品共用同一接口：

| 接口 | 方法 | 说明 |
|------|------|------|
| /system/product | PUT | 修改产品或类别 |
| /system/product/{id} | DELETE | 删除产品或类别 |

后端通过 nodeType 字段区分数据类型。
