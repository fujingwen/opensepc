# Architecture Specification

## ADDED Requirements

### Requirement: 后端模块命名规范

系统 SHALL 使用 `hny-` 前缀 + 单个英文单词作为模块名。

#### Scenario: 正确的模块命名

- **WHEN** 创建新的业务模块
- **THEN** 模块名应为 `hny-` 前缀 + 单个英文单词，如 `hny-system`、`hny-demo`、`hny-materials`

#### Scenario: 错误的模块命名

- **WHEN** 使用多个单词作为模块名
- **THEN** 应简化为单个英文单词，如 `hny-engineering-project` 应改为 `hny-project`

### Requirement: 后端包路径规范

系统 SHALL 在 `com.hny` 下直接创建模块包名，包名与模块名保持一致（去掉 `hny-` 前缀）。

#### Scenario: 正确的包路径

- **WHEN** 创建模块 `hny-materials`
- **THEN** 包路径应为 `com.hny.materials`

### Requirement: 后端目录结构规范

系统 SHALL 遵循标准的后端目录结构。

#### Scenario: 创建完整的后端模块目录

- **WHEN** 创建新的后端模块
- **THEN** 应创建以下目录结构：

  ```
  hny-modules/模块名/
  └── src/main/java/com/hny/模块名/
      ├── controller/     # 控制器
      ├── service/        # 服务层
      │   └── impl/       # 服务实现
      ├── domain/         # 实体类
      │   ├── bo/         # 业务对象
      │   └── vo/        # 视图对象
      └── mapper/         # Mapper接口
  ├── src/main/resources/mapper/  # XML映射文件
  └── pom.xml
  ```

### Requirement: 前端目录规范

系统 SHALL 将页面组件和API接口文件放置在正确的目录下。

#### Scenario: 创建前端页面目录

- **WHEN** 创建建材管理模块的页面
- **THEN** 页面应放置在 `src/views/materials/` 目录下

#### Scenario: 创建前端API文件

- **WHEN** 创建建材管理的API接口
- **THEN** API文件应放置在 `src/api/materials/` 目录下，文件名为 `project.js`（不使用 TypeScript）

### Requirement: 数据库表命名规范

系统 SHALL 使用下划线分隔的小写单词作为表名和字段名。

#### Scenario: 正确的表命名

- **WHEN** 创建工程项目表
- **THEN** 表名应为 `mat_project`（使用下划线分隔的小写字母）

#### Scenario: 表名使用单个英文单词

- **WHEN** 创建表名
- **THEN** 表名应尽量使用单个英文单词（去掉模块前缀后），如 `mat_project` 而不是 `mat_engineering_project`

#### Scenario: 正确的字段命名

- **WHEN** 创建字段
- **THEN** 字段名应为下划线分隔的小写单词，如 `enterprise_name`

### Requirement: Java类命名规范

系统 SHALL 使用驼峰命名法，首字母大写。

#### Scenario: 实体类命名

- **WHEN** 创建工程项目实体类
- **THEN** 类名应为 `MatProject`（模块前缀 + 功能描述，驼峰命名，首字母大写）

#### Scenario: 功能描述使用单个英文单词

- **WHEN** 创建类名
- **THEN** 功能描述应尽量使用单个英文单词，如 `MatProject` 而不是 `MatEngineeringProject`

#### Scenario: Controller命名

- **WHEN** 创建工程项目控制器
- **THEN** 类名应为 `MatProjectController`

#### Scenario: Service接口命名

- **WHEN** 创建工程项目服务接口
- **THEN** 类名应为 `IMatProjectService`

#### Scenario: Service实现命名

- **WHEN** 创建工程项目服务实现
- **THEN** 类名应为 `MatProjectServiceImpl`

#### Scenario: Mapper接口命名

- **WHEN** 创建工程项目Mapper接口
- **THEN** 类名应为 `MatProjectMapper`

### Requirement: 模块前缀对照规范

系统 SHALL 遵循模块前缀对照表。

#### Scenario: 使用正确的模块前缀

- **WHEN** 创建系统管理模块的表
- **THEN** 表名应使用 `sys_` 前缀，类名使用 `Sys` 前缀

#### Scenario: 使用建材管理模块前缀

- **WHEN** 创建建材管理模块的表
- **THEN** 表名应使用 `mat_` 前缀，类名使用 `Mat` 前缀

### Requirement: 标准字段规范

系统 SHALL 所有业务表必须包含标准字段。

#### Scenario: 包含所有标准字段

- **WHEN** 创建业务表
- **THEN** 表必须包含以下字段：
  - `create_time` timestamp NOT NULL DEFAULT now() - 创建时间
  - `update_time` timestamp NOT NULL DEFAULT now() - 更新时间
  - `create_by` varchar(50) - 创建人
  - `update_by` varchar(50) - 更新人
  - `del_flag` char(1) DEFAULT '0' - 删除标志（0-存在 2-删除）

#### Scenario: del_flag字段规范

- **WHEN** 创建逻辑删除字段
- **THEN** 字段名必须为 `del_flag`，类型为 `char(1)`，默认值为 '0'，实体类中使用 `@TableLogic` 注解

### Requirement: ID生成策略规范

系统 SHALL 使用数据库序列生成ID（默认策略）。

#### Scenario: 使用序列生成ID

- **WHEN** 创建表的主键
- **THEN** 应使用数据库序列生成ID，序列名为 `seq_{table_name}`，ID类型为 `bigint`

### Requirement: PostgreSQL语法规范

系统 SHALL 使用正确的PostgreSQL语法。

#### Scenario: 使用timestamp而不是datetime

- **WHEN** 创建日期时间字段
- **THEN** 应使用 `timestamp` 类型，而不是 `datetime`

#### Scenario: 使用smallint而不是tinyint

- **WHEN** 创建小整数字段
- **THEN** 应使用 `smallint` 类型，而不是 `tinyint`

#### Scenario: 使用varchar而不是text

- **WHEN** 创建有限长度的字符串字段
- **THEN** 应使用 `varchar(n)` 类型，而不是 `text`

#### Scenario: 使用text存储大文本

- **WHEN** 创建大文本字段（如备注）
- **THEN** 应使用 `text` 类型

#### Scenario: 使用decimal存储金额

- **WHEN** 创建金额字段
- **THEN** 应使用 `decimal(precision, scale)` 类型

#### Scenario: 使用master schema前缀

- **WHEN** 创建表或序列
- **THEN** 应使用 `"master"` schema前缀，如 `"master"."mat_project"`

### Requirement: 审计字段配置

系统 SHALL 审计字段应使用自动填充。

#### Scenario: 创建时间字段

- **WHEN** 定义创建时间字段
- **THEN** 应使用 `@TableField(fill = FieldFill.INSERT)` 注解

#### Scenario: 更新时间字段

- **WHEN** 定义更新时间字段
- **THEN** 应使用 `@TableField(fill = FieldFill.INSERT_UPDATE)` 注解

#### Scenario: 创建人字段

- **WHEN** 定义创建人字段
- **THEN** 应使用 `@TableField(fill = FieldFill.INSERT)` 注解

#### Scenario: 更新人字段

- **WHEN** 定义更新人字段
- **THEN** 应使用 `@TableField(fill = FieldFill.INSERT_UPDATE)` 注解

### Requirement: 字段类型映射

系统 SHALL Java字段类型应正确映射到数据库字段类型。

#### Scenario: String映射到varchar

- **WHEN** Java字段类型为 String
- **THEN** 数据库字段类型应为 `varchar(n)`，其中 n 为最大长度

#### Scenario: Integer映射到int

- **WHEN** Java字段类型为 Integer
- **THEN** 数据库字段类型应为 `int`

#### Scenario: Long映射到bigint

- **WHEN** Java字段类型为 Long
- **THEN** 数据库字段类型应为 `bigint`

#### Scenario: BigDecimal映射到decimal

- **WHEN** Java字段类型为 BigDecimal
- **THEN** 数据库字段类型应为 `decimal(precision, scale)`

#### Scenario: LocalDate映射到date

- **WHEN** Java字段类型为 LocalDate
- **THEN** 数据库字段类型应为 `date`

#### Scenario: LocalDateTime映射到timestamp

- **WHEN** Java字段类型为 LocalDateTime
- **THEN** 数据库字段类型应为 `timestamp`

### Requirement: 后端技术栈

系统 SHALL 使用以下后端技术栈。

#### Scenario: 基础环境

- **WHEN** 配置开发环境
- **THEN** 应使用以下版本：
  - JDK 17
  - Maven 3.x

#### Scenario: 核心框架

- **WHEN** 构建后端应用
- **THEN** 应使用以下框架：
  - Spring Boot 3.2.6
  - MyBatis-Plus 3.5.7
  - PostgreSQL（数据库）
  - Sa-Token 1.38.0（权限认证）
  - Redisson 3.31.0（Redis客户端）

### Requirement: 前端技术栈

系统 SHALL 使用以下前端技术栈。

#### Scenario: 核心框架

- **WHEN** 构建前端应用
- **THEN** 应使用以下版本：
  - Vue 3.4.31
  - Vite 5.3.2
  - JavaScript

#### Scenario: 核心依赖

- **WHEN** 使用前端依赖
- **THEN** 应使用以下库：
  - Element Plus 2.7.6（UI框架）
  - Pinia 2.1.7（状态管理）
  - Vue Router 4.4.0（路由）
  - Axios 0.28.1（HTTP请求）

### Requirement: 提案文档规范

系统 SHALL 提案文档应包含特定内容。

#### Scenario: 包含Why部分

- **WHEN** 编写提案文档
- **THEN** 应包含 Why 部分，说明创建该功能的原因和背景（1-2句话）

#### Scenario: 包含What Changes部分

- **WHEN** 编写提案文档
- **THEN** 应包含 What Changes 部分，使用 bullet list 格式列出将要实现的功能和变更

#### Scenario: 包含Capabilities部分

- **WHEN** 编写提案文档
- **THEN** 应包含 Capabilities 部分，列出新增的能力（使用 kebab-case 命名）和修改的能力

#### Scenario: 包含Impact部分

- **WHEN** 编写提案文档
- **THEN** 应包含 Impact 部分，说明文件结构、数据库变更、字段信息表格、字典数据

#### Scenario: 不包含路由配置

- **WHEN** 编写提案文档
- **THEN** 不应包含路由配置文件

### Requirement: 设计文档规范

系统 SHALL 设计文档应包含特定内容。

#### Scenario: 包含Context部分

- **WHEN** 编写设计文档
- **THEN** 应包含 Context 部分，说明背景和当前状态、技术栈

#### Scenario: 包含数据库设计

- **WHEN** 编写设计文档
- **THEN** 应包含完整的表结构 SQL、序列 SQL、索引 SQL（创建前先删除）、字段注释和表注释

#### Scenario: 包含菜单和权限设计

- **WHEN** 编写设计文档
- **THEN** 应包含菜单结构（树形结构，包含权限标识和组件路径）和按钮权限（仅权限标识）

#### Scenario: 菜单SQL规范

- **WHEN** 编写菜单SQL
- **THEN** 应包含菜单表（sys_menu）的INSERT语句，包含所有必需字段，使用 ON CONFLICT (menu_id) DO NOTHING 避免重复

#### Scenario: 字典SQL规范

- **WHEN** 编写字典SQL
- **THEN** 应包含字典类型表（sys_dict_type）和字典数据表（sys_dict_data）的INSERT语句，使用 ON CONFLICT (dict_id) DO NOTHING 避免重复

#### Scenario: 字典ID唯一性

- **WHEN** 新增字典类型
- **THEN** dict_id 必须在 sys_dict_type 表中唯一，应指定起始值（建议使用100-999范围）

#### Scenario: 字典数据编码唯一性

- **WHEN** 新增字典数据
- **THEN** dict_code 必须在 sys_dict_data 表中唯一，应指定起始值（建议使用1-999范围）

#### Scenario: 字典remark字段格式

- **WHEN** 编写字典SQL的remark字段
- **THEN** 应使用完整路径格式：`一级模块-二级模块-三级模块-字典名称`，如 `建材填报管理-工程项目-工程项目进度`

#### Scenario: 不包含路由设计

- **WHEN** 编写设计文档
- **THEN** 不应包含路由设计

### Requirement: 页面设计规范

系统 SHALL 页面设计文档应包含特定内容。

#### Scenario: 列出查询条件

- **WHEN** 编写页面设计文档
- **THEN** 应列出所有查询条件和类型

#### Scenario: 列出列表字段

- **WHEN** 编写页面设计文档
- **THEN** 应列出所有展示字段和显示格式

#### Scenario: 列出新增字段

- **WHEN** 编写页面设计文档
- **THEN** 应列出字段类型、必填、长度、验证规则

#### Scenario: 列出编辑字段

- **WHEN** 编写页面设计文档
- **THEN** 应标注可编辑和不可编辑字段

#### Scenario: 列出表单验证规则

- **WHEN** 编写页面设计文档
- **THEN** 应列出必填、长度、格式、唯一性验证

