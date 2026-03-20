## Why

需要创建工程项目管理功能，用于管理工程项目的基本信息、施工进度、施工单位等关键数据，支持查询、新增、详情、编辑和删除操作，以满足工程项目管理的业务需求。

## What Changes

- 在 `hny-materials` 模块下创建工程项目相关的后端代码（Controller、Service、Mapper、Domain等）
- 创建工程项目前端页面（查询列表、新增表单、详情、编辑表单）
- 创建工程项目数据库表和相关的菜单权限配置
- 添加工程项目相关的字典数据（工程进度、工程性质、工程结构型式、有无填报、是否对接一体化平台编码）

## Capabilities

### New Capabilities

- `materials_project`: 工程项目管理能力，包括工程项目的增删改查、查询条件、表单验证等功能

### Modified Capabilities

无

## Impact

### 文件结构

```
├── 后端代码（8个Java文件）
│   ├── controller: MatProjectController.java
│   ├── service: IMatProjectService.java
│   ├── service: MatProjectServiceImpl.java
│   ├── mapper: MatProjectMapper.java
│   ├── domain: MatProject.java
│   ├── domain/bo: MatProjectBo.java
│   └── domain/vo: MatProjectVo.java
│   
├── 前端代码（2个文件）
│   ├── views/materials/project/index.vue
│   └── api/materials/project.js
│   
└── 数据库表SQL脚本
    ├── base_mat_project.sql（表结构）
    ├── base_sequences.sql（序列）
    ├── base_indexes.sql（索引）
    ├── base_menu.sql（菜单权限）
    └── base_dict.sql（字典数据）
```

### 数据库变更

**mat_project 表新增**

用于存储工程项目的基本信息、施工进度、施工单位等数据。

### 字段信息

| 字段名 | 类型 | 长度 | 主键 | 非空 | 备注 |
|--------|------|------|------|------|------|
| id | bigint | 20 | 是 | 是 | 主键ID |
| constructionPermit | varchar | 100 | 否 | 是 | 施工许可证 |
| permitIssueDate | date | - | 否 | 是 | 施工许可证发证日期 |
| projectName | varchar | 200 | 否 | 是 | 工程名称 |
| projectNature | varchar | 50 | 否 | 是 | 工程性质（字典） |
| buildingArea | decimal | 10,2 | 否 | 是 | 建筑面积（平方米） |
| projectProgress | varchar | 50 | 否 | 是 | 工程进度（字典） |
| projectAddress | varchar | 500 | 否 | 是 | 工程地址 |
| structureType | varchar | 50 | 否 | 是 | 工程结构型式（字典） |
| qualitySupervisionAgency | varchar | 200 | 否 | 是 | 质量监督机构 |
| constructionUnit | varchar | 200 | 否 | 是 | 施工单位 |
| constructionUnitManager | varchar | 100 | 否 | 是 | 施工单位负责人 |
| managerContact | varchar | 20 | 否 | 是 | 施工单位负责人联系方式 |
| hasReport | varchar | 10 | 否 | 是 | 有无填报（字典） |
| isIntegrated | varchar | 10 | 否 | 是 | 是否对接一体化平台编码（字典） |
| remarks | text | - | 否 | 否 | 备注 |
| createTime | timestamp | - | 否 | 是 | 创建时间 |
| updateTime | timestamp | - | 否 | 是 | 更新时间 |
| createBy | varchar | 50 | 否 | 否 | 创建人 |
| updateBy | varchar | 50 | 否 | 否 | 更新人 |
| deleted | smallint | - | 否 | 是 | 删除标记 0-未删除 1-已删除 |

### 字典数据

**工程进度字典 (project_progress)**

- 施工前准备阶段
- 土方开挖及基坑支护阶段
- 基础施工阶段
- 总体结构 1/2 前阶段
- 总体结构 1/2 后阶段
- 装饰安装阶段
- 竣工预验阶段
- 停工

**工程性质字典 (project_nature)**

数据来源待确认

**工程结构型式字典 (project_structure)**

数据来源待确认

**有无填报字典 (has_report)**

- 有
- 无

**是否对接一体化平台编码字典 (is_integrated)**

- 是
- 否
