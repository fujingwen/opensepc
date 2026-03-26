# 抽测缺陷建材产品 - 提案文档

## Why

质量追溯模块是建材监管系统的重要组成部分，用于记录和管理建材产品的质量检测数据。抽测缺陷建材产品页面是质量追溯模块的子页面，用于展示抽测过程中发现的缺陷建材产品信息。

当前数据存储在 test 模式下的 t_quality_trace 表中，需要迁移到 master 模式下，以符合系统整体架构要求。

## What Changes

- 将 test.t_quality_trace 表迁移到 master.t_quality_trace
- 按照数据库设计规范添加审计字段（create_by, create_time, update_by, update_time, del_flag, tenant_id, create_dept）
- 实现抽测缺陷建材产品页面的查询、导入、删除功能
- 配置对应的菜单和字典

## Capabilities

### New Capabilities

- `quality_trace_spot_testing`: 抽测缺陷建材产品管理

### 1. 数据迁移功能

- 将 test.t_quality_trace 表数据迁移到 master.t_quality_trace
- 字段映射关系：

| 旧字段 (test) | 新字段 (master) | 说明 |
|-------------|----------------|------|
| F_Id | id | 主键 |
| F_OriginalId | original_id | 原始ID |
| F_CheckOrganize | check_organize | 检测单位 |
| F_ProjectNo | project_no | 工程编号 |
| F_ProjectName | project_name | 工程名称 |
| F_ProductName | product_name | 检测产品名称 |
| F_FactoryName | factory_name | 生产厂家 |
| F_Batch | batch | 生产批号 |
| F_CheckProjectName | check_project_name | 检测项目名称 |
| F_DataStatus | data_status | 数据状态 |
| F_IsCollect | is_collect | 是否已采集 |
| F_ConclusionMark | conclusion_mark | 结论标志 |
| F_Conclusion | conclusion | 结论 |
| F_ReportTime | report_time | 报告日期 |
| F_CheckTime | check_time | 检测时间 |
| F_EnabledMark | enabled_mark | 有效标志 |

审计字段映射：

| 旧字段 (test) | 新字段 (master) | 说明 |
|-------------|----------------|------|
| F_CreatorUserId | create_by | 创建人 |
| F_CreatorTime | create_time | 创建时间 |
| F_LastModifyUserId | update_by | 更新人 |
| F_LastModifyTime | update_time | 更新时间 |
| F_DeleteUserId | delete_by | 删除人 |
| F_DeleteTime | delete_time | 删除时间 |
| F_DeleteMark | del_flag | 删除标记 |

### 2. 查询功能

查询条件：
- 产品名称（对应 product_name，模糊查询）
- 生产批号（对应 batch，模糊查询）
- 生产厂家（对应 factory_name，模糊查询）
- 检测项目（对应 check_project_name，模糊查询）
- 检测日期（对应 check_time，范围查询）
- 有无对比数据（字典，字典项：有、无）

### 3. 列表功能

Table 表格字段：
- 序号
- 检验检测工程名称（project_name）
- 检测项目（check_project_name）
- 检测产品名称（product_name）
- 生产厂家（factory_name）
- 生产批号（batch）
- 检测日期（check_time，格式：yyyy-MM-dd）
- 报告日期（report_time，格式：yyyy-MM-dd）
- 检验参数（check_project_name）
- 结论（conclusion，字典）
- 有无对比数据（has_check_data，字典：有、无）
- 操作（删除按钮）

### 4. 导入功能

导入字段对应关系：

| 导入字段 | 数据库字段 |
|----------|-----------|
| 项目名称 | project_name |
| 材料名称 | product_name |
| 生产批号 | batch |
| 生产厂家 | factory_name |
| 检测项目 | check_project_name |
| 检测日期 | check_time |
| 检测机构 | check_organize |
| 报告日期 | report_time |
| 不合格参数 | conclusion |

### 5. 删除功能

- 支持单条删除
- 删除时设置 del_flag = 1

## 数据模型

### 表结构 (master.t_quality_trace)

```sql
CREATE TABLE master.t_quality_trace (
    id VARCHAR(50) NOT NULL,
    tenant_id VARCHAR(20) NOT NULL DEFAULT '000000',
    original_id VARCHAR(50),
    check_organize VARCHAR(200),
    project_no VARCHAR(200),
    project_name VARCHAR(500),
    product_name VARCHAR(500),
    factory_name VARCHAR(500),
    batch VARCHAR(100),
    check_project_name VARCHAR(800),
    data_status VARCHAR(1),
    is_collect VARCHAR(1),
    conclusion_mark VARCHAR(50),
    conclusion VARCHAR(500),
    report_time TIMESTAMP,
    check_time TIMESTAMP,
    enabled_mark INTEGER,
    create_by VARCHAR(50),
    create_time TIMESTAMP,
    update_by VARCHAR(50),
    update_time TIMESTAMP,
    delete_by VARCHAR(50),
    delete_time TIMESTAMP,
    del_flag INTEGER DEFAULT 0,
    create_dept VARCHAR(50) DEFAULT '103',
    PRIMARY KEY (id, tenant_id)
);
```

## 技术实现

### 后端
- QualityTraceController: REST接口
- QualityTraceService/IQualityTraceService: 业务逻辑
- QualityTraceMapper: 数据访问
- QualityTraceMapper.xml: 自定义SQL

### 前端
- quality/spot-testing/index.vue: 抽测缺陷建材产品页面
- quality/spot-testing.js: API调用

### 字典配置
- 有无对比数据：dict_code=1 有，dict_code=2 无
- 结论：dict_code=1 合格，dict_code=2 不合格

## Impact

### SQL 文件
- sql/tables/base_t_quality_trace.sql - 建表SQL
- sql/sequences/seq_t_quality_trace.sql - 序列
- sql/indexes/idx_t_quality_trace.sql - 索引
- sql/migrate/migrate_t_quality_trace.sql - 数据迁移
- sql/menu/menu_quality_trace.sql - 菜单配置
- sql/dict/dict_quality_trace.sql - 字典配置

### 后端文件
- controller/QualityTraceController.java
- service/QualityTraceService.java
- service/IQualityTraceService.java
- mapper/QualityTraceMapper.java
- mapper/xml/QualityTraceMapper.xml

### 前端文件
- api/quality/spot-testing.js
- views/quality/spot-testing/index.vue