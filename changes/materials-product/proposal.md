## Why

在建材填报管理模块中，施工单位需要在工程项目下填报建材产品信息，包括产品基本信息、生产单位信息、供应商信息、采购信息及相关证明材料。当前系统缺少建材产品的管理功能，无法满足施工单位填报建材产品、生产单位/代理商审核的业务需求。

## What Changes

- 新增建材产品管理页面，支持建材产品的增删改查功能
- 新增建材产品列表查询功能，支持多条件组合查询（施工单位名称、工程名称、产品类别、产品名称、产品规格、生产单位名称、采购数量范围、进场时间范围、填报时间范围、信息确认状态、信息确认超时、信息确认不通过类别、信息确认单位、质量监督机构、有无备案证号）
- 新增建材产品新增功能，支持上传产品合格证、出厂检验报告、性能检验报告、实物照片等附件
- 新增建材产品编辑功能，仅信息确认状态为"待信息确认"时可编辑
- 新增建材产品删除功能，仅信息确认状态为"待信息确认"时可删除
- 新增建材产品详情查看功能
- 新增建材产品导出功能
- 新增建材产品审核功能（暂不实现，预留接口）
- 新增信息确认状态、信息确认超时、信息确认不通过类别、有无备案证号等字典数据
- 新增建材产品数据表 mat_product

## Capabilities

### New Capabilities

- `construction-material-product`: 建材产品管理功能，包括建材产品的增删改查、导出、审核等功能

### Modified Capabilities

无

## Impact

### 文件结构

**后端文件**

```
hny-modules/hny-materials/src/main/java/com/hny/materials/
├── controller/
│   └── MatProductController.java
├── service/
│   ├── IMatProductService.java
│   └── impl/MatProductServiceImpl.java
├── domain/
│   ├── MatProduct.java
│   ├── bo/MatProductBo.java
│   └── vo/MatProductVo.java
└── mapper/
    └── MatProductMapper.java

hny-modules/hny-materials/src/main/resources/mapper/
└── MatProductMapper.xml
```

**前端文件**

```
src/views/materials/product/
└── index.vue

src/api/materials/
└── product.js
```

### 数据库变更

**新增表：mat_product**

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| id | BIGINT | PRIMARY KEY | 主键ID |
| project_id | BIGINT | NOT NULL | 工程项目ID |
| construction_unit_name | VARCHAR(200) | NOT NULL | 施工单位名称 |
| project_progress | VARCHAR(50) | NOT NULL | 工程进度 |
| product_category | VARCHAR(100) | | 产品类别 |
| product_name | VARCHAR(200) | NOT NULL | 产品名称 |
| unit | VARCHAR(20) | | 单位 |
| production_unit_name | VARCHAR(200) | | 生产单位名称 |
| production_unit_region | VARCHAR(100) | | 生产单位省市区 |
| production_unit_address | VARCHAR(500) | | 生产单位详细地址 |
| supplier_name | VARCHAR(200) | | 供应商名称 |
| production_batch_number | VARCHAR(100) | | 生产批号 |
| production_date | DATE | | 生产日期 |
| purchase_quantity | DECIMAL(18,2) | NOT NULL | 采购数量 |
| purchase_price | DECIMAL(18,2) | | 采购单价 |
| product_certificate | VARCHAR(500) | | 产品合格证 |
| factory_inspection_report | VARCHAR(1000) | | 出厂检验报告 |
| performance_inspection_report | VARCHAR(2000) | | 性能检验报告 |
| product_photo | VARCHAR(500) | | 实物照片 |
| entry_time | DATE | | 进场时间 |
| agent_name | VARCHAR(200) | | 代理商名称 |
| supervision_request | VARCHAR(500) | | 监理申请 |
| has_certificate_number | VARCHAR(10) | | 有无备案证号 |
| certificate_number | VARCHAR(100) | | 备案证号 |
| info_confirm_status | VARCHAR(50) | | 信息确认状态 |
| info_confirm_timeout | VARCHAR(10) | | 信息确认超时 |
| info_confirm_fail_type | VARCHAR(50) | | 信息确认不通过类别 |
| info_confirm_unit | VARCHAR(200) | | 信息确认单位 |
| quality_supervision_agency | VARCHAR(200) | | 质量监督机构 |
| del_flag | CHAR(1) | DEFAULT '0' | 删除标志 |
| create_time | TIMESTAMP | NOT NULL | 创建时间 |
| update_time | TIMESTAMP | NOT NULL | 更新时间 |
| create_by | VARCHAR(50) | | 创建人 |
| update_by | VARCHAR(50) | | 更新人 |

### 字典数据

| 字典类型 | 字典名称 | 字典值 |
|---------|---------|-------|
| info_confirm_status | 信息确认状态 | 待信息确认、信息确认通过、信息确认不通过、待再次信息确认、信息确认再次不通过 |
| info_confirm_timeout | 信息确认超时 | 是、否 |
| info_confirm_fail_type | 信息确认不通过类别 | 资料不全（不符）、疑似假冒、采购数量不符、品牌填写错误、填报规格与实际供货规格不符、图片清晰度不够，无法辨识、其他 |
| has_certificate_number | 有无备案证号 | 有、无 |
| project_progress | 工程进度 | 工程安装阶段、测试1、测试2 |
