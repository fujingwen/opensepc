# 产品管理（字典替换）规范

## 模块概述

- **模块名称**: system_product_dict
- **模块说明**: 产品管理（使用 sys_product 表替代字典表）
- **功能范围**: 产品类别管理和产品数据管理

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
| /system/product/index1 | system/product/index1 | 产品管理页面（字典替换） |

## API 列表

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 类别列表 | GET | /system/product/category/list | 获取产品类别列表 |
| 产品列表 | GET | /system/product/list/{categoryId} | 获取产品列表 |
| 新增类别 | POST | /system/product/category | 新增产品类别 |
| 修改类别 | PUT | /system/product/category | 修改产品类别 |
| 删除类别 | DELETE | /system/product/category/{id} | 删除产品类别 |
| 新增产品 | POST | /system/product | 新增产品 |
| 修改产品 | PUT | /system/product | 修改产品 |
| 删除产品 | DELETE | /system/product/{id} | 删除产品 |

## 数据模型

### sys_product 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键ID |
| tenant_id | varchar(20) | 租户编号 |
| parent_id | bigint | 父级ID |
| full_name | varchar(100) | 名称 |
| en_code | varchar(50) | 编码 |
| simple_spelling | varchar(100) | 简拼 |
| category_id | bigint | 类别ID |
| description | varchar(500) | 描述 |
| sort_code | integer | 排序码 |
| enabled_mark | smallint | 状态 |
| del_flag | char(1) | 删除标志 |
| create_by | bigint | 创建者 |
| create_time | timestamp | 创建时间 |
| update_by | bigint | 更新者 |
| update_time | timestamp | 更新时间 |
| remark | varchar(500) | 备注 |
