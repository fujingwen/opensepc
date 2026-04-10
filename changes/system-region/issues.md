# system-region 审查问题记录

## 审查时间

- 2026-04-03

## 已完成事项

1. ~~删除语义已统一为逻辑删除，删除标记统一使用 `del_flag`，并收口为 `0=正常`、`2=删除`。~~
2. ~~权限口径已统一为页面 `system:region:list`、详情 `system:region:query`。~~
3. ~~`RegionDialog` 编辑回显缺失问题已修复。~~
4. ~~`RegionNameFillUtil` 已接入业务查询链路，不再是孤立工具实现。~~
5. ~~代码字段类型已与实表保持一致，`type` 改为字符串。~~
6. ~~删除标记判断已统一以 `del_flag` 为准，`delete_mark` 仅保留为历史字段。~~

## 未完成问题

1. `parentId` 为空时仍默认只查 `parent_id='-1'`，搜索语义尚未放开。
2. `en_code` 搜索当前仍按精确匹配处理，未按模糊查询优化。
3. `/system/region/treeselect` 目前判断为非必需，但若后续出现整树回显或树搜索需求，仍需补充独立接口。
4. 历史 `parent_id is null` 根节点数据仍未治理，当前代码仍以 `parent_id='-1'` 作为根入口。
5. `RegionSelect` 与原型中的 `common_region_picker` 仍存在交互差异，本轮仅保留标记，尚未统一。
6. 金仓开发库 `master.base_province` 中仍存在 4 条活动态 `en_code='110228001'` 记录，且当前未查到 `uk_base_province_en_code_active` 等索引，说明重复数据清理与唯一索引脚本尚未真正落库。
