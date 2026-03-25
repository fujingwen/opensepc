-- 将test.t_project_product表迁移到master.mat_product表
-- 迁移规则参考: openspec/rules/database-rules.md
-- 关联关系参考: openspec/原型/数据库关联关系/1.备案产品和建材产品表.md

INSERT INTO "master"."mat_product" (
    "id",
    "tenant_id",
    "project_id",
    "construction_unit_name",
    "project_progress",
    "product_category",
    "product_name",
    "product_spec",
    "unit",
    "production_unit_name",
    "production_unit_address",
    "supplier_name",
    "production_batch_number",
    "production_date",
    "purchase_quantity",
    "purchase_price",
    "product_certificate",
    "factory_inspection_report",
    "performance_inspection_report",
    "product_photo",
    "entry_time",
    "agent_name",
    "certificate_number",
    "info_confirm_status",
    "del_flag",
    "create_time",
    "update_time",
    "create_by",
    "update_by"
)
SELECT
    CAST("F_Id" AS bigint) AS "id",
    '000000'::varchar(20) AS "tenant_id",
    CAST("F_ProjectId" AS bigint) AS "project_id",
    COALESCE("F_ProcuringEntity", '')::varchar(200) AS "construction_unit_name",
    COALESCE("F_ProjectProgress", '')::varchar(50) AS "project_progress",
    COALESCE("F_ProductType", '')::varchar(100) AS "product_category",
    COALESCE("F_ProductName", '')::varchar(200) AS "product_name",
    COALESCE("F_ProductStandard", '')::varchar(200) AS "product_spec",
    COALESCE("F_Unit", '')::varchar(20) AS "unit",
    COALESCE("F_ManufacturerId", '')::varchar(200) AS "production_unit_name",
    COALESCE("F_Address", '')::varchar(500) AS "production_unit_address",
    COALESCE("F_SupplierId", '')::varchar(200) AS "supplier_name",
    COALESCE("F_BatchNo", '')::varchar(100) AS "production_batch_number",
    NULL::date AS "production_date",
    COALESCE("F_Quantity", 0)::decimal(18,2) AS "purchase_quantity",
    COALESCE("F_UnitPrice", 0)::decimal(18,2) AS "purchase_price",
    COALESCE("F_Certificate", '')::varchar(500) AS "product_certificate",
    COALESCE("F_InspectionReport", '')::varchar(1000) AS "factory_inspection_report",
    COALESCE("F_PerformanceTestReport", '')::varchar(2000) AS "performance_inspection_report",
    COALESCE("F_PhysicalPhoto", '')::varchar(500) AS "product_photo",
    "F_ApproachTime"::date AS "entry_time",
    COALESCE("F_Seller", '')::varchar(200) AS "agent_name",
    COALESCE("F_RecordNo", '')::varchar(100) AS "certificate_number",
    CASE
        WHEN "F_CheckStatus" = 1 THEN '已通过'
        WHEN "F_CheckStatus" = 2 THEN '未通过'
        WHEN "F_CheckStatus" = 0 THEN '待审核'
        ELSE ''
    END::varchar(50) AS "info_confirm_status",
    CASE
        WHEN COALESCE("F_DeleteMark", 0) = 1 THEN '2'::char
        ELSE '0'::char
    END AS "del_flag",
    COALESCE("F_CreatorTime", NOW())::timestamp AS "create_time",
    COALESCE("F_LastModifyTime", NOW())::timestamp AS "update_time",
    COALESCE("F_CreatorUserId", '')::varchar(50) AS "create_by",
    COALESCE("F_LastModifyUserId", '')::varchar(50) AS "update_by"
FROM "test"."t_project_product";