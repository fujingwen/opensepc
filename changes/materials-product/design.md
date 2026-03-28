## Context

建材产品模块已经有前后端入口，但旧提案把主表定义成 `mat_product`。根据当前库表和迁移盘点，正确主线应为：

- 产品主表：`master.t_project_product`
- 项目主表：`master.t_project`
- 企业主表：`master.t_companyinfo`

本设计用于把 `materials-product` 变更原地纠偏。

## Goals / Non-Goals

**Goals**

- 明确建材产品主表为 `t_project_product`
- 明确项目关联主表为 `t_project`
- 明确企业名称展示和选择依赖 `t_companyinfo`
- 保持页面路由和接口路径不变

**Non-Goals**

- 本次不新建独立的产品回调变更目录
- 本次不直接实现质量追溯
- 本次不重做所有产品表单，只先纠正主数据方向

## Decisions

### 1. 主表改为 `t_project_product`

- `MatProduct` 实体和 mapper 应围绕 `t_project_product`
- 列表、详情、导出能力统一从 `t_project_product` 取数
- 删除、编辑等业务更新也应围绕 `t_project_product`

### 2. 项目关联改为 `t_project`

- `project_id -> t_project.id`
- 页面展示的工程名称、质量监督机构、施工单位等，应优先从 `t_project` 获取

### 3. 企业字段通过 `t_companyinfo` 解释

`t_project_product` 中大量是企业 ID 字段，例如：

- `manufacturer_id`
- `supplier_id`

因此页面中的：

- 生产单位名称
- 供应商名称
- 生产单位省市区

不能简单沿用 `mat_product` 的旧文本字段，需要通过 `t_companyinfo` 做 ID -> 名称/地区映射，或做兼容转换。

## Backend Design

- 控制器：`MatProductController`
- 服务：`IMatProductService` / `MatProductServiceImpl`
- Mapper：`MatProductMapper` / `MatProductMapper.xml`
- 实体模型：`MatProduct` / `MatProductBo` / `MatProductVo`

关键点：

- 查询主表改为 `t_project_product`
- 项目关联改为 `t_project`
- 企业名展示需要联表 `t_companyinfo`
- 主键类型应兼容 `t_project_product.id`

## Frontend Design

- 保留原查询区、列表、详情弹窗与导出入口
- 将“名称类”输入和“ID 类”底层字段分层处理
- 后续如要真正完成新增/编辑，需接入企业选择器而不是纯文本输入

## Risks / Trade-offs

1. 旧表单是“名称直填”，而 `t_project_product` 真实口径是“企业 ID”，直接硬切会写错数据。
2. 统计分析和采购价格分析也依赖 `t_project_product`，所以先纠偏主提案是必要前提。
3. 旧 `mat_product` SQL 和文档仍在仓库中，需要团队明确以本提案为准。
