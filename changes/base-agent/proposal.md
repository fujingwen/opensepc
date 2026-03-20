## Why

需要建立代理商信息管理功能，用于管理代理商（供应商）的基本信息。

代理商通过生产企业创建，查询时根据当前用户userId查询所有供应商。

## What Changes

- 新增"代理商"页面：实现新增、删除、修改、查询、导出功能
- 后端根据当前用户userId查询所有供应商

## Capabilities

### New Capabilities

- `base_agent`: 代理商信息管理，包括所属生产企业、代理商名称、详细地址、联系人、联系电话、用户账号等信息的增删改查和导出

### Modified Capabilities

(无)

## Impact

### 文件结构

```
├── 后端代码
│   ├── controller: BaseAgentController.java
│   ├── service: BaseAgentService.java
│   ├── mapper: BaseAgentMapper.java
│   └── model: BaseAgent.java
│
├── 前端代码
│   ├── views/base/agent/index.vue
│   └── api/base/agent.js
│
└── 数据库表SQL脚本
    ├── base_agent.sql
    ├── base_menu.sql
    └── base_sequences.sql
```
