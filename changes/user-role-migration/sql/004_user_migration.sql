-- =============================================
-- 迁移提案：用户权限数据从Test模式迁移到Master模式
-- 步骤4：迁移用户（base_user → sys_user）
-- =============================================

SET search_path TO master;

-- 1. 迁移用户数据
-- 注意：密码字段需要特殊处理，这里设置默认密码

-- [需扩展] F_IsAdministrator → is_administrator (新增字段)
-- [需扩展] F_Id → original_id (新增字段)
-- [需扩展] F_OrganizeId → organize_id (新增字段)
-- [需扩展] F_RoleId → role_ids (新增字段)
-- [需扩展] F_PositionId → position_ids (新增字段)
-- [需扩展] F_Birthday → birthday (新增字段)
-- [需扩展] F_CertificatesType → certificates_type (新增字段)
-- [需扩展] F_CertificatesNumber → certificates_number (新增字段)
-- [需扩展] F_Education → education (新增字段)
-- [需扩展] F_EntryDate → entry_date (新增字段)
-- [需扩展] F_Landline → landline (新增字段)
-- [需扩展] F_UrgentContacts → urgent_contacts (新增字段)
-- [需扩展] F_UrgentTelePhone → urgent_tele_phone (新增字段)
-- [需扩展] F_PostalAddress → postal_address (新增字段)
-- [需扩展] F_Signature → signature (新增字段)

INSERT INTO sys_user (
    user_id, tenant_id, dept_id, user_name, nick_name, user_type,
    email, phonenumber, sex, avatar, password, status, del_flag,
    login_ip, login_date, create_dept, create_by, create_time,
    update_by, update_time, remark, create_name, pw_update_date,
    -- [需扩展] 新增字段
    is_administrator, original_id, organize_id, role_ids, position_ids,
    birthday, certificates_type, certificates_number, education, entry_date,
    landline, urgent_contacts, urgent_tele_phone, postal_address, signature
)
SELECT
    -- user_id: 使用hash方式转换，避免与现有ID冲突
    (ABS(HASHTEXT("F_Id")) % 100000000) + 1000 AS user_id,
    '000000' AS tenant_id,
    -- dept_id: 映射组织ID到部门ID
    CASE WHEN "F_OrganizeId" IS NULL OR "F_OrganizeId" = '' THEN NULL
         ELSE (ABS(HASHTEXT("F_OrganizeId")) % 1000000000) + 100 END AS dept_id,
    SUBSTRING("F_Account", 1, 30) AS user_name,
    SUBSTRING(COALESCE("F_NickName", "F_RealName"), 1, 30) AS nick_name,
    'sys_user' AS user_type,
    "F_Email" AS email,
    SUBSTRING("F_MobilePhone", 1, 11) AS phonenumber,
    CASE WHEN "F_Gender" = 1 THEN '1'  -- 男
         WHEN "F_Gender" = 2 THEN '2'  -- 女
         ELSE '0' END AS sex,  -- 未知
    NULL AS avatar,
    -- 密码：使用BCrypt加密的默认密码 (123456)
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH' AS password,  -- Hny@2022
    CASE WHEN COALESCE("F_EnabledMark", 1) = 1 THEN '0' ELSE '1' END AS status,
    CASE WHEN COALESCE("F_DeleteMark", 0) = 1 THEN '1' ELSE '0' END AS del_flag,
    "F_LastLogIP" AS login_ip,
    "F_LastLogTime" AS login_date,
    '103' AS create_dept,
    '1' AS create_by,
    COALESCE("F_CreatorTime", NOW()) AS create_time,
    NULL AS update_by,
    "F_LastModifyTime" AS update_time,
    "F_Description" AS remark,
    "F_RealName" AS create_name,
    "F_ChangePasswordDate" AS pw_update_date,
    -- [需扩展] 新增字段映射
    COALESCE("F_IsAdministrator", 0) AS is_administrator,
    "F_Id" AS original_id,
    "F_OrganizeId" AS organize_id,
    "F_RoleId" AS role_ids,
    "F_PositionId" AS position_ids,
    "F_Birthday" AS birthday,
    "F_CertificatesType" AS certificates_type,
    "F_CertificatesNumber" AS certificates_number,
    "F_Education" AS education,
    "F_EntryDate" AS entry_date,
    "F_Landline" AS landline,
    "F_UrgentContacts" AS urgent_contacts,
    "F_UrgentTelePhone" AS urgent_tele_phone,
    "F_PostalAddress" AS postal_address,
    "F_Signature" AS signature
FROM test.base_user
WHERE "F_DeleteMark" IS NULL OR "F_DeleteMark" = 0;

-- 2. 验证迁移结果
SELECT '用户迁移完成' AS msg, COUNT(*) AS cnt FROM sys_user WHERE user_id >= 1000;

-- 3. 查看迁移后的用户
SELECT user_id, dept_id, user_name, nick_name, phonenumber, status, is_administrator
FROM sys_user
WHERE user_id >= 1000
ORDER BY user_id
LIMIT 20;
