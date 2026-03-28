## 当前记录

- 2026-03-28：工程项目后端已回调到 `t_project` 并通过 `mvn -pl hny-modules/hny-materials -am compile -DskipTests`。
- 2026-03-28：建材产品回调暂未直接落代码，原因是现有页面表单使用的是“企业名称/展示字段”，而 `t_project_product` 实际保存的是 `manufacturer_id`、`supplier_id` 等主键字段，若直接硬切会造成写入口径错误。

## 已确认风险

- 旧的 `materials-project`、`materials-product` 提案方向与当前主承载表不一致，后续实现必须以本变更为准。
- `master.t_project` 目前未落表，质量追溯使用情况页在此之前不能稳定开发。
- 建材产品模块在切回 `t_project_product` 前，需要先完成“企业 ID 与企业名称”的前后端选择器改造，至少要接通 `t_companyinfo` 的生产企业、供应商、施工企业口径。
