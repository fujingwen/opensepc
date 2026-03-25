-- 数据迁移：从 test.t_record_product 迁移到 master.t_record_product
-- 执行前请确保 master.t_record_product 表已创建

-- 迁移数据（字段映射）
-- 注意：del_flag 统一设置为 0（表示未删除），避免 NULL 导致查询不到数据
INSERT INTO master.t_record_product (
    id,
    record_product_name,
    manufactur,
    record_no,
    begin_time,
    end_time,
    enabled_mark,
    create_time,
    create_by,
    update_time,
    update_by,
    del_flag,
    delete_time,
    delete_by,
    send_flag,
    social_credit_code,
    tenant_id,
    create_dept
)
SELECT
    "F_Id",
    "F_RecordProductName",
    "F_Manufactor",
    "F_RecordNo",
    "F_BeginTime",
    "F_EndTime",
    "F_EnabledMark",
    "F_CreatorTime",
    CAST("F_CreatorUserId" AS VARCHAR(50)),
    "F_LastModifyTime",
    CAST("F_LastModifyUserId" AS VARCHAR(50)),
    COALESCE("F_DeleteMark", 0) AS del_flag,  -- NULL 转换为 0
    "F_DeleteTime",
    "F_DeleteUserId",
    "F_SendFlag",
    "F_SocialCreditCode",
    '000000' AS tenant_id,
    '103' AS create_dept
FROM test.t_record_product
WHERE "F_DeleteMark" = 0 OR "F_DeleteMark" IS NULL;

-- 统计迁移结果
SELECT
    '迁移前 test.t_record_product 记录数' AS description,
    COUNT(*) AS count
FROM test.t_record_product;

SELECT
    '迁移后 master.t_record_product 记录数' AS description,
    COUNT(*) AS count
FROM master.t_record_product;

-- 验证 del_flag 是否正确
SELECT
    'del_flag 分布' AS description,
    del_flag,
    COUNT(*) AS count
FROM master.t_record_product
GROUP BY del_flag;

-- 修复 create_by 类型问题：将字符串转换为用户ID "1"
-- 注意：根据实际业务需求修改此值
UPDATE master.t_record_product SET create_by = '1' WHERE create_by IS NOT NULL AND create_by != '1';

-- 修复 update_by 类型问题
UPDATE master.t_record_product SET update_by = '1' WHERE update_by IS NOT NULL AND update_by != '1';
