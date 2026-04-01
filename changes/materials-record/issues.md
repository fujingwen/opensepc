## 2026-04-01 审查结论修订

### 已确认按当前设计走

#### 1. `manufacture_id` 作为生产企业唯一关联字段，`manufactur` 不再作为业务主字段

- 现阶段设计以 `t_record_product.manufacture_id -> t_companyinfo.id` 作为唯一可信关联。
- `manufactur` 视为历史遗留字段，不再作为新增、编辑、查询、回显、校验的主依据。
- 结论：这种设计是合理的，后续提案与实现统一按此口径验收。

#### 2. 备案证状态按有效期计算

- 备案证状态统一由有效期计算。
- 不再按 `enabled_mark` 充当备案证状态筛选条件。

#### 5. 字典统一使用 `certificate_status`

- 备案证状态相关字典统一按 `certificate_status` 处理。
- 不再按 `record_enabled_mark` 作为本提案验收口径。

#### 9. 历史脏数据先保留，不做处理

- 历史空值、异常时间等问题当前先不纳入本提案阻塞项。

### 待修复问题

#### 高优先级

#### 3. 导入按 `batch-import-dialog` 提案组件实现

- `materials-record` 导入能力应统一复用 `batch-import-dialog` 的组件能力和交互口径。
- 包括模板下载、上传、预览、编辑、删除、覆盖导入、导入结果返回。

#### 4. 备案证号需要严格限制“不可重复”

- 不能只依赖应用层校验。
- 需要补齐数据库层或等效强约束兜底，并覆盖新增、编辑、导入、并发写入场景。

#### 中优先级

#### 6. `send_flag` 先确认是否真正需要

- 先确认 `send_flag` 是否真的是正式业务字段。
- 在确认前，不把“未展示/未查询 `send_flag`”作为确定缺陷扩大实现。

#### 7. 分页需要优化

- 当前仍是先查全量、再内存分页。
- 该问题成立，需优化为数据库分页。

#### 8. 企业删除标记口径统一到 `del_flag`

- 原历史表用 `enabled_mark` 表达删除语义；现系统统一使用 `del_flag`。
- 后续处理口径：
  - 同步数据库，将历史删除语义映射到 `del_flag`
  - `del_flag = 0` 表示未删除
  - `del_flag = 2` 表示删除
  - 企业判断统一只用 `del_flag + company_type`

### 当前建议的实施顺序

1. 在 proposal/design/spec 中明确 `manufacture_id` 为主字段、`manufactur` 为历史遗留字段。
2. 将备案证状态统一改为按有效期计算，并统一使用 `certificate_status`。
3. 按 `batch-import-dialog` 统一导入实现。
4. 为 `record_no` 增加严格唯一性约束方案。
5. 优化列表分页为数据库分页。
6. 确认 `send_flag` 是否真的需要。
7. 梳理企业历史数据删除标记，将判断统一到 `del_flag + company_type`。
