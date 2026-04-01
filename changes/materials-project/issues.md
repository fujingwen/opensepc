## 当前记录

- 2026-03-28：工程项目后端已回调到 `t_project` 并通过 `mvn -pl hny-modules/hny-materials -am compile -DskipTests`。
- 2026-03-28：建材产品回调暂未直接落代码，原因是现有页面表单使用的是"企业名称/展示字段"，而 `t_project_product` 实际保存的是 `manufacturer_id`、`supplier_id` 等主键字段，若直接硬切会造成写入口径错误。
- 2026-03-31：整合 `materials-project` 和 `materials-product` 提案到本变更，统一作为唯一工作依据。

## 已确认风险

- `master.t_project` 目前未落表，质量追溯使用情况页在此之前不能稳定开发。
- 建材产品模块在切回 `t_project_product` 前，需要先完成"企业 ID 与企业名称"的前后端选择器改造，至少要接通 `t_companyinfo` 的生产企业、供应商、施工企业口径。

## 历史问题（整合自 materials-product）

1. ~~产品规格字段缺失~~
   - **已解决**：已在数据库表、实体类、BO、VO 和前端页面中添加 `product_spec` 字段

2. ~~分页查询采用内存分页方式~~
   - **已解决**：当前数据量较小可接受，建议后续改为数据库层面分页

3. ~~导出功能编译错误，使用了不存在的 `exportExcel` 方法~~
   - **已解决**：添加 `ExcelUtil` 导入，修正方法调用参数

4. ~~`MatRecordVo` MapStruct 转换错误，缺少 `TenantEntity` 继承字段~~
   - **已解决**：在 VO 中添加 `createTime`、`updateTime`、`createBy`、`updateBy` 字段

5. ~~`MatProductMapper` MyBatis 查询条件字段错误，`purchaseQuantityMin` 等字段不在实体类中~~
   - **已解决**：在 `MatProduct` 实体类中添加查询条件字段并使用 `@TableField(exist = false)` 标注

6. ~~前端查询条件与设计文档不一致（字段和顺序都不同）~~
   - **已解决**：前端查询条件严格按照设计文档实现，共15项查询条件

7. ~~`t_project_product` 表租户字段核对~~
   - **已解决**：已补充迁移核对脚本，当前实现应以 `t_project_product` 为准并确保包含 `tenant_id`

8. ~~前端列表展示字段、新增页面字段与设计文档不一致~~
   - **已解决**：按照设计文档顺序调整列表和新增页面字段，修正文件上传限制

## 新问题

1. 在工程项目页面，工程进度是字典，之前在master.sys_dict_type中配置了`project_progress`字典，但是这个是不正确的，我需要用test.base_dictionarytype中的字典，也就是需要将test.base_dictionarytype和test.base_dictionarydata这两个表的数据迁移到master.sys_dict_type和master.sys_dict_data这两个表中。迁移规则是：test.base_dictionarytype表中F_IsTree字段为0的记录，以及对应test.base_dictionarydata表中的数据，迁移到master.sys_dict_type和master.sys_dict_data这两个表中。调用.trae\skills\database-config-manager\SKILL.md技能连接数据库，先写一个单独的提案，然后执行迁移，注意不要把原有的数据删掉。提案规则是：.trae\skills\openspec-new-change\SKILL.md技能
   1. 注意dict data不是全部迁移，而是关联了被迁移的dict type的，才迁移
   2. test.base_dictionarytype和test.base_dictionarydata这两个表的数据迁移到master.sys_dict_type和master.sys_dict_data这两个表
   3. 注意检查是否有编码冲突，如果有，则单独标记出来，不进行迁移。
   - **当前状态：部分解决 / 待数据库验证**
   - **已完成**：已存在独立提案 `openspec/changes/dict-migration-test-to-master`，并编写迁移脚本 `sql/migrate/migrate_dict.sql`
   - **未确认**：尚未在本次核查中直连数据库确认脚本已执行、冲突是否已标记、目标库数据是否已实际生效
   - **注意**：独立提案中包含“删除旧手动字典”的描述，与本条“不要把原有的数据删掉”存在口径差异，需要再确认
2. 前端页面涉及到“工程进度、质量监督机构、工程性质、工程结构型式、审核不通过原因类别、单位、采购主体”等字典的，查询、列表、新增等地方，需要改为迁移后的字典。这里边有一些用的是旧的字典，有的是用input代替的，都需要修改为字典选择器。
   - **当前状态：未解决**
   - **已完成**：工程项目页面已切换为 `gcjd`、`gcxz`、`gcjgxs`、`zljdjg` 等字典选择器
   - **未完成**：建材产品页面仍存在 `单位`、`质量监督机构`、`信息确认单位` 等 `input` 字段，未统一改为迁移后的字典选择器
3. 工程项目页面中，查询列表，返回的字段，帮我和master.t_project中的字段对一下，以数据表的字段为准，修改前后端代码，确保一致。
   - **当前状态：已解决**
   - **核查结果**：`master.t_project` 建表 SQL、迁移 SQL、后端实体/VO/Mapper、前端工程项目页面字段已经基本对齐，当前查询与详情接口均基于 `t_project`
4. 数据库：create_by、update_by的值应该是1而不是admin，需要将所有数据库master.t_project表中create_by、update_by的admin都改为1
   - **当前状态：部分解决 / 待数据库验证**
   - **已完成**：`openspec/changes/materials-project/sql/migrate/migrate_dict_values_in_t_project.sql` 中已添加 `admin -> 1` 的更新 SQL
   - **未确认**：尚未在本次核查中直连数据库确认该 SQL 已执行完毕
5. ~~对比master.t_project表中的字段的含义，和前后端是否能匹配？~~
   - **已解决**：后端实体、VO、Mapper XML 字段与数据库 23 列完全一致；前端已修正质量监督机构（表单改 el-select + zljdjg 字典，详情改 dict-tag）
   - **关键发现**：数据库中 `project_nature`、`project_progress`、`structure_type`、`quality_supervision_agency` 存储的是旧字典系统的 `F_Id`（长数字ID），需要映射为新字典的短编码。映射方案已记录在 spec.md。
6. 前端，table表格展示的字段不全，全部字段分别为：工程名称,施工许可证,工程进度,工程地址,施工单位,施工单位负责人,施工单位负责人联系方式,质量监督机构,有无填报,对接一体化平台编码,创建时间。帮我补全前端，并确认接口是否返回了全部字段，如果没有则后端需要添加。
   - **当前状态：已解决**
   - **核查结果**：工程项目前端列表字段已补齐，后端分页/详情 VO 也已返回对应字段
7. 查询条件，施工单位名称，查询没有任何返回
   - **当前状态：已解决**
   - **核查结果**：工程项目分页查询已支持 `t_project.construction_unit` 与 `t_companyinfo.company_name` 双条件匹配
8. 有无填报的逻辑：如果该工程项目新增了建材产品，则表示有填报；否则就是无填报。这就与t_project_product表的project_id字段相关。
   - **当前状态：未解决**
   - **现状**：当前工程项目新增时仅默认 `has_report = '0'`，导出已开工未填报也只是按 `has_report = '0'` 过滤
   - **缺口**：尚未实现通过 `t_project_product.project_id` 实时反推 `has_report`
9. 对接一体化平台编码的逻辑：在新增时，如果选择了一体化工程编码，则对接一体化平台编码字段就是“是”
   - **当前状态：已解决**
   - **核查结果**：前端选择一体化工程编码后会自动填充施工许可证并设置 `isIntegrated = '1'`，后端保存时也有兜底逻辑
10. 先修改新增功能：新增时，第一个字段为”一体化工程编码”，下拉选择，不是必填，数据来源是test.jck_t_gc_sgxkz，需要先迁移到master，再去关联，通过F_SGXKZH字段关联一体化工程编码表。
    - **规格已定义**：详见 spec.md「一体化工程编码下拉选择」章节
    - **实现步骤**：(1) 迁移 jck_t_gc_sgxkz test→master (2) 后端新增查询接口 (3) 前端 el-select 远程搜索 (4) 选中后自动填充 construction_permit 和 is_integrated

- **当前状态：部分解决 / 待数据库验证**
- **已完成**：后端分页接口、前端下拉远程搜索、自动填充联动已实现
- **未确认**：本次核查未见到该表 test→master 的迁移执行结果，当前仅能确认代码基于 `master.jck_t_gc_sgxkz` 工作

11. 新增时，前端，一体化工程编码字段不是下拉选择，而是input，应该是下拉；

- **当前状态：已解决**

12. 打开新增dialog时，立即请求接口分页加载一体化列表，而不是搜索之后才加载列表；下拉的每一行需要展示三个字段（gc_code、工程名称sgxkz_gcmc、许可证号sgxkz_zh），可使用施工许可证号或工程名称过滤；选择之后在下方展示工程名称、施工许可证、地址sgxkz_jsdz、所属施工单位sgxkz_sgdw这四个字段。

- **当前状态：已解决**

13. ~~一体化工程编码下拉样式、分页、选择后详情展示~~

- **已解决**：
  - 下拉选项样式：gc_code 20% 宽度 rgb(132,146,166) 灰色，工程名称 40% 默认色，许可证号 40% 灰色
  - 分页：每页 10 条，底部”加载更多”按钮追加加载
  - 选择后展示 4 个字段（工程名称、施工许可证、地址、所属施工单位），未选择时隐藏
  - 后端 mapper 新增返回 gc_code（gcCode）和 sgxkz_jsdz（address）字段

14. ~~一体化工程编码分页组件改造~~
    - **已解决**：将”加载更多”改为分页组件方式（页码、上下页、总数），字段映射已确认正确，选择后4个详情字段展示已验证
2. ~~分隔行~~
    - **已解决**：新增”数字住建一体化平台信息”和”建材平台信息”两个 el-divider 分隔行
3. ~~一体化工程编码注释~~
    - **已解决**：在 select 下方添加”注：可使用施工许可证号或工程名称过滤”注释
4. ~~非必填字段调整~~
    - **已解决**：施工许可证、施工许可证发证日期改为非必填；移除 hasReport 和 isIntegrated 的必填校验
5. ~~新增时，施工单位是openspec\changes\base-companyinfo提案下的施工单位，新增时不要disabled，要可以选择，是下拉~~
    - **已解决**：施工单位改为 el-select filterable 下拉，数据源 `GET /base/companyinfo/construction/options`（company_type=1），打开 dialog 时加载选项列表，占满整行（span=24）
6. ~~有无填报和是否对接一体化平台编码字段新增时不需要~~

- **已解决**：移除 hasReport 和 isIntegrated 的表单验证规则

20. 操作按钮中，不需要”批量删除”按钮和列表的批量选择，增加”导出”和”导出已开工未填报项目表”这两个按钮。导出已开工未填报项目表指的是工程进度中除了施工前准备阶段和土方开挖及基坑支护阶段的其他阶段。导出的表名称叫”工程信息管理”，表字段是：工程名称、施工许可证、工程进度、工程地址、施工单位、施工单位现场负责人、施工单位现场负责人联系方式、质量监督机构、填报状态

- **当前状态：已解决**

## 当前核查结论

- **工程项目页面前后端功能**：大部分已完成，尤其是 `t_project` 回调、一体化工程编码下拉、列表字段、查询条件、导出按钮等
- **数据库执行结果**：字典迁移、`create_by/update_by` 修正、`jck_t_gc_sgxkz` 迁移仍缺少本次核查中的真实数据库执行确认
- **仍需继续处理**：
  1. 将 `has_report` 改为基于 `t_project_product.project_id` 的真实联动逻辑
  2. 将建材产品页面中仍为 `input` 的字典字段改为迁移后的字典选择器
  3. 复核并统一“字典迁移是否允许删除旧手动字典”的提案口径

## 待验证事项

- 权限控制验证（`materials:product:list`、`materials:product:query`、`materials:product:add` 等）
- 编辑删除操作限制（仅"待信息确认"状态可编辑删除）
- 字典数据正确配置（`info_confirm_status`、`info_confirm_timeout`、`info_confirm_fail_type`、`has_certificate_number`、`project_progress`）
