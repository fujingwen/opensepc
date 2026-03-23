# 产品管理功能规格

## Feature: 产品管理

作为系统管理员，我需要管理产品数据，包括产品类别和产品数据，以便于在建材产品中选择使用。

## Background:

```gherkin
Given 系统已登录管理员用户
And 拥有产品管理权限
```

## Scenario: 查询产品类别列表

```gherkin
Given 用户在产品管理页面
When 用户未进行任何操作
Then 左侧显示产品类别树（字典类型）
And 显示所有层级的类别（后端组织树形结构）
```

## Scenario: 选中产品类别，加载右侧产品列表

```gherkin
Given 左侧产品类别树已加载
When 用户点击某个产品类别
Then 右侧加载该类别下的所有产品数据（字典数据）
And 以树形表格形式展示
And 包含序号、名称、编码、排序、状态列
```

## Scenario: 右侧产品列表名称和状态查询

```gherkin
Given 右侧已加载产品列表
When 用户在名称查询框输入关键字
And 点击搜索按钮
Then 系统根据名称进行模糊查询
And 返回匹配的产品列表
When 用户选择状态筛选
Then 系统根据状态进行精确查询
And 返回匹配的产品列表
```

## Scenario: 新增产品类别

```gherkin
Given 用户在产品管理页面
When 用户点击左侧"新增类别"按钮
Then 弹出新增对话框
When 用户填写类别名称、编码等信息
And 点击确定按钮
Then 系统保存新产品类别到 base_dictionarytype 表
And 左侧类别树刷新显示新数据
```

## Scenario: 新增产品子级

```gherkin
Given 已在左侧选中某个产品类别
When 用户点击右侧某行的"新增"按钮
Then 弹出新增对话框，父级自动选中当前行
When 用户填写产品名称等信息
And 点击确定按钮
Then 系统保存产品数据到 base_dictionarydata 表
And 右侧列表刷新显示新数据
```

## Scenario: 编辑产品

```gherkin
Given 右侧产品列表已显示
When 用户点击某行的编辑按钮
Then 弹出编辑对话框，显示当前产品信息
When 用户修改产品信息
And 点击确定按钮
Then 系统更新产品信息
And 列表刷新显示更新后的数据
```

## Scenario: 删除产品（无子元素）

```gherkin
Given 右侧产品列表已显示
When 用户点击某行的删除按钮
And 该产品没有子元素
Then 弹出确认对话框
When 用户确认删除
Then 系统删除该产品（设置 del_flag = 2）
And 列表刷新
And 显示删除成功提示
```

## Scenario: 删除产品（有子元素，不允许删除）

```gherkin
Given 右侧产品列表已显示
When 用户点击某行的删除按钮
And 该产品存在子元素（children.length > 0）
Then 弹出提示信息："该数据存在子元素，无法删除"
And 不执行删除操作
```

## Scenario: 展开/收起右侧树形表格

```gherkin
Given 右侧产品列表已显示（树形表格）
When 用户点击"展开"按钮
Then 展开所有树形节点
When 用户点击"收起"按钮
Then 收起所有树形节点
```

## Scenario: 验证必填字段

```gherkin
Given 新增产品对话框已打开
When 用户不填写名称直接点击确定
Then 系统提示："名称不能为空"
And 表单验证失败，无法提交
When 用户不填写编码直接点击确定
Then 系统提示："编码不能为空"
And 表单验证失败，无法提交
```
