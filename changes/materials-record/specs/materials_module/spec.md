# 建材填报管理模块规范

## 1. 模块概述

建材填报管理模块用于管理建材相关的信息，包含三个业务模块：

- 工程项目
- 建材产品
- 备案产品

## 2. 目录结构

### 后端结构

```
hny-modules/
└── hny-building-materials/
    ├── src/main/java/com/hny/building/materials/
    │   ├── controller/       # 控制器
    │   ├── service/          # 服务层
    │   ├── domain/           # 实体类
    │   ├── mapper/           # Mapper接口
    │   └── vo/               # 视图对象
    └── src/main/resources/mapper/   # XML映射文件
```

### 前端结构

```
src/views/
└── building-materials/
    ├── project/
    │   └── index.vue        # 工程项目页面
    ├── product/
    │   └── index.vue        # 建材产品页面
    └── record/
        └── index.vue        # 备案产品页面
```

## 3. 权限配置

### 菜单配置

- 菜单名称：建材填报管理
- 子菜单：
  - 工程项目管理
  - 建材产品管理
  - 备案产品管理

### 权限编码

- 模块权限：materials
- 备案产品权限：
  - 页面：materials:record:list
  - 查询：materials:record:query
  - 新增：materials:record:add
  - 编辑：materials:record:edit
  - 删除：materials:record:remove

## 4. 技术实现

- 后端：Spring Boot + MyBatis-Plus + Sa-Token
- 前端：Vue 3 + Element Plus + Axios
- 数据库：PostgreSQL

## 5. 集成要求

- 与现有权限管理体系集成
- 遵循现有的编码规范
- 保持与现有系统的风格一致

## ADDED Requirements

### Requirement: 模块目录结构

系统 SHALL 创建建材填报管理模块的目录结构，包括后端模块目录和前端页面目录。

#### Scenario: 创建建材填报管理模块目录结构

- **Given** 项目需要新增建材填报管理模块
- **When** 开发人员创建目录结构
- **Then** 后端创建 `hny-building-materials` 模块目录
- **Then** 前端创建 `building-materials` 目录及其子目录

### Requirement: 前端页面文件

系统 SHALL 为建材填报管理模块的三个子业务创建前端页面文件。

#### Scenario: 创建前端页面文件

- **Given** 模块需要前端页面
- **When** 开发人员创建页面文件
- **Then** 为 `project`、`product`、`record` 目录分别创建 `index.vue` 文件

### Requirement: 模块权限配置

系统 SHALL 配置建材填报管理模块的权限编码，包括模块权限和备案产品权限。

#### Scenario: 配置模块权限

- **Given** 系统需要权限控制
- **When** 管理员配置权限
- **Then** 模块权限设置为 `building:materials`
- **Then** 备案产品权限设置为三级结构
