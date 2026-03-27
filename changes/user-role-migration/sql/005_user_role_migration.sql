-- =============================================
-- 迁移提案：用户权限数据从Test模式迁移到Master模式
-- 步骤5：迁移用户-角色关系（base_userrelation → sys_user_role）
-- =============================================

SET search_path TO master;

-- 1. 迁移用户-角色关系
-- base_userrelation 中 F_ObjectType = 'Role' 的记录

INSERT INTO sys_user_role (
    user_id, role_id
)
SELECT
    -- user_id: 映射到已迁移的sys_user的user_id
    (ABS(HASHTEXT(\"F_UserId\")) % 100000000) + 1000 AS user_id,
    -- role_id: 映射到已迁移的sys_role的role_id
    (ABS(HASHTEXT(\"F_ObjectId\")) % 100000000) + 1000 AS role_id
FROM test.base_userrelation
WHERE \"F_ObjectType\" = 'Role'
  AND \"F_UserId\" IS NOT NULL
  AND \"F_ObjectId\" IS NOT NULL;

-- 2. 验证迁移结果
SELECT '用户-角色关系迁移完成' AS msg, COUNT(*) AS cnt FROM sys_user_role;

-- 3. 查看迁移后的用户-角色关系
SELECT u.user_id, u.user_name, r.role_id, r.role_name
FROM sys_user_role ur
JOIN sys_user u ON ur.user_id = u.user_id
JOIN sys_role r ON ur.role_id = r.role_id
WHERE u.user_id >= 1000 AND r.role_id >= 1000
ORDER BY u.user_id, r.role_id
LIMIT 20;
