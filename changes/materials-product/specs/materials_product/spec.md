# 建材产品规格

## ADDED Requirements

### Requirement: 建材产品主表统一为 `t_project_product`

系统 SHALL 使用 `master.t_project_product` 作为建材产品主承载表。

#### Scenario: 查询建材产品

- **Given** 用户进入建材产品页面
- **When** 系统执行建材产品列表查询
- **Then** 主数据来源应为 `master.t_project_product`

#### Scenario: 维护建材产品

- **Given** 用户拥有建材产品维护权限
- **When** 用户新增、编辑、删除或导出建材产品
- **Then** 系统应围绕 `master.t_project_product` 完成处理

### Requirement: 建材产品关联项目与企业主表

系统 SHALL 通过项目主表和企业主表补齐建材产品展示信息。

#### Scenario: 关联工程项目信息

- **Given** 建材产品存在项目 ID
- **When** 系统展示工程名称和质量监督机构
- **Then** 应通过 `master.t_project` 关联取得

#### Scenario: 关联企业名称

- **Given** 建材产品存在生产企业 ID 或供应商 ID
- **When** 系统展示企业名称和地区
- **Then** 应通过 `master.t_companyinfo` 解释对应名称与地区
