## Why

需要建立生产企业信息管理功能，用于管理生产企业的基本信息，为建材记录管理提供基础数据支撑。

根据用户角色实现差异化数据展示：
- 生产企业用户(roleKey为"production"):只能查看和编辑自己的生产企业信息

**注意**: 前端页面不需要做角色判断逻辑，列表数据由后端根据用户角色和权限进行过滤。

## What Changes

- 新增"生产企业"页面：实现新增、删除、修改、查询、导出功能
- 后端实现基于角色的数据过滤逻辑

## Capabilities

### New Capabilities

- `base_production`: 生产企业信息管理，包括企业名称、联系人、联系电话、省市区、详细地址等信息的增删改查和导出

### Modified Capabilities

(无)

## Impact

### 文件结构

```
├── 后端代码
│   ├── controller: BaseProductionController.java
│   ├── service: BaseProductionService.java
│   ├── mapper: BaseProductionMapper.java
│   └── model: BaseProduction.java
│
├── 前端代码
│   ├── views/base/production/index.vue
│   └── api/base/production.js
│
└── 数据库表SQL脚本
    ├── base_production.sql
    ├── base_menu.sql
    └── base_sequences.sql
```
