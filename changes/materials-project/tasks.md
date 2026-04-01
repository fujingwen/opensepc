## 1. OpenSpec 变更

- [x] 1.1 创建 `materials-project` 变更目录
- [x] 1.2 编写 `proposal.md`
- [x] 1.3 编写 `design.md`
- [x] 1.4 编写 `spec.md`
- [x] 1.5 编写 SQL 草案（建表、迁移、字典映射）
- [x] 1.6 从 `materials-project-product-callback` 拆分工程项目部分
- [ ] 1.7 运行 `openspec validate materials-project`

## 2. 数据层

- [ ] 2.1 创建 `master.t_project`（SQL 已就绪）
- [ ] 2.2 执行 `test.t_project → master.t_project` 数据迁移
- [ ] 2.3 执行字典值映射（F_Id → 短编码）

## 3. 后端

- [x] 3.1 调整 `MatProject` 实体映射到 `t_project`
- [x] 3.2 调整 `MatProjectMapper.xml` 查询改到 `t_project`
- [x] 3.3 兼容主键与逻辑删除字段
- [x] 3.4 新增 `GET /materials/project/sgxkzPage` 一体化编码分页接口
- [x] 3.5 新增 `POST /materials/project/export` 导出接口
- [x] 3.6 新增 `POST /materials/project/exportUnreported` 导出已开工未填报接口
- [ ] 3.7 施工单位字段改为下拉选择（数据源 `t_companyinfo`）
- [ ] 3.8 编译验证后端改动

## 4. 前端

- [x] 4.1 一体化工程编码下拉选择器（el-select filterable remote）
- [x] 4.2 打开新增 dialog 时立即加载一体化编码列表
- [x] 4.3 下拉选项展示 gc_code、工程名称、许可证号
- [x] 4.4 选中后自动填充施工许可证和对接状态
- [x] 4.5 添加提示文字"注：可使用施工许可证号或工程名称过滤"
- [x] 4.6 新增表单移除有无填报、对接状态字段
- [x] 4.7 施工许可证、发证日期改为非必填
- [x] 4.8 移除批量删除按钮和多选列
- [x] 4.9 新增导出和导出已开工未填报按钮
- [ ] 4.10 施工单位字段改为下拉选择（`t_companyinfo`）
- [ ] 4.11 验证前端完整功能

## 5. 验证

- [ ] 5.1 运行 `openspec validate materials-project`
- [ ] 5.2 编译验证材料模块
- [ ] 5.3 前端页面功能测试
- [ ] 5.4 更新 `issues.md`

我现在要申请公司3月份的月度之星，我申请的类别是AI先锋奖，有两个价值主张：1. AI 应用及创新：聚焦 AI 快速转型，打造新的商业模式，构筑更有竞争
  力的生产力、创新力、创用户最佳体验
2. AI 原生组织：实现自进化、自适应，打造可持续迭代的智能体生态

现在需要你帮我写一份“引爆的果及差异化路径描述”，五百字左右

我在三月份主要做了：研究openspec，落地项目，也就是当前项目，从一个纯前端到全栈开发，组内分享openspec的使用等。使用了Claude Code，Codex等工具。要求写的描述要详细，要展示出openspec在项目中的应用，要展示出openspec在项目中的优势，要展示出openspec在项目中的创新点；展示我对AI的应用
