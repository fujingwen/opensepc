## 当前记录

- 2026-03-28：工程项目后端已回调到 `t_project` 并通过 `mvn -pl hny-modules/hny-materials -am compile -DskipTests`。
- 2026-03-28：建材产品回调暂未直接落代码，原因是现有页面表单使用的是"企业名称/展示字段"，而 `t_project_product` 实际保存的是 `manufacturer_id`、`supplier_id` 等主键字段，若直接硬切会造成写入口径错误。
- 2026-03-31：整合 `materials-project` 和 `materials-product` 提案到本变更，统一作为唯一工作依据。

## 已确认风险

- `master.t_project` 目前未落表，质量追溯使用情况页在此之前不能稳定开发。
- 建材产品模块在切回 `t_project_product` 前，需要先完成"企业 ID 与企业名称"的前后端选择器改造，至少要接通 `t_companyinfo` 的生产企业、供应商、施工企业口径。

## 历史问题（整合自 materials-product）

1. ~~产品规格字段缺失~~
   - **已解决**：已在数据库表、实体类、BO、VO 和前端页面中添加 `product_spec` 字段

2. ~~分页查询采用内存分页方式~~
   - **已解决**：当前数据量较小可接受，建议后续改为数据库层面分页

3. ~~导出功能编译错误，使用了不存在的 `exportExcel` 方法~~
   - **已解决**：添加 `ExcelUtil` 导入，修正方法调用参数

4. ~~`MatRecordVo` MapStruct 转换错误，缺少 `TenantEntity` 继承字段~~
   - **已解决**：在 VO 中添加 `createTime`、`updateTime`、`createBy`、`updateBy` 字段

5. ~~`MatProductMapper` MyBatis 查询条件字段错误，`purchaseQuantityMin` 等字段不在实体类中~~
   - **已解决**：在 `MatProduct` 实体类中添加查询条件字段并使用 `@TableField(exist = false)` 标注

6. ~~前端查询条件与设计文档不一致（字段和顺序都不同）~~
   - **已解决**：前端查询条件严格按照设计文档实现，共15项查询条件

7. ~~`mat_product` 表缺少 `tenant_id` 字段~~
   - **已解决**：创建迁移脚本添加 `tenant_id` 字段和索引
   - **注意**：此问题针对旧 `mat_product` 表，回调后应确保 `t_project_product` 表已包含 `tenant_id`

8. ~~前端列表展示字段、新增页面字段与设计文档不一致~~
   - **已解决**：按照设计文档顺序调整列表和新增页面字段，修正文件上传限制

## 待验证事项

- 权限控制验证（`materials:product:list`、`materials:product:query`、`materials:product:add` 等）
- 编辑删除操作限制（仅"待信息确认"状态可编辑删除）
- 字典数据正确配置（`info_confirm_status`、`info_confirm_timeout`、`info_confirm_fail_type`、`has_certificate_number`、`project_progress`）
