-- =============================================
-- 迁移提案：用户权限数据从Test模式迁移到Master模式
-- 步骤2：迁移岗位（base_position → sys_post）- 修正版
-- =============================================

SET search_path TO master;

-- 1. 迁移数据：base_position → sys_post
-- 岗位使用sys_post表存储

INSERT INTO sys_post (
    post_id, tenant_id, dept_id, post_code, post_category, post_name,
    post_sort, status, create_dept, create_by, create_time,
    update_by, update_time, remark, create_name,
    -- 扩展字段
    original_id, organize_id
)
SELECT
    -- post_id: 使用200开头的大ID范围
    (ABS(HASHTEXT("F_Id")) % 100000000) + 200 AS post_id,
    '000000' AS tenant_id,
    -- dept_id: 映射组织ID到部门ID
    CASE WHEN "F_OrganizeId" IS NULL THEN NULL
         ELSE (ABS(HASHTEXT("F_OrganizeId")) % 1000000000) + 100 END AS dept_id,
    "F_EnCode" AS post_code,
    CASE WHEN "F_Type"::INTEGER = 1 THEN 'leader'
         WHEN "F_Type"::INTEGER = 2 THEN 'general'
         ELSE 'other' END AS post_category,
    "F_FullName" AS post_name,
    COALESCE("F_SortCode", 0)::INTEGER AS post_sort,
    CASE WHEN COALESCE("F_EnabledMark", 1) = 1 THEN '0' ELSE '1' END AS status,
    '103' AS create_dept,
    '1' AS create_by,
    COALESCE("F_CreatorTime", NOW()) AS create_time,
    NULL AS update_by,
    "F_LastModifyTime" AS update_time,
    "F_Description" AS remark,
    '系统' AS create_name,
    -- 扩展字段
    "F_Id" AS original_id,
    "F_OrganizeId" AS organize_id
FROM test.base_position
WHERE "F_DeleteMark" IS NULL OR "F_DeleteMark" = 0;

-- 2. 验证迁移结果
SELECT '岗位迁移完成' AS msg, COUNT(*) AS cnt FROM sys_post WHERE post_id >= 200;

-- 3. 查看迁移后的岗位
SELECT post_id, dept_id, post_name, post_code, post_category, status
FROM sys_post
WHERE post_id >= 200
ORDER BY post_id
LIMIT 20;