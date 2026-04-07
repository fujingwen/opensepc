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
- [x] 3.2 实现汇总卡片、审核指标、区市统计、类型趋势、滚动榜单查询
- [x] 3.3 实现拆分接口
  - `/materials/dashboard/summary`
  - `/materials/dashboard/rates`
  - `/materials/dashboard/regions`
  - `/materials/dashboard/types`
  - `/materials/dashboard/lists`
- [x] 3.4 优化 `regions` 聚合 SQL，解决区市统计超时问题
- [x] 3.5 删除废弃综合接口

## 4. 前端实现

- [x] 4.1 安装并接入 L7 依赖
- [x] 4.2 新建数据大屏 API，并删除废弃的 `overview` API 包装
- [x] 4.3 实现大屏页面布局、图表、3D 地图、悬浮弹窗与滚动榜单
- [x] 4.4 菜单点击时以独立页面打开大屏
- [x] 4.5 页面改为 `Promise.allSettled` 并行加载并支持模块级降级

## 5. 验证

- [x] 5.1 编译 `hny-materials`
- [x] 5.2 校验 OpenSpec
- [ ] 5.3 前端构建复核
  - 当前未执行；用户要求不要运行前端
