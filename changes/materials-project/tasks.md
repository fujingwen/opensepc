## 1. 提案修正

- [x] 1.1 将 `proposal.md` 从 `mat_project` 方向修正为 `t_project`
- [x] 1.2 将 `design.md` 从 `mat_project` 方向修正为 `t_project`
- [x] 1.3 更新 `spec.md` 说明主表与迁移来源

## 2. SQL

- [ ] 2.1 补充 `master.t_project` 建表 SQL
- [ ] 2.2 补充 `test.t_project -> master.t_project` 迁移 SQL
- [ ] 2.3 标记旧 `mat_project` SQL 不再作为实施依据

## 3. 后端

- [x] 3.1 将工程项目实体映射到 `t_project`
- [x] 3.2 将工程项目 Mapper 查询改到 `t_project`
- [x] 3.3 兼容 `t_project` 主键与逻辑删除字段

## 4. 前端

- [ ] 4.1 复核工程项目页字段映射
- [ ] 4.2 验证详情、新增、编辑、删除链路

## 5. 验证

- [ ] 5.1 运行 `openspec validate materials-project`
- [ ] 5.2 编译验证材料模块
