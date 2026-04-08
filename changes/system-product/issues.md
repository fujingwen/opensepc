# 系统产品问题记录

## 审查时间

- 2026-04-03

## 已完成事项

1. ~~`del_flag` 逻辑删除值已统一到 `0=正常`、`2=删除`，不再出现默认写出 `1` 的实现分叉。~~
2. ~~右侧列表已补齐“按名称和状态查询”的状态筛选入口。~~
3. ~~`enCode` 已补齐前后端必填校验。~~
4. ~~多级分类新增时的 `categoryId` 继承逻辑与右侧子树查询已按 `tree_path` 收口。~~
5. ~~前端新增、编辑、删除等操作入口已补齐 `v-hasPermi`，权限显隐与后端权限口径对齐。~~

## 未完成问题

1. proposal/design/SQL/代码之间仍存在口径分叉：
   - `design.md` 仍写过独立 `/system/product/category` 接口
   - 文档中仍出现过 `system/product/index1`
   - 但当前代码、菜单 SQL 和数据库菜单组件路径都已收口为 `system/product/index`
2. 状态字典当前实际使用 `sys_region_status` 能工作，但文档没有把字典选择固定下来，后续仍有再次分叉风险。

## 数据库核对摘要

1. `master.sys_product` 当前共有 38476 条记录。
2. `del_flag` 分布为：`0 = 38470`、`2 = 6`。
3. 顶级分类（`node_type='category' and parent_id='0'`）当前只有 6 条，说明大量分类是多级结构。
4. `master.sys_menu` 当前产品菜单组件路径为 `system/product/index`。
