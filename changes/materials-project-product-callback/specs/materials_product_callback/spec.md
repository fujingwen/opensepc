# 建材产品回调规格

## ADDED Requirements

### Requirement: 建材产品主表统一到 `t_project_product`

系统 SHALL 使用 `master.t_project_product` 作为建材产品主承载表。

#### Scenario: 查询建材产品列表

- **Given** 用户进入建材产品页面
- **When** 系统执行建材产品分页查询
- **Then** 主表应为 `master.t_project_product`
- **Then** 项目信息应通过 `master.t_project` 关联取得

#### Scenario: 维护建材产品

- **Given** 用户拥有建材产品维护权限
- **When** 用户新增、编辑、删除或导出建材产品
- **Then** 系统应围绕 `master.t_project_product` 完成处理

### Requirement: 建材产品关联企业主表

系统 SHALL 通过企业主表 `t_companyinfo` 补齐建材产品的企业名称展示信息。

#### Scenario: 关联企业名称

- **Given** 建材产品存在生产企业 ID（`manufacturer_id`）或供应商 ID（`supplier_id`）
- **When** 系统展示企业名称和地区
- **Then** 应通过 `master.t_companyinfo` 解释对应名称与地区
- **Then** 不得直接使用旧文本字段硬编码企业名称

### Requirement: 保持原业务入口稳定

系统 SHALL 在回调主承载表时保留原有菜单路径与接口路径。

#### Scenario: 保留访问入口

- **Given** 现有前端菜单和接口调用已经使用 `/materials/product`
- **When** 完成建材产品主链路回调
- **Then** 调用方无需更换访问入口
- **Then** 仅底层 mapper、service 和字段映射发生变化
