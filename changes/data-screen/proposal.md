# 数据大屏变更提案

## Why

当前仓库中的数据大屏已经稳定采用拆分接口加载，但提案和部分分析文档里仍残留旧的综合接口描述。继续保留这条已经废弃的接口定义，会带来三类问题：

- 文档与实现不一致
- 后端维护两套无必要的输出结构
- 前端 API 层出现无用导出，增加理解成本

因此本轮变更目标是彻底移除历史综合接口，让前后端与 OpenSpec 都只保留当前真实使用的拆分接口结构。

## What Changes

- 删除后端历史综合接口
- 删除后端历史总览 VO 与相关服务聚合方法
- 删除前端历史综合 API 包装
- 保留并继续使用以下拆分接口：
  - `GET /materials/dashboard/summary`
  - `GET /materials/dashboard/rates`
  - `GET /materials/dashboard/regions`
  - `GET /materials/dashboard/types`
  - `GET /materials/dashboard/lists`
- 同步更新 OpenSpec 提案、设计、规格、任务和问题记录

## Capabilities

### New Capabilities

- `data_screen`
  - 基于 `master.*` 运行库提供建材数据大屏
  - 采用拆分接口并行加载
  - 支持模块级失败降级

### Capability Details

#### 1. 汇总卡片与审核指标

- 页面入口
  - `数据大屏 / 建材数据大屏`
- 汇总卡片
  - 已填报项目总数 / 项目总数
  - 已填报建材产品总数
  - 备案产品总数
  - 施工企业数
  - 生产单位数
- 审核指标
  - 信息确认率
  - 审核通过率

#### 2. 区市地图与统计图表

- 地图
  - 使用 L7 渲染青岛区市边界
  - 显示各区市项目总数、参与项目总数、建材填报数
  - 支持 3D 挤出、悬浮弹窗和标签偏移
- 图表
  - 各区市建材产品填报数量
  - 各产品类别填报数量
  - 各产品类别每月提报数量

#### 3. 滚动榜单

- 最近项目填报审核
  - 项目名称
  - 填报材料
  - 备案证号
  - 审核状态
- 最新缺陷建材产品
  - 缺陷建材产品
  - 批号
  - 生产厂家
  - 使用项目

## Impact

- OpenSpec
  - `openspec/changes/data-screen/proposal.md`
  - `openspec/changes/data-screen/design.md`
  - `openspec/changes/data-screen/tasks.md`
  - `openspec/changes/data-screen/issues.md`
  - `openspec/changes/data-screen/specs/data_screen/spec.md`
- Backend
  - `construction-material-backend/hny-modules/hny-materials/src/main/java/com/hny/materials/controller/MatDashboardController.java`
  - `construction-material-backend/hny-modules/hny-materials/src/main/java/com/hny/materials/service/IMatDashboardService.java`
  - `construction-material-backend/hny-modules/hny-materials/src/main/java/com/hny/materials/service/impl/MatDashboardServiceImpl.java`
- Frontend
  - `construction-material-web/src/api/dashboard/materials.js`
  - `construction-material-web/src/views/dashboard/materials/index.vue`
