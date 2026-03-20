## Why

为了满足建材行业的管理需求，需要创建建材填报管理模块，实现备案产品的规范化管理，提高工作效率和数据准确性。

## What Changes

- 创建全新的建材填报管理模块，包含三个业务模块：工程项目、建材产品、备案产品
- 优先实现备案产品的增删改查功能
- 设计备案产品的数据模型和字段结构
- 实现前端页面和后端API接口
- 集成到现有的权限管理体系中

## Capabilities

### New Capabilities

- `materials_module`: 建材填报管理模块的核心功能
- `materials_record`: 备案产品的增删改查功能

### Modified Capabilities

## Impact

- 后端：新增建材模块相关的Controller、Service、Mapper等文件
- 前端：新增建材模块相关的页面组件和API调用
- 数据库：新增建材相关的表结构
- 权限：新增建材模块的菜单和权限配置
