# 产品管理

## Why

目前系统中产品相关数据存储在字典表（base_dictionarytype 和 base_dictionarydata）中，数据格式为多级树状结构。为了提供完整的产品管理功能，需要实现前后端增删改查功能。

## What Changes

- 使用现有字典表（base_dictionarytype、base_dictionarydata）存储产品数据
- 新增产品管理后端 API（系统管理 -> 产品管理）
- 新增产品管理前端页面（左右分栏布局：左侧产品类别树，右侧产品数据树）
- 后端组织树形结构返回给前端
- 支持按名称和状态查询

## Capabilities

### New Capabilities

- `system-product`: 产品管理（系统管理 -> 产品管理页面）
  - 支持多级树状结构
  - 左侧产品类别树（字典类型）
  - 右侧产品数据列表（字典数据）
  - 支持新增类别、新增子级、编辑、删除
  - 支持按名称和状态查询

### Modified Capabilities

- (无)

## Impact

### 数据库

使用现有字典表，无需新建表：

| 表名 | 说明 |
|------|------|
| base_dictionarytype | 字典类型表（存储产品类别） |
| base_dictionarydata | 字典数据表（存储产品数据） |

### 后端（hny-base 模块）

| 文件路径 | 说明 |
|----------|------|
| domain/vo/BaseDictionarytypeVo.java | 字典类型视图对象 |
| domain/vo/BaseDictionarydataVo.java | 字典数据视图对象 |
| mapper/BaseDictionaryMapper.java | Mapper接口 |
| resources/mapper/base/BaseDictionaryMapper.xml | Mapper XML |
| service/IBaseDictionaryService.java | 服务接口 |
| service/impl/BaseDictionaryServiceImpl.java | 服务实现 |
| controller/BaseDictionaryController.java | 控制器 |

### 前端

| 文件路径 | 说明 |
|----------|------|
| api/base/dictionary.js | API接口 |
| views/system/product/index.vue | 页面组件 |

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

产品数据存储在字典表中：

| 表名 | 用途 | 字段说明 |
|------|------|----------|
| base_dictionarytype | 存储产品类别（左侧树） | full_name: 类别名称, en_code: 编码, parent_id: 父级ID |
| base_dictionarydata | 存储产品数据（右侧树） | full_name: 名称, en_code: 编码, parent_id: 父级ID, dictionary_type_id: 所属类别ID |

数据层级关系：

- 左侧树：base_dictionarytype 表，顶级节点 parent_id = '-1'
- 右侧树：base_dictionarydata 表，通过 dictionary_type_id 关联左侧类别

### 页面布局设计

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

- 左侧：产品类别树（字典类型），支持名称搜索，点击类别加载右侧数据
- 右侧：产品数据列表（字典数据），树形表格展示
- 表格列：序号、名称、编码、排序、状态、操作
- 操作列：新增（子级）、编辑、删除
- 按钮：新增类别、新增、展开、收起

### 交互逻辑

1. 首次进入页面，加载左侧产品类别树
2. 点击左侧类别，右侧加载该类别下的所有产品数据（一次性加载）
3. 左侧支持名称模糊查询
4. 右侧支持名称和状态查询
5. 点击"新增类别"：在左侧新增产品类别
6. 点击右侧"新增"：在当前选中数据下新增子级
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
| /base/dictionary/type/list | GET | 获取字典类型列表（左侧类别树） |
| /base/dictionary/data/list/{dictionaryTypeId} | GET | 获取字典数据列表（右侧产品列表），支持名称和状态查询 |
| /base/dictionary/type | POST | 新增字典类型 |
| /base/dictionary/type | PUT | 修改字典类型 |
| /base/dictionary/type/{id} | DELETE | 删除字典类型 |
| /base/dictionary/data | POST | 新增字典数据 |
| /base/dictionary/data | PUT | 修改字典数据 |
| /base/dictionary/data/{id} | DELETE | 删除字典数据 |

### 查询参数说明

**字典数据列表查询参数**：

| 参数 | 类型 | 说明 |
|------|------|------|
| fullName | String | 名称（模糊查询） |
| enabledMark | Integer | 状态（精确匹配） |

### 返回字段说明

**左侧产品类别树返回字段**（BaseDictionarytypeVo）：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 主键ID |
| parentId | String | 父级ID |
| fullName | String | 类别名称 |
| enCode | String | 编码 |
| sortCode | Long | 排序码 |
| enabledMark | Integer | 状态（1-正常 0-停用） |
| hasChildren | Boolean | 是否有子节点 |
| children | List | 子节点列表 |

**右侧产品数据树返回字段**（BaseDictionarydataVo）：

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 主键ID |
| parentId | String | 父级ID |
| fullName | String | 产品名称 |
| enCode | String | 编码 |
| sortCode | Long | 排序码 |
| enabledMark | Integer | 状态（1-正常 0-停用） |
| description | String | 说明 |
| dictionaryTypeId | String | 所属字典类型ID |
| hasChildren | Boolean | 是否有子节点 |
| children | List | 子节点列表 |

### 删除规则

- 如果要删除的节点存在子节点，则不允许删除
- 前端检查 children 数组是否有数据
- 后端检查是否有子数据记录
- 返回提示信息："该数据存在子元素，无法删除"

### 新增逻辑

1. **新增类别**：点击左侧"新增类别"按钮，新增字典类型到 base_dictionarytype 表
2. **新增子级**：在右侧选中某条数据后，点击"新增"按钮，以选中行作为父级新增子数据

### 后续扩展

- **建材产品关联**：后续在建材产品模块中选择产品时，被选择的产品不能被删除
  - 在删除产品前，检查是否被建材产品关联
  - 如果有关联，则不允许删除，返回提示信息："该产品已被建材产品使用，无法删除"
