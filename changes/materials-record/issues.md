# 备案产品问题记录

## 审查时间

- 2026-04-03

## 已确认口径

1. `manufacture_id` 作为生产企业唯一可信关联字段，`manufactur` 仅保留为历史遗留字段。
2. 备案证状态统一按有效期计算，不再按 `enabled_mark` 充当备案证状态。
3. 备案证状态相关字典统一按 `certificate_status` 处理，不再以 `record_enabled_mark` 作为验收口径。
4. 历史空值、异常时间等脏数据当前先不纳入本提案阻塞项。

## 已完成事项

1. ~~`record_no` 已补充数据库层唯一索引脚本 `sql/indexes/uk_t_record_product_record_no.sql`。~~
2. ~~列表分页当前已通过 `selectMatRecordPage(pageQuery.build(), entity)` 走数据库分页，不再是“先查全量再内存分页”。~~

## 未完成问题

1. 导入能力仍需按 `batch-import-dialog` 提案统一实现，包含模板下载、上传、预览、编辑、删除、覆盖导入和结果回传。
2. `send_flag` 是否为正式业务字段仍待确认，在确认前不宜把“未展示/未查询 `send_flag`”扩大为确定缺陷。
3. 企业删除口径尚未全链路统一到 `del_flag + company_type`。

## 建议实施顺序

1. 在 proposal/design/spec 中明确 `manufacture_id` 为主字段、`manufactur` 为历史遗留字段。
2. 按 `batch-import-dialog` 统一导入实现。
3. 确认 `send_flag` 是否真的需要。
4. 梳理企业历史数据删除标记，将判断统一到 `del_flag + company_type`。
