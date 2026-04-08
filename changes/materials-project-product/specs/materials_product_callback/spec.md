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

### Requirement: 建材产品审核链路必须按代理商和生产单位顺序执行

系统 SHALL 按是否存在代理商决定建材产品的信息确认顺序。

#### Scenario: 存在代理商时先由代理商确认

- **Given** 建材产品同时选择了生产单位和代理商
- **When** 用户提交新增或重提
- **Then** 系统必须先将记录送至代理商确认
- **And** 代理商确认通过后，生产单位才可继续确认
- **And** 仅当代理商和生产单位都确认通过后，建材产品状态才可变为“已确认”

#### Scenario: 不存在代理商时直接由生产单位确认

- **Given** 建材产品只选择了生产单位，未选择代理商
- **When** 用户提交新增或重提
- **Then** 系统必须直接将记录送至生产单位确认
- **And** 生产单位确认通过后，建材产品状态直接变为“已确认”

#### Scenario: 代理商必须隶属所选生产单位

- **Given** 用户在建材产品中同时提交 `manufacturer_id` 和 `supplier_id`
- **When** 后端执行新增或修改校验
- **Then** 系统必须校验该代理商隶属于当前生产单位
- **And** 若代理商不属于当前生产单位，接口必须拒绝保存
