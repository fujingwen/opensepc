## 1. OpenSpec 变更

- [x] 1.1 创建 `data-screen` 变更目录
- [x] 1.2 编写 `proposal.md`
- [x] 1.3 编写 `design.md`
- [x] 1.4 编写 `data_screen` 规格文件
- [x] 1.5 编写菜单、建表、迁移 SQL
- [x] 1.6 运行 `openspec validate data-screen`

## 2. 数据迁移

- [x] 2.1 创建 `master.t_project`
- [x] 2.2 执行 `test.t_project -> master.t_project`
- [x] 2.3 创建 `master.t_quality_trace`
- [x] 2.4 执行 `test.t_quality_trace -> master.t_quality_trace`

## 3. 后端实现

- [x] 3.1 创建 dashboard controller / service / mapper / vo
- [x] 3.2 实现汇总卡片、指标、榜单聚合
- [x] 3.3 实现区市地图与图表聚合查询
- [x] 3.4 完成权限注解与接口输出

## 4. 前端实现

- [x] 4.1 安装 L7 依赖
- [x] 4.2 新建数据大屏 API
- [x] 4.3 实现大屏页面布局、图表与滚动榜单
- [x] 4.4 使用本地青岛 GeoJSON 接入 L7 地图

## 5. 验证

- [x] 5.1 编译 `hny-materials`
- [x] 5.2 构建前端
- [x] 5.3 校验 OpenSpec
- [x] 5.4 回写任务状态与风险
