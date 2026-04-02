## 新问题

1. **建材产品 `/materials/product/list` 接口报错：`column mp.construction_unit_name does not exist`**
   - **现象**：`MatProductMapper.xml` 的 `selectMatProductList` 查询引用了 `mp.construction_unit_name` 等大量在 `master.t_project_product` 表中不存在的列，导致 SQL 执行失败。
   - **根因**：后端代码（MatProduct.java、MatProductVo.java、MatProductBo.java、MatProductExcelVO.java、MatProductMapper.xml）是按照一套**不存在的表结构**编写的，与 `master.t_project_product` 实际列名完全脱节。
   - **影响范围**：所有建材产品接口（列表、详情、新增、编辑、删除、导出）均无法正常工作。
   - **修复方案**：以 `master.t_project_product` 实际表结构为准，重写后端 domain/bo/vo/mapper 全链路字段，不使用别名。

   **字段映射对照表（旧 Java 字段 → 实际 DB 列名）**：

   | Java 字段 | 旧 DB 列名（不存在） | 实际 DB 列名 | 说明 |
   |---|---|---|---|
   | `constructionUnitName` | `construction_unit_name` | 来自 `t_project.construction_unit` | 关联 t_project |
   | `productCategory` | `product_category` | `product_type` | |
   | `productSpec` | `product_spec` | `product_standard` | |
   | `productionUnitName` | `production_unit_name` | **无对应列** | DB 仅有 `manufacturer_id`，是 ID 不是名称 |
   | `productionUnitRegion` | `production_unit_region` | **无对应列** | |
   | `productionUnitAddress` | `production_unit_address` | `address` | |
   | `supplierName` | `supplier_name` | `seller` | |
   | `productionBatchNumber` | `production_batch_number` | `batch_no` | |
   | `productionDate` | `production_date` | `batch_date` | |
   | `purchaseQuantity` | `purchase_quantity` | `quantity` | 类型：DB 为 `double precision`，Java 为 `BigDecimal` |
   | `purchasePrice` | `purchase_price` | `unit_price` | 类型：DB 为 `double precision`，Java 为 `BigDecimal` |
   | `productCertificate` | `product_certificate` | `certificate` | |
   | `factoryInspectionReport` | `factory_inspection_report` | `inspection_report` | |
   | `performanceInspectionReport` | `performance_inspection_report` | `performance_test_report` | |
   | `productPhoto` | `product_photo` | `physical_photo` | |
   | `entryTime` | `entry_time` | `approach_time` | |
   | `agentName` | `agent_name` | **无对应列** | |
   | `supervisionRequest` | `supervision_request` | `is_pass_by_request` | 类型：DB 为 `integer`，Java 为 `String` |
   | `hasCertificateNumber` | `has_certificate_number` | `has_record_no` | 类型：DB 为 `integer`，Java 为 `String` |
   | `certificateNumber` | `certificate_number` | `record_no` | |
   | `infoConfirmStatus` | `info_confirm_status` | `check_status` | 类型：DB 为 `integer`，Java 为 `String` |
   | `infoConfirmTimeout` | `info_confirm_timeout` | `check_out_time` | 类型：DB 为 `integer`，Java 为 `String` |
   | `infoConfirmFailType` | `info_confirm_fail_type` | `check_first_fail_reason` | |
   | `infoConfirmUnit` | `info_confirm_unit` | `jl_unit` | |
   | `qualitySupervisionAgency` | `quality_supervision_agency` | 来自 `t_project.quality_supervision_agency` | 关联 t_project |

   **无对应列的 Java 字段**（`productionUnitName`、`productionUnitRegion`、`agentName`）：
   - DB 表中有 `manufacturer_id`、`supplier_id`，但存的是企业 ID，不是名称。需要确认是否对接 `t_companyinfo` 表做名称关联，或直接移除这些字段。

   **待改造文件清单**：
   - `MatProduct.java` — 实体字段重命名 + `@TableField` 注解
   - `MatProductVo.java` — VO 字段重命名
   - `MatProductBo.java` — BO 字段重命名 + 校验注解
   - `MatProductExcelVO.java` — 导出字段重命名
   - `MatProductMapper.xml` — SQL 列名全部改为实际 DB 列名，resultMap 同步更新
   - `MatProductServiceImpl.java` — `setInfoConfirmStatus("1")` 等硬编码值需适配新字段名
   - 前端 `product/index.vue` + `product.js` — 接口字段同步修改
