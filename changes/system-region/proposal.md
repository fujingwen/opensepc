# 行政区划管理

## Why

当前系统已经基于 `master.base_province` 落地行政区划页面、地区选择组件和部分地区名称解析能力，但实现与提案之间仍有几处关键口径分叉：

- 删除标记实际应统一走 `del_flag`，并使用 `0=正常、2=删除`
- `base_province` 缺少主键、唯一约束和必要索引，真实数据里已出现重复 `en_code`
- `type` 字段需要按真实表结构使用字符串
- `RegionDialog` 需要补齐编辑回显
- 地区名称自动填充能力需要真正接入业务，而不是只停留在工具类定义

本次修订的目标，是把提案、实现和数据库表设计统一到同一口径上。

## What Changes

- 行政区划删除语义统一为逻辑删除，删除时写入 `del_flag = 2`
- `master.base_province` 按真实表结构建模，`type` 按字符串处理
- 列表页接口权限保持 `system:region:list`，详情查询权限使用 `system:region:query`
- `RegionDialog` 补齐编辑回显，满足 `common_region_dialog` 规格
- 地区名称填充能力下沉为共享工具，并接入企业信息等真实业务查询链路
- 增加 `base_province` 的数据修复与约束脚本：
  - 清理 `en_code='110228001'` 的重复活动数据，仅保留 `id='110228001'`
  - 规范 `del_flag`
  - 补充主键与活动数据唯一索引

## Capabilities

### New Capabilities

- `system-region`: 行政区划管理页面与后端接口
- `common-region-dialog`: 支持树形懒加载、路径展示、确认取消、编辑回显的地区选择组件
- `region-name-fill`: 面向业务模块的地区名称批量解析与自动填充能力

### Clarifications

- `/system/region/list` 继续作为页面首屏和懒加载树节点的统一数据接口
- `/system/region/treeselect` 在当前阶段不是必需接口，先不落地
  - 当前页面和组件都基于 `/list + parentId` 已满足按需加载
  - 如果后续出现“需要一次性返回整棵树”或“树形选择器服务端搜索”的场景，再单独补 `treeselect`
- 行政区划搜索相关问题（默认根节点过滤、编码模糊查询）本次仅保留标记，不在这一轮修改

## Impact

- 后端：调整 `BaseProvince` 的逻辑删除、唯一性校验和字段映射
- 前端：补齐 `RegionDialog` 回显能力，页面表单校验与表结构保持一致
- 数据库：补充 `base_province` 数据修复脚本、主键和唯一索引
