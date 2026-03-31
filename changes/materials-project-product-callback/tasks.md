## 1. OpenSpec 变更

- [x] 1.1 创建 `materials-project-product-callback` 变更目录
- [x] 1.2 编写 `proposal.md`
- [x] 1.3 编写 `design.md`
- [x] 1.4 编写三个 `spec` 文件
- [x] 1.5 编写 SQL 草案
- [x] 1.6 整合 `materials-project` 和 `materials-product` 提案（SQL、spec、issues 合并到本提案）
- [ ] 1.7 运行 `openspec validate materials-project-product-callback`

## 2. 第一阶段：工程项目回调

- [ ] 2.1 创建 `master.t_project`（SQL 已就绪）
- [ ] 2.2 执行 `test.t_project -> master.t_project` 数据迁移（SQL 已就绪）
- [x] 2.3 调整工程项目后端从 `mat_project` 切换到 `t_project`
  - 实体映射到 `t_project` ✓
  - Mapper 查询改到 `t_project` ✓
  - 兼容主键与逻辑删除字段 ✓
- [ ] 2.4 调整工程项目前端字段映射
- [x] 2.5 编译验证工程项目相关改动

## 3. 第一阶段：建材产品回调

- [ ] 3.1 创建 `master.t_project_product`（SQL 已就绪）
- [ ] 3.2 执行 `test.t_project_product -> master.t_project_product` 数据迁移（SQL 已就绪）
- [ ] 3.3 明确 `t_project_product` 字段与现有页面查询条件映射
- [ ] 3.4 调整建材产品后端从 `mat_product` 切换到 `t_project_product`
- [ ] 3.5 补充 `t_companyinfo` 企业名称映射（`manufacturer_id`、`supplier_id`）
- [ ] 3.6 调整建材产品前端字段映射
- [ ] 3.7 验证与 `t_project` 的关联查询
- [ ] 3.8 编译验证建材产品相关改动

## 4. 第二阶段：质量追溯准备

- [ ] 4.1 基于回调后的项目/产品主链路重新整理质量追溯四页设计
- [ ] 4.2 迁移 `test.t_quality_trace -> master.t_quality_trace`
- [ ] 4.3 实现抽测缺陷建材产品页
- [ ] 4.4 实现检测缺陷建材产品页
- [ ] 4.5 实现缺陷建材使用情况页
- [ ] 4.6 实现缺陷建材厂家页

## 5. 验证

- [ ] 5.1 运行 `openspec validate materials-project-product-callback`
- [ ] 5.2 编译验证材料模块
- [ ] 5.3 更新 `issues.md`
