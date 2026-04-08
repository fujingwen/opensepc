# 建材产品问题记录

## 审查时间

- 2026-04-03

## 已完成事项

1. ~~建材产品 `/materials/product/list` 接口字段错误已修复。~~
2. ~~列表、查询条件、联动选择、表单布局、图片上传、状态流转等此前整理的问题已基本落地。~~
3. ~~未审核记录已放开为可在“待确认 / 不通过 / 待再次确认”状态下编辑、删除，不再只允许首轮“不通过”后修改。~~
4. ~~`recordNo` 已改为“有备案证号时必填”，无备案证号时允许按生产单位录入。~~
5. ~~“生产批号 / 生产日期至少填写一项”已补齐前后端校验。~~
6. ~~建材产品导出已补齐 2000 条上限控制。~~
7. ~~操作手册中与编辑删除、无备案证号录入、批号/生产日期校验、导出上限相关的既有差异已完成闭环。~~
8. ~~工程项目列表中的工程进度、施工单位、质量监督机构、有无填报、对接一体化平台编码已改为展示业务标签或关联名称，不再直出原始 ID。~~
9. ~~审核已改为复用查看弹窗，审核态字段全部禁用，右上角提供“审核通过 / 审核不通过”，不通过时再弹出原因填写弹窗。~~
10. ~~信息确认状态 hover 已改为按代理商/生产单位分组展示，并将不通过类别与原因挂在对应企业块下。~~
11. ~~备案证号缺失时已统一显示 `/`；有无备案证号字段 `0` 已按“无”展示。~~
12. ~~前端已兼容信息确认不通过类别同时解析 `sys_dict(shbtgyylb)` 与历史 `base_dictionarydata.id`。~~

## 未完成问题

1. 列表操作栏的“重置信息确认状态”按钮及对应后端重置逻辑尚未实现。
2. 规格与单位的数据模型仍未最终收口，当前基于 `master.sys_product.unit` 自动带出单位只是阶段性方案。
3. 供应商名称在部分场景应展示“无”的业务口径仍需继续核对录入、保存、导出链路是否完全一致。
4. `tasks.md` 尚未同步回写当前已完成项与遗留问题。
5. 历史数据中仍有少量记录同时缺失 `batch_no` 和 `batch_date`，需确认是否需要补治理。

## 已核对的数据事实

1. `master.t_project_product.check_status` 实际值分布为 `0/1/2/3/4`。
2. `master.t_project_product.has_record_no` 实际值分布为 `0/1/null`。
3. `master.t_project_product.record_no` 当前仍有 2920 条为空。
4. `master.t_project_product.batch_no` 与 `batch_date` 同时为空的历史记录有 2 条。
5. `master.t_project_product.supplier_check_status` 已存在且被历史数据使用。
6. `master.sys_dict_data` 中 `info_confirm_unit_type` 已存在。
7. 新库 `sys_dict_data` 中 `shbtgyylb` 曾漂移为 `info_confirm_fail_type`，已按旧库校正回 `shbtgyylb`。
8. 新库 `info_confirm_unit_type` 曾缺少明细数据，已按旧库补齐 `1=生产单位`、`2=监理单位`。
9. `master.t_project_product.check_first_fail_reason` 与 `supplier_check_first_fail_reason` 历史上存在直接保存 `base_dictionarydata.id` 的记录，例如 `305848955927790853=其他`。
