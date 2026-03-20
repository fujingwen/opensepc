# 行政区划管理

## Why

目前各业务模块（生产企业、施工企业、代理商等）在录入地址信息时都需要实现省市区三级联动选择功能，但每个模块都各自实现了一套类似的逻辑，导致代码重复、维护困难。需要提供统一的行政区划数据管理和选择组件。

## What Changes

- 使用现有 master.base_province 表存储行政区划数据
- 新增行政区划管理后端 API（系统管理 -> 行政区划）
- 新增行政区划管理前端页面（懒加载树形结构展示）
- 创建 RegionSelect 公共组件，供各业务模块复用

## Capabilities

### New Capabilities

- `system-region`: 行政区划管理（系统管理 -> 行政区划页面）
  - 支持懒加载树形结构展示
  - 首次加载只显示第一层级数据
  - 展开节点时按需加载子节点
- `common-region-picker`: 省市区三级联动选择组件（Popover形式）
- `common-region-dialog`: 省市区三级联动选择组件（Dialog形式）

### Modified Capabilities

- (无)

## Impact

- 后端：新增系统管理-行政区划相关 API
- 前端：新增系统管理-行政区划页面，新增RegionSelect公共组件
- 数据库：使用master.base_province表（已从test模式复制45331条数据）

## Notes

- **重要**：数据库中 `F_DeleteMark` 字段类型为 `integer`，当前所有记录的值均为 `null`，实际值（0代表存在，2代表删除）需要确认并更新数据

### 待确认问题

1. **第四层级是否还可以新增新的子层级？**
   - 当前数据结构：省/直辖市 -> 市 -> 区县 -> 街道
   - 是否需要支持第五层级或更多层级？

2. **数据库字段是否需要迁移？**
   - 当前表结构与系统标准字段存在差异
   - 需要确认是否需要添加以下字段：
     - `create_by` - 创建人
     - `create_time` - 创建时间
     - `update_by` - 更新人
     - `update_time` - 更新时间
     - `del_flag` - 删除标记
     - `tenant_id` - 租户ID
     - `create_dept` - 创建部门

### 当前表字段映射

| 业务字段 | 数据库字段 | 说明 |
|---------|-----------|------|
| id | F_Id | 主键 |
| parentId | F_ParentId | 上级区划ID |
| enCode | F_EnCode | 行政区划编码 |
| fullName | F_FullName | 行政区划名称 |
| quickQuery | F_QuickQuery | 快速查询码 |
| type | F_Type | 类型（1-省/直辖市 2-市 3-区县 4-街道） |
| description | F_Description | 描述 |
| sortCode | F_SortCode | 排序码 |
| enabledMark | F_EnabledMark | 状态（1-正常 0-停用） |
| creatorTime | F_CreatorTime | 创建时间 |
| creatorUserId | F_CreatorUserId | 创建人ID |
| lastModifyTime | F_LastModifyTime | 最后修改时间 |
| lastModifyUserId | F_LastModifyUserId | 最后修改人ID |
| delFlag | F_DeleteMark | 删除标志（0代表存在 2代表删除） |
| deleteTime | F_DeleteTime | 删除时间 |
| deleteUserId | F_DeleteUserId | 删除人ID |

## Implementation Details

### 前端树形结构展示

**数据格式要求：**

首次加载第一层级数据：

```json
{
  "enCode": "1134",
  "enabledMark": 1,
  "fullName": "北京市",
  "sortCode": 0,
  "id": "11",
  "parentId": "-1",
  "hasChildren": true,
  "children": [],
  "num": 0,
  "isLeaf": false
}
```

展开节点时加载子节点：

```json
{
  "enCode": "1101",
  "enabledMark": 1,
  "fullName": "市辖区",
  "sortCode": 0,
  "id": "1101",
  "parentId": "11",
  "hasChildren": true,
  "children": [],
  "num": 0,
  "isLeaf": false
}
```

**懒加载实现：**

- 首次进入页面时，只查询 `parentId = "-1"` 的第一层级数据（不包含 `parentId is null` 的数据）
- 展开节点时，根据父节点 `id` 查询对应的子节点
- 前端列表不展示上级区划和创建时间字段
- 后端根据查询结果自动填充 `hasChildren` 和 `isLeaf` 字段
  - `hasChildren`: 是否有子节点（true/false）
  - `isLeaf`: 是否是叶子节点（true/false）

**返回字段说明：**

接口返回数据只包含以下字段：

- `id`: 主键
- `parentId`: 上级区划ID
- `enCode`: 行政区划编码
- `fullName`: 行政区划名称
- `sortCode`: 排序码
- `enabledMark`: 状态（1-正常，0-停用）
- `children`: 子节点列表
- `hasChildren`: 是否有子节点
- `isLeaf`: 是否是叶子节点

**状态字典配置：**

- 字典类型：`sys_region_status`（行政区划状态）
- 字典数据：
  - `1`: 正常
  - `0`: 停用
- SQL文件位置：`sql/dict/sys_region_status.sql`
