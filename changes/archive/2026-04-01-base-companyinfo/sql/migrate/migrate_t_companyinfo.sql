-- 数据迁移：从 test.t_companyinfo 迁移到 master.t_companyinfo
-- 执行前请确保 master.t_companyinfo 表已创建

-- 迁移数据（字段映射）
INSERT INTO master.t_companyinfo (
    id,
    company_name,
    area,
    address,
    contact_user,
    contact_phone,
    company_type,
    parent_id,
    enabled_mark,
    create_time,
    create_by,
    update_time,
    update_by,
    delete_time,
    delete_by,
    del_flag,
    send_flag,
    tenant_id,
    create_dept
)
SELECT
    "F_Id",
    "F_CompanyName",
    "F_Area",
    "F_Address",
    "F_ContactUser",
    "F_ContactPhone",
    "F_Type",
    "F_ParentId",
    "F_EnabledMark",
    "F_CreatorTime",
    "F_CreatorUserId",
    "F_LastModifyTime",
    "F_LastModifyUserId",
    "F_DeleteTime",
    "F_DeleteUserId",
    "F_DeleteMark",
    "F_SendFlag",
    '000000' AS tenant_id,
    '103' AS create_dept
FROM test.t_companyinfo;

-- 统计迁移结果
SELECT
    '迁移前 test.t_companyinfo 记录数' AS description,
    COUNT(*) AS count
FROM test.t_companyinfo;

SELECT
    '迁移后 master.t_companyinfo 记录数' AS description,
    COUNT(*) AS count
FROM master.t_companyinfo;

SELECT
    '按企业类型统计' AS description,
    company_type,
    CASE company_type
        WHEN 1 THEN '施工企业'
        WHEN 2 THEN '生产企业'
        WHEN 3 THEN '代理商'
        ELSE '未知'
    END AS type_name,
    COUNT(*) AS count
FROM master.t_companyinfo
GROUP BY company_type
ORDER BY company_type;
