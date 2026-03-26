# 抽测缺陷建材产品 - 详细设计

## 1. 数据库设计

### 1.1 字段映射分析

#### test.t_quality_trace 表字段

| 字段名 | 类型 | 说明 |
|--------|------|------|
| F_Id | varchar(50) | 主键 |
| F_OriginalId | varchar(50) | 原始ID |
| F_CheckOrganize | varchar(200) | 检测单位 |
| F_ProjectNo | varchar(200) | 工程编号 |
| F_ProjectName | varchar(500) | 工程名称 |
| F_ProductName | varchar(500) | 检验产品名称 |
| F_FactoryName | varchar(500) | 生产单位名称 |
| F_Batch | varchar(100) | 批号 |
| F_CheckProjectName | varchar(800) | 检测项目名称 |
| F_DataStatus | varchar(1) | 数据状态 |
| F_IsCollect | varchar(1) | 是否已采集 |
| F_ConclusionMark | varchar(50) | 结论标志 |
| F_Conclusion | varchar(500) | 结论 |
| F_ReportTime | timestamp | 报告日期 |
| F_CheckTime | timestamp | 检测时间 |
| F_EnabledMark | integer | 有效标志 |
| F_CreatorUserId | varchar(50) | 创建用户 |
| F_CreatorTime | timestamp | 创建时间 |
| F_LastModifyUserId | varchar(50) | 修改用户 |
| F_LastModifyTime | timestamp | 修改时间 |
| F_DeleteUserId | varchar(50) | 删除用户 |
| F_DeleteTime | timestamp | 删除时间 |
| F_DeleteMark | integer | 删除标志 |

#### 字段与页面元素对应关系

| 页面元素 | 数据库字段 | 说明 |
|----------|-----------|------|
| 产品名称 | F_ProductName | 检测产品名称 |
| 生产批号 | F_Batch | 批号 |
| 生产厂家 | F_FactoryName | 生产单位名称 |
| 检测项目 | F_CheckProjectName | 检测项目名称 |
| 检测日期 | F_CheckTime | 检测时间 |
| 有无对比数据 | 计算字段 | 根据 t_product_relation 表关联 |

#### 导入字段与数据库字段对应

| 导入字段 | 数据库字段 | 说明 |
|----------|-----------|------|
| 项目名称 | F_ProjectName | 工程名称 |
| 材料名称 | F_ProductName | 检验产品名称 |
| 生产批号 | F_Batch | 批号 |
| 生产厂家 | F_FactoryName | 生产单位名称 |
| 检测项目 | F_CheckProjectName | 检测项目名称 |
| 检测日期 | F_CheckTime | 检测时间 |
| 检测机构 | F_CheckOrganize | 检测单位 |
| 报告日期 | F_ReportTime | 报告日期 |
| 不合格参数 | F_Conclusion | 结论 |

### 1.2 迁移后 master.t_quality_trace 表结构

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

### 1.3 迁移前后字段对照表

| test 字段 (旧) | master 字段 (新) | 类型转换 |
|---------------|-----------------|----------|
| F_Id | id | 直接映射 |
| F_OriginalId | original_id | 直接映射 |
| F_CheckOrganize | check_organize | 直接映射 |
| F_ProjectNo | project_no | 直接映射 |
| F_ProjectName | project_name | 直接映射 |
| F_ProductName | product_name | 直接映射 |
| F_FactoryName | factory_name | 直接映射 |
| F_Batch | batch | 直接映射 |
| F_CheckProjectName | check_project_name | 直接映射 |
| F_DataStatus | data_status | 直接映射 |
| F_IsCollect | is_collect | 直接映射 |
| F_ConclusionMark | conclusion_mark | 直接映射 |
| F_Conclusion | conclusion | 直接映射 |
| F_ReportTime | report_time | 直接映射 |
| F_CheckTime | check_time | 直接映射 |
| F_EnabledMark | enabled_mark | 直接映射 |
| F_CreatorUserId | create_by | 重命名字段 |
| F_CreatorTime | create_time | 重命名字段 |
| F_LastModifyUserId | update_by | 重命名字段 |
| F_LastModifyTime | update_time | 重命名字段 |
| F_DeleteUserId | delete_by | 重命名字段 |
| F_DeleteTime | delete_time | 重命名字段 |
| F_DeleteMark | del_flag | 重命名字段，NULL转为0 |

## 2. 菜单设计

### 2.1 菜单结构

```
质量追溯 (zlzs)
├── 抽测缺陷建材产品 (spotTestingProduct)
├── 检测缺陷建材产品 (bhgcp)
├── 缺陷建材使用情况 (bhgcpsyqk)
└── 缺陷建材厂家 (bhgcj)
```

### 2.2 抽测缺陷建材产品菜单配置

- 菜单名称：抽测缺陷建材产品
- 路径：quality/spot-testing
- 组件：quality/spot-testing/index
- 权限编码：quality:spotTesting

## 3. 字典设计

### 3.1 有无对比数据

| dict_code | dict_label |
|-----------|------------|
| 1 | 有 |
| 2 | 无 |

### 3.2 结论

| dict_code | dict_label |
|-----------|------------|
| 1 | 合格 |
| 2 | 不合格 |

## 4. 接口设计

### 4.1 查询接口

GET /api/quality/spot-testing/list

请求参数：
- productName: 产品名称（模糊查询）
- batch: 生产批号（模糊查询）
- factoryName: 生产厂家（模糊查询）
- checkProject: 检测项目（模糊查询）
- beginCheckTime: 检测开始日期
- endCheckTime: 检测结束日期
- hasCheckData: 有无对比数据（1-有，2-无）
- pageNum: 页码
- pageSize: 每页条数

响应数据：
```json
{
  "rows": [
    {
      "id": "xxx",
      "projectName": "工程名称",
      "productName": "产品名称",
      "batch": "批号",
      "factoryName": "生产厂家",
      "checkProject": "检测项目",
      "checkTime": 1763136000000,
      "reportTime": 1763136000000,
      "conclusion": "结论",
      "hasCheckData": "有/无"
    }
  ],
  "total": 100
}
```

### 4.2 删除接口

DELETE /api/quality/spot-testing/{id}

### 4.3 导入接口

POST /api/quality/spot-testing/import

## 5. 前端设计

### 5.1 页面布局

- 查询区域：6个查询条件 + 查询按钮 + 重置按钮
- 表格区域：11列 + 操作列
- 导入按钮

### 5.2 组件交互

- 查询：触发列表刷新
- 删除：弹出确认框，确认后执行删除
- 导入：弹出导入对话框，解析Excel并上传