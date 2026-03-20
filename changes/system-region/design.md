## Context

本模块实现系统管理下的行政区划管理功能，包括行政区划数据的增删改查以及供各业务模块复用的省市区选择组件。

本模块使用 `master.base_province` 表存储行政区划数据。

技术栈：

- 后端：Java 17, Spring Boot 3.2.6, MyBatis-Plus 3.5.7, Sa-Token 1.38.0
- 前端：Vue 3.4.31, Vite 5.3.2, Element Plus 2.7.6, Pinia

## Goals / Non-Goals

**Goals:**

- 实现行政区划数据的后端 API（查询、增删改）
- 实现行政区划管理前端页面（系统管理 -> 行政区划）
- 创建 RegionSelect 公共组件，供各业务模块复用
- 实现后端地区名称自动填充功能

**Non-Goals:**

- 省市区数据的实时更新机制（仅提供导入功能）

## Decisions

### 数据库设计

**省市区数据表 (master.base_province)**

使用现有 `master.base_province` 表，字段说明：

| 字段名 | 类型 | 说明 |
|--------|------|------|
| F_Id | VARCHAR(64) | 主键 |
| F_ParentId | VARCHAR(64) | 上级区划ID |
| F_EnCode | VARCHAR(50) | 行政区划编码 |
| F_FullName | VARCHAR(100) | 行政区划名称 |
| F_QuickQuery | VARCHAR(100) | 快速查询码 |
| F_Type | INT | 类型（1-省/直辖市 2-市 3-区县 4-街道） |
| F_Description | TEXT | 描述 |
| F_SortCode | INT | 排序码 |
| F_EnabledMark | INT | 状态（1-正常 0-停用），用字典标识 |
| F_CreatorTime | TIMESTAMP | 创建时间 |
| F_CreatorUserId | VARCHAR(64) | 创建人ID |
| F_LastModifyTime | TIMESTAMP | 最后修改时间 |
| F_LastModifyUserId | VARCHAR(64) | 最后修改人ID |
| F_DeleteMark | INT | 删除标记（0-正常 1-已删除） |
| F_DeleteTime | TIMESTAMP | 删除时间 |
| F_DeleteUserId | VARCHAR(64) | 删除人ID |
| tenant_id | VARCHAR(50) | 租户ID |
| create_dept | BIGINT | 创建部门 |
| create_by | VARCHAR(50) | 创建人 |
| update_by | VARCHAR(50) | 更新人 |
| del_flag | SMALLINT | 删除标记 |

### 菜单和权限设计

**菜单结构**

```
系统管理 (system)
└── 行政区划
    ├── system:region:list
    ├── system/region/index
    ├── 新增: system:region:add
    ├── 修改: system:region:edit
    └── 删除: system:region:remove
```

### 后端API设计

**行政区划API**

- GET /system/region/list - 分页查询，权限：system:region:query
- GET /system/region/{id} - 获取详情，权限：system:region:query
- POST /system/region - 新增，权限：system:region:add
- PUT /system/region - 修改，权限：system:region:edit
- DELETE /system/region/{id} - 删除，权限：system:region:remove
- GET /system/region/treeselect - 获取树形数据（用于下拉选择），权限：system:region:query

### 前端设计

**页面结构**

- 使用Element Plus的Table组件展示数据列表
- 使用Dialog组件实现新增/修改弹窗
- 使用Form组件实现表单验证
- 使用ElMessage进行操作反馈
- 使用ElSwitch组件实现状态开关

**行政区划管理页面（系统管理 -> 行政区划）**

列表展示字段：

- 行政区划编码（F_EnCode）
- 行政区划名称（F_FullName）
- 上级区划（F_ParentId）
- 排序（F_SortCode）
- 状态（F_EnabledMark，用字典标识）
- 创建时间（F_CreatorTime）
- 操作（编辑、删除）

新增页面字段：

- 上级区划（树形选择，支持搜索）
- 行政区划编码（input，必填）
- 行政区划名称（input，必填）
- 显示排序（input，必填，数字）
- 状态（switch开关，默认开启）

编辑页面字段：

- 上级区划（树形选择，支持搜索，可编辑）
- 行政区划编码（可编辑）
- 行政区划名称（可编辑）
- 显示排序（可编辑，数字）
- 状态（switch开关）
- 创建时间（不可编辑，仅展示）

表单验证规则：

- 行政区划编码：必填，最大长度50，唯一性验证
- 行政区划名称：必填，最大长度100
- 显示排序：必填，数字

**路由设计**

```
/system
  /region - 行政区划管理
```

### RegionSelect 公共组件设计

创建RegionSelect组件，实现省市区三级联动选择弹窗：

- 组件路径：`src/components/RegionSelect/index.vue`
- 弹窗样式：
  - 标题："选择省/市/县"
  - 使用ElDialog组件弹出
  - 左侧：省/市/县三个Tab切换，点击Tab时加载对应级别的数据
  - 右侧：当前级别可选列表（点击选中）
  - 底部：显示当前已选择路径（如：山东省/青岛市/黄岛区），右侧为取消、确定按钮
- 功能特性：
  - 点击input弹出选择弹窗
  - 默认显示"省"Tab，点击省份后加载该省的城市列表
  - 切换到"市"Tab，显示该省份下的城市列表
  - 切换到"县"Tab，显示该城市下的区县列表
  - 点击选项后自动选中，并更新已选择区域显示
  - 支持清空操作
  - 支持编辑时回显已选择的地区
- 组件API：
  - Props：
    - `modelValue`: Object类型，包含provinceCode、provinceName、cityCode、cityName、districtCode、districtName
    - `level`: Number类型，默认3，表示选择级别（2表示省市，3表示省市区）
    - `placeholder`: String类型，默认"请选择省/市/县"
  - Events：
    - `update:modelValue`: 更新选择值
    - `change`: 选择变化时触发
- 数据接口：
  - 使用`@/api/system/region`中的API接口
  - `getRegionChildren(parentId)`: 根据父级ID获取子级列表（懒加载）
  - `getRegionTree()`: 获取树形结构数据（用于回显）

### 后端地区名称自动填充

在Service层实现地区名称自动填充：

- 查询列表、详情时自动填充省市区名称
- 填充逻辑：
  - 根据provinceCode查询base_province表获取provinceName
  - 根据cityCode查询base_province表获取cityName
  - 根据districtCode查询base_province表获取districtName
- 实现方式：
  - 提供RegionNameFillUtil工具类
  - 各业务模块在需要时调用工具类填充地区名称

### 省市区数据管理方案

**数据来源**

- 使用master.base_province表存储数据
- 已通过数据迁移从test模式导入45331条行政区划数据

**数据加载策略**

- 前端采用懒加载方式
- 选择省份后加载该省的城市列表
- 选择城市后加载该市的区县列表

**缓存策略**

- 省份列表在应用启动时加载并缓存
- 城市/区县数据使用Pinia缓存，避免重复请求

## Risks / Trade-offs

**风险1：省市区数据更新**

- 风险：行政区划可能调整，需要定期更新数据
- 缓解：提供省市区数据导入功能，支持从Excel或JSON文件批量更新

**权衡：数据实时性**

- 决策：采用懒加载+本地缓存策略
- 理由：减少初始加载时间，提升用户体验，数据更新频率较低

## Migration Plan

1. **数据库确认**
   - 确认master.base_province表已存在（已从test模式复制）
   - 确认表字段已添加系统字段（tenant_id, create_dept, create_by, create_time, update_by, update_time, del_flag）

2. **后端部署**
   - 部署新的Controller、Service、Mapper
   - 提供RegionNameFillUtil工具类

3. **前端部署**
   - 部署行政区划管理页面（系统管理 -> 行政区划）
   - 部署RegionSelect公共组件
   - 配置路由和菜单

4. **回滚策略**
   - 前端可通过路由配置快速禁用新页面

## Open Questions

1. 省市区数据是否需要支持多语言？（当前仅支持中文）
2. 是否需要支持乡镇/街道级别？（当前仅支持省市区三级）
