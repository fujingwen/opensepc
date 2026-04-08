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

### Requirement: 审核操作复用详情弹窗

系统 SHALL 复用建材产品详情弹窗完成审核，而不是维护独立审核表单页。

#### Scenario: 审核态复用查看弹窗

- **Given** 用户在建材产品列表中点击“审核”
- **When** 系统打开弹窗
- **Then** 系统应复用“查看”弹窗的字段布局
- **And** 所有表单字段应为只读或 disabled
- **And** 弹窗右上角应显示“审核通过”“审核不通过”按钮

#### Scenario: 审核不通过时填写原因

- **Given** 用户在审核弹窗中点击“审核不通过”
- **When** 系统收集不通过信息
- **Then** 系统应再打开次级弹窗选择不通过类别并填写不通过原因

### Requirement: 信息确认状态悬浮提示按企业分组展示

系统 SHALL 在信息确认状态 hover 内容中按代理商与生产单位分组展示企业信息与失败信息。

#### Scenario: 分组展示企业信息

- **Given** 建材产品存在代理商或生产单位确认信息
- **When** 用户 hover 信息确认状态
- **Then** tooltip 应按企业分组展示公司、联系人、电话
- **And** 公司、联系人、电话列应保持固定宽度、左对齐、超出换行

#### Scenario: 不通过信息挂在对应企业下方

- **Given** 代理商或生产单位存在不通过类别与原因
- **When** 用户 hover 信息确认状态
- **Then** 不通过类别与原因应展示在对应企业块下方
- **And** 企业信息与其失败信息之间不应再增加分隔线

### Requirement: 字典展示与历史值兼容

系统 SHALL 兼容当前字典值与历史业务值，避免表格和弹窗出现原始编码、空白或错误标签。

#### Scenario: 缺失备案证号展示兜底

- **Given** `record_no` 为空
- **When** 用户查看建材产品列表或详情
- **Then** 系统应展示 `/`

#### Scenario: 有无备案证号显示“无”

- **Given** `has_record_no = 0`
- **When** 用户查看建材产品列表
- **Then** 系统应按字典标签展示“无”

#### Scenario: 信息确认不通过类别兼容历史字典ID

- **Given** `check_first_fail_reason` 或供应商对应字段中保存的是历史 `base_dictionarydata.id`
- **When** 页面展示不通过类别
- **Then** 系统应同时兼容当前 `sys_dict(shbtgyylb)` 和历史 `base_dictionarydata.id`
- **And** 页面不得直接显示类似 `305848955927790853` 的原始值

#### Scenario: 信息确认单位字典可用

- **Given** 页面需要展示或选择信息确认单位
- **When** 系统加载 `info_confirm_unit_type`
- **Then** 新库必须提供可用字典明细
- **And** 至少包含“生产单位”“监理单位”
