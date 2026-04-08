# 行政区划管理

## Why

当前系统已经基于 `master.base_province` 落地了行政区划管理页面、地区选择组件和部分地区名称解析能力，但提案口径需要和当前实现继续对齐：

- 删除语义已经统一到 `del_flag`
- `type` 字段已按真实表结构使用字符串处理
- `RegionDialog` 已补齐编辑回显
- 地区名称填充能力已经接入真实业务链路
- 2026-04-08 起，行政区划查询接口不再只服务系统管理页面，也要兼容生产企业、施工企业、代理商等业务页面中的地区选择

## What Changes

- 行政区划删除语义统一为逻辑删除，删除时写入 `del_flag = 2`
- `master.base_province` 按真实表结构建模，`type` 按字符串处理
- `base_province` 补充数据修复与约束脚本，清理重复 `en_code` 并补齐必要索引
- `RegionDialog` 满足编辑回显与公共地区选择能力要求
- 地区名称填充能力下沉为共享工具，并接入真实业务查询链路
- `/system/region/list` 与 `/system/region/{id}` 采用共享权限口径

## Capabilities

### New Capabilities

- `system-region`: 行政区划管理页面与后端接口
- `common-region-dialog`: 支持懒加载、路径展示、确认取消、编辑回显的地区选择组件
- `region-name-fill`: 面向业务模块的地区名称解析与自动填充能力

### Clarifications

- `/system/region/list` 继续作为页面首屏和懒加载树节点的统一数据接口
- `/system/region/{id}` 继续作为行政区划详情与回显查询接口
- 查询接口权限采用共享模式：
- 系统管理角色通过 `system:region:list`、`system:region:query` 访问
- 生产企业、施工企业、代理商通过 `base:production:list`、`base:construction:list`、`base:agent:list` 访问
- 后端实现使用 `@SaCheckPermission(..., mode = SaMode.OR)`，避免为了查询地区数据而额外开放“行政区划管理”菜单
- `/system/region/treeselect` 当前阶段仍不是必需接口，先不落地

## Impact

- 后端：`BaseProvinceController` 查询接口权限从系统菜单专用权限调整为系统权限与企业业务权限共享
- 前端：已有地区下拉、级联、回显相关页面无需额外改造即可复用该接口
- 权限模型：企业角色不需要拿到“行政区划管理”菜单，也能正常获取地区数据
- 数据库：延续 `base_province` 的约束补齐、逻辑删除与字段对齐方案
