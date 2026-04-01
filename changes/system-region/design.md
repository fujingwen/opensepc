## Context

本模块围绕 `master.base_province` 提供行政区划管理、地区选择组件和地区名称解析能力。当前代码已经可用，但需要按真实数据库表结构和现网数据情况做一次口径收敛。

技术栈：

- 后端：Java 17 / Spring Boot 3.2 / MyBatis-Plus
- 前端：Vue 3 / Element Plus
- 数据库：PostgreSQL

## Goals / Non-Goals

**Goals**

- 统一 `base_province` 的删除语义、字段类型和唯一性约束
- 保持行政区划页面当前懒加载模式不变
- 补齐 `RegionDialog` 的编辑回显
- 让地区名称自动填充能力真正接入业务服务

**Non-Goals**

- 不在本轮调整搜索语义
  - 默认只查根节点
  - `en_code` 模糊查询
- 不在本轮新增 `/system/region/treeselect`
- 不在本轮处理 `parent_id is null` 的根节点兼容问题

## Decisions

### 数据库字段口径

以 `master.base_province` 实表为准：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | `varchar(50)` | 主键 |
| `parent_id` | `varchar(50)` | 上级区划 ID |
| `en_code` | `varchar(50)` | 行政区划编码 |
| `full_name` | `varchar(50)` | 行政区划名称 |
| `quick_query` | `varchar(50)` | 快速查询码 |
| `type` | `varchar(50)` | 区划类型，按字符串建模 |
| `sort_code` | `bigint` | 排序 |
| `enabled_mark` | `integer` | 启用状态 |
| `delete_mark` | `integer` | 历史字段，不再作为删除标记使用 |
| `del_flag` | `smallint` | 统一删除标记，`0=正常`、`2=删除` |

### 删除语义

- 应用层统一使用 `del_flag`
- MyBatis-Plus 逻辑删除配置：`value = 0`，`delval = 2`
- 删除重复脏数据时，也遵循逻辑删除，不做物理删除

### 接口与权限

- `GET /system/region/list`
  - 用途：页面首屏、懒加载子节点、表单树选择
  - 权限：`system:region:list`
- `GET /system/region/{id}`
  - 用途：详情查询
  - 权限：`system:region:query`
- `POST /system/region`
  - 权限：`system:region:add`
- `PUT /system/region`
  - 权限：`system:region:edit`
- `DELETE /system/region/{ids}`
  - 权限：`system:region:remove`

### 为什么当前阶段不新增 `/treeselect`

当前页面和两个组件都基于如下模式工作：

1. 首屏调用 `/list` 获取根节点
2. 展开时带 `parentId` 再调用 `/list`
3. 表单树选择也按需加载

这意味着：

- 当前没有“必须返回整棵树”的强需求
- 新增 `/treeselect` 只会带来一套额外的接口维护成本
- 真正需要时，再新增一个“全量树”接口会更清晰

进一步方案：

- 保持现状：`/list` 继续承担懒加载数据接口
- 若后续出现以下任一场景，再补 `/treeselect`
  - 通用 `el-tree-select` 需要一次性回显整棵树
  - 树节点搜索需要服务端返回结构化树
  - 其他业务组件需要“非懒加载”的树快照

## Component Notes

### RegionDialog

`RegionDialog` 采用树形懒加载，规格要求包括：

- 左侧树展示
- 右侧已选路径
- 清空
- 取消 / 确定
- 编辑回显

本次实现补齐“编辑回显自动定位”，因此该组件可以视为符合 `common_region_dialog` 规格。

### RegionSelect

`RegionSelect` 当前仍是轻量级 `Popover` 三列直选方案，和 `common_region_picker` 里“Tab + 底部路径 + 显式确认”的交互仍有差异。本轮不改，继续保留标记。

### 地区名称填充

地区名称填充能力不再局限于 `hny-system` 模块内的孤立工具类，而是下沉为共享工具，并在企业信息查询链路中实际使用。

## Migration Plan

1. 规范 `del_flag`
2. 逻辑删除重复 `en_code='110228001'` 的三条脏数据，仅保留 `id='110228001'`
3. 为 `base_province.id` 增加主键
4. 为活动数据增加 `en_code` 唯一索引
5. 为树查询增加 `parent_id` 辅助索引

## Risks / Trade-offs

- 本轮不调整搜索语义，因此“默认根节点过滤”和“编码模糊查询”问题会继续保留
- 不新增 `/treeselect` 可以减少接口数量，但未来如有全量树需求，仍需要补接口
