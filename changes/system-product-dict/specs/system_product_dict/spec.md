# 产品管理（字典）规范

- **模块名称**: system_product_dict
- **模块说明**: 产品管理（使用字典表 base_dictionarytype 和 base_dictionarydata）
- **功能范围**: 产品类别管理和产品数据管理

## ADDED Requirements

### Requirement: 产品类别查询

系统 SHALL 支持查询产品类别列表，以树形结构展示。

#### Scenario: 查询产品类别列表

- **GIVEN** 用户在产品管理页面
- **WHEN** 用户未进行任何操作
- **THEN** 左侧显示产品类别树（base_dictionarytype 表中的记录）
- **AND** 显示所有层级的类别（后端组织树形结构）

### Requirement: 产品列表加载

系统 SHALL 支持选中产品类别后加载对应的产品列表。

#### Scenario: 选中产品类别，加载右侧产品列表

- **GIVEN** 左侧产品类别树已加载
- **WHEN** 用户点击某个产品类别
- **THEN** 右侧加载该类别下的所有产品数据（通过 dictionary_type_id 关联）
- **AND** 以树形表格形式展示
- **AND** 包含序号、名称、编码、排序、状态列

### Requirement: 产品列表查询

系统 SHALL 支持按名称和状态查询产品列表。

#### Scenario: 右侧产品列表名称和状态查询

- **GIVEN** 右侧已加载产品列表
- **WHEN** 用户在名称查询框输入关键字并点击搜索按钮
- **THEN** 系统根据名称进行模糊查询并返回匹配的产品列表
- **WHEN** 用户选择状态筛选
- **THEN** 系统根据状态进行精确查询并返回匹配的产品列表

### Requirement: 新增产品类别

系统 SHALL 支持新增产品类别。

#### Scenario: 新增产品类别

- **GIVEN** 用户在产品管理页面
- **WHEN** 用户点击左侧"新增类别"按钮
- **THEN** 弹出新增对话框
- **WHEN** 用户填写类别名称、编码等信息并点击确定按钮
- **THEN** 系统保存新产品类别到 base_dictionarytype 表
- **AND** 左侧类别树刷新显示新数据

### Requirement: 新增产品

系统 SHALL 支持新增产品数据。

#### Scenario: 新增产品子级

- **GIVEN** 已在左侧选中某个产品类别
- **WHEN** 用户点击右侧某行的"新增"按钮
- **THEN** 弹出新增对话框，父级自动选中当前行
- **WHEN** 用户填写产品名称等信息并点击确定按钮
- **THEN** 系统保存产品数据到 base_dictionarydata 表
- **AND** 右侧列表刷新显示新数据

### Requirement: 编辑产品

系统 SHALL 支持编辑产品信息。

#### Scenario: 编辑产品

- **GIVEN** 右侧产品列表已显示
- **WHEN** 用户点击某行的编辑按钮
- **THEN** 弹出编辑对话框，显示当前产品信息
- **WHEN** 用户修改产品信息并点击确定按钮
- **THEN** 系统更新产品信息
- **AND** 列表刷新显示更新后的数据

### Requirement: 删除产品

系统 SHALL 支持删除产品，但有子元素时不允许删除。

#### Scenario: 删除产品（无子元素）

- **GIVEN** 右侧产品列表已显示
- **WHEN** 用户点击某行的删除按钮且该产品没有子元素
- **THEN** 弹出确认对话框
- **WHEN** 用户确认删除
- **THEN** 系统删除该产品（设置 del_flag = 2）
- **AND** 列表刷新并显示删除成功提示

#### Scenario: 删除产品（有子元素，不允许删除）

- **GIVEN** 右侧产品列表已显示
- **WHEN** 用户点击某行的删除按钮且该产品存在子元素（children.length > 0）
- **THEN** 弹出提示信息："该数据存在子元素，无法删除"
- **AND** 不执行删除操作

### Requirement: 展开/收起树形表格

系统 SHALL 支持展开和收起右侧树形表格。

#### Scenario: 展开/收起右侧树形表格

- **GIVEN** 右侧产品列表已显示（树形表格）
- **WHEN** 用户点击"展开"按钮
- **THEN** 展开所有树形节点
- **WHEN** 用户点击"收起"按钮
- **THEN** 收起所有树形节点

### Requirement: 表单验证

系统 SHALL 验证必填字段。

#### Scenario: 验证必填字段

- **GIVEN** 新增产品对话框已打开
- **WHEN** 用户不填写名称直接点击确定
- **THEN** 系统提示："名称不能为空"且表单验证失败，无法提交
- **WHEN** 用户不填写编码直接点击确定
- **THEN** 系统提示："编码不能为空"且表单验证失败，无法提交

## 功能列表

| 功能 | 说明 |
|------|------|
| 产品类别管理 | 左侧产品类别树的增删改查 |
| 产品数据管理 | 右侧产品数据的增删改查 |
| 树形结构展示 | 支持多级树状结构展示 |
| 搜索查询 | 支持按名称和状态查询 |

## 页面路由

| 路由 | 组件 | 说明 |
|------|------|------|
| /system/product/index | system/product/index | 产品管理页面（字典） |

## API 列表

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 类别列表 | GET | /base/dictionary/type/list | 获取字典类型列表（产品类别） |
| 产品列表 | GET | /base/dictionary/data/list/{dictionaryTypeId} | 获取字典数据列表（产品数据） |
| 新增类别 | POST | /base/dictionary/type | 新增字典类型 |
| 修改类别 | PUT | /base/dictionary/type | 修改字典类型 |
| 删除类别 | DELETE | /base/dictionary/type/{id} | 删除字典类型 |
| 新增产品 | POST | /base/dictionary/data | 新增字典数据 |
| 修改产品 | PUT | /base/dictionary/data | 修改字典数据 |
| 删除产品 | DELETE | /base/dictionary/data/{id} | 删除字典数据 |

## 数据模型

### base_dictionarytype 表（产品类别）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | varchar(50) | 主键ID |
| tenant_id | varchar(50) | 租户编号 |
| parent_id | varchar(50) | 父级ID（顶级为 -1） |
| full_name | varchar(200) | 类别名称 |
| en_code | varchar(100) | 编码 |
| sort_code | bigint | 排序码 |
| enabled_mark | integer | 状态（1-正常 0-停用） |
| description | varchar(500) | 描述 |
| del_flag | char(1) | 删除标志（0-正常 2-删除） |
| create_by | bigint | 创建者 |
| create_time | timestamp | 创建时间 |
| update_by | bigint | 更新者 |
| update_time | timestamp | 更新时间 |
| remark | varchar(500) | 备注 |

### base_dictionarydata 表（产品数据）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | varchar(50) | 主键ID |
| tenant_id | varchar(50) | 租户编号 |
| parent_id | varchar(50) | 父级ID |
| dictionary_type_id | varchar(50) | 所属字典类型ID |
| full_name | varchar(200) | 名称 |
| en_code | varchar(100) | 编码 |
| sort_code | bigint | 排序码 |
| enabled_mark | integer | 状态（1-正常 0-停用） |
| description | varchar(500) | 描述 |
| del_flag | char(1) | 删除标志（0-正常 2-删除） |
| create_by | bigint | 创建者 |
| create_time | timestamp | 创建时间 |
| update_by | bigint | 更新者 |
| update_time | timestamp | 更新时间 |
| remark | varchar(500) | 备注 |

## 数据层级关系

### 产品类别树（左侧）

- **数据源**: base_dictionarytype 表
- **顶级节点**: parent_id = '-1'
- **层级关系**: 通过 parent_id 建立父子关系
- **展示方式**: 树形结构

### 产品数据树（右侧）

- **数据源**: base_dictionarydata 表
- **关联关系**: 通过 dictionary_type_id 关联到 base_dictionarytype
- **层级关系**: 通过 parent_id 建立父子关系
- **展示方式**: 树形表格

## 状态字典

使用系统字典 `sys_region_status`：

| 值 | 标签 | 说明 |
|----|--------|------|
| 1 | 正常 | 正常启用状态 |
| 0 | 停用 | 已停用状态 |

## 权限标识

| 权限标识 | 说明 |
|---------|------|
| base:dictionary:list | 查询 |
| base:dictionary:query | 详情 |
| base:dictionary:add | 新增 |
| base:dictionary:edit | 修改 |
| base:dictionary:remove | 删除 |
