## 1. 提案修正

- [x] 1.1 将 `proposal.md` 从 `mat_product` 方向修正为 `t_project_product`
- [x] 1.2 将 `design.md` 从 `mat_product` 方向修正为 `t_project_product + t_project + t_companyinfo`
- [x] 1.3 更新 `spec.md` 说明主表与关联口径

## 2. SQL

- [ ] 2.1 继续以现有 `t_project_product` 迁移 SQL 为准
- [ ] 2.2 标记旧 `mat_product` SQL 不再作为实施依据
- [ ] 2.3 必要时补充企业关联说明 SQL/视图

## 3. 后端

- [ ] 3.1 将建材产品实体映射到 `t_project_product`
- [ ] 3.2 将产品列表关联从 `mat_project` 改为 `t_project`
- [ ] 3.3 补充 `t_companyinfo` 企业名称映射
- [ ] 3.4 验证导出字段与新口径一致

## 4. 前端

- [ ] 4.1 复核产品页字段映射
- [ ] 4.2 将企业相关输入改造为可兼容 ID/名称的选择方式
- [ ] 4.3 验证查询、详情、导出链路

## 5. 验证

- [ ] 5.1 运行 `openspec validate materials-product`
- [ ] 5.2 编译验证材料模块
