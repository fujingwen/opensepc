## Why

`materials-product` 原提案把建材产品主表设计成了 `master.mat_product`，但后续数据库盘点已经确认：

- 正确业务主表应为 `master.t_project_product`
- 项目关联主表应为 `master.t_project`
- 企业主体应通过 `master.t_companyinfo` 解释生产企业、供应商、施工企业

如果继续沿用 `mat_product`，后续质量追溯、统计分析、价格分析都会建立在错误产品主链上，因此本提案需要原地修正。

## What Changes

- 将建材产品主表从 `mat_product` 修正为 `t_project_product`
- 将项目信息关联从 `mat_project` 修正为 `t_project`
- 明确企业相关字段需要通过 `t_companyinfo` 完成 ID 与名称映射
- 保持现有业务入口不变：
  - 页面入口 `materials/product/index`
  - 接口入口 `/materials/product`
- 明确旧 `mat_product` 方向 SQL 和模型不再作为继续开发依据

## Capabilities

### New Capabilities

- `materials_product`
  - 基于 `master.t_project_product` 提供建材产品查询、详情、维护、导出能力
  - 基于 `master.t_project` 提供项目名称、监督机构等关联信息
  - 基于 `master.t_companyinfo` 提供企业名称展示与选择支持

### Capability Details

- 查询条件
  - 施工单位名称
  - 工程名称
  - 产品类别
  - 产品名称
  - 产品规格
  - 生产单位名称
  - 采购数量范围
  - 进场时间范围
  - 填报时间范围
  - 信息确认状态
  - 信息确认超时
  - 信息确认不通过类别
  - 信息确认单位
  - 质量监督机构
  - 有无备案证号
- 列表字段
  - 施工单位名称
  - 工程名称
  - 产品类别
  - 产品名称
  - 产品规格
  - 工程进度
  - 采购数量
  - 产品价格
  - 进场时间
  - 填报时间
  - 生产企业
  - 供应商
  - 质量监督机构
  - 信息确认状态
- 关键约束
  - 底层主表必须为 `t_project_product`
  - 企业名展示不得直接写死历史名称字段，应通过企业主表或兼容映射获取

## Impact

- OpenSpec
  - `openspec/changes/materials-product/proposal.md`
  - `openspec/changes/materials-product/design.md`
  - `openspec/changes/materials-product/tasks.md`
  - `openspec/changes/materials-product/specs/materials_product/spec.md`
- SQL
  - 已存在的 `t_project_product` 相关迁移 SQL 继续有效
  - 旧 `mat_product` 方向 SQL 不再作为继续开发依据
- Backend
  - `MatProductController`
  - `IMatProductService`
  - `MatProductServiceImpl`
  - `MatProductMapper`
  - `MatProductMapper.xml`
  - `MatProduct` / `MatProductBo` / `MatProductVo`
- Frontend
  - `construction-material-web/src/views/materials/product/index.vue`
  - `construction-material-web/src/api/materials/product.js`
