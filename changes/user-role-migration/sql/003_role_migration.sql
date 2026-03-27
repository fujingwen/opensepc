-- =============================================
-- 迁移提案：用户权限数据从Test模式迁移到Master模式
-- 步骤3：迁移角色（从base_userrelation提取Role -> sys_role）
-- =============================================

SET search_path TO master;

-- 1. 从base_userrelation中提取所有唯一的角色ID
-- 角色存储在 base_userrelation 中，F_ObjectType = 'Role'
-- 注意：只插入不存在的角色，避免覆盖已有数据

INSERT INTO sys_role (
    role_id, tenant_id, role_name, role_key, role_sort,
    data_scope, menu_check_strictly, dept_check_strictly,
    status, del_flag, create_dept, create_by, create_time,
    update_by, update_time, remark, create_name
)
SELECT
    (ABS(HASHTEXT(t.new_role_id)) % 100000000) + 1000 AS role_id,
    '000000' AS tenant_id,
    '角色_' || SUBSTRING(t.new_role_id FROM 1 FOR 8) AS role_name,
    'role_' || SUBSTRING(t.new_role_id FROM 1 FOR 8) AS role_key,
    0 AS role_sort,
    '1' AS data_scope,
    true AS menu_check_strictly,
    true AS dept_check_strictly,
    '0' AS status,
    '0' AS del_flag,
    '103' AS create_dept,
    '1' AS create_by,
    NOW() AS create_time,
    NULL AS update_by,
    NULL AS update_time,
    '从Test模式迁移' AS remark,
    '系统' AS create_name
FROM (
    SELECT DISTINCT "F_ObjectId" AS new_role_id
    FROM test.base_userrelation
    WHERE "F_ObjectType" = 'Role'
      AND "F_ObjectId" IS NOT NULL
      AND "F_ObjectId" != ''
) t
WHERE (ABS(HASHTEXT(t.new_role_id)) % 100000000) + 1000 NOT IN (
    SELECT role_id FROM sys_role WHERE role_id < 1000000000
);

-- 2. 验证迁移结果
SELECT '角色迁移完成' AS msg, COUNT(*) AS cnt FROM sys_role WHERE role_id >= 1000 AND role_id < 100000000;

-- 3. 查看迁移后的角色
SELECT role_id, role_name, role_key, role_sort, status
FROM sys_role
WHERE role_id >= 1000 AND role_id < 100000000
ORDER BY role_id;