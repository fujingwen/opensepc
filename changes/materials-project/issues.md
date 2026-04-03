## 新问题

1. 字典迁移：`test.base_dictionarytype`（F_IsTree=0）及关联的 `test.base_dictionarydata` 需迁移到 `master.sys_dict_type` 和 `master.sys_dict_data`，不删原有数据，编码冲突单独标记。
   - **独立提案**：`openspec/changes/dict-migration-test-to-master`，迁移脚本 `sql/migrate/migrate_dict.sql`
   - **已确认**：`gcjd`、`gcxz`、`gcjgxs`、`zljdjg` 对应字段在 `master.t_project` 中已为短编码
   - **待确认**：独立提案中包含"删除旧手动字典"的描述，与本条"不要把原有的数据删掉"存在口径差异
2. 前端字典选择器：工程进度、质量监督机构、工程性质、工程结构型式、审核不通过原因类别、单位、采购主体等字段需统一改为迁移后的字典选择器。
   - **已完成**：工程项目页面已切换；建材产品页面中 `质量监督机构` 和 `单位` 已切换
   - **未完成**：`信息确认单位` 当前存储的是监理单位名称，不是字典编码，暂不宜改为字典选择器；如需字典化需先补独立数据源和迁移方案
3. 有无填报逻辑：工程项目新增了建材产品即为"有填报"，与 `t_project_product.project_id` 关联。
   - **数据库现状**：`t_project_product` 关联 1219 个项目，`has_report='1'` 也是 1219 条；未关联产品项目绝大多数 `has_report='2'`
   - **遗留**：仍有 2 条 2026-04 测试数据 `has_report='0'`，代码和提案仍把"无/否"写成 `'0'`，需统一为数据库真实字典值
4. 新增功能：一体化工程编码下拉选择，数据源 `master.jck_t_gc_sgxkz`，通过 `F_SGXKZH` 关联。
    - **已完成**：后端分页接口、前端下拉远程搜索、自动填充联动
    - **已确认**：`master.jck_t_gc_sgxkz` 共 18,775 条，按许可证号非空统计有效 17,872 条
    - **新增发现**：当前后端分页 SQL 按 `gc_code` 非空过滤（18,453 条），与设计要求的许可证口径不一致

## 当前核查结论

- **仍需继续处理**：
  1. 为 `信息确认单位` 建立独立的主数据来源后，再决定是否字典化
  2. 继续核查一体化平台历史数据中 `is_integrated` 与许可证匹配不一致的存量记录

## 待验证事项

- 权限控制验证（`materials:product:list`、`materials:product:query`、`materials:product:add` 等）
- 编辑删除操作限制（仅"待信息确认"状态可编辑删除）
- 字典数据正确配置（`info_confirm_status`、`info_confirm_timeout`、`info_confirm_fail_type`、`has_certificate_number`、`project_progress`）
