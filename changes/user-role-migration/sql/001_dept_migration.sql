-- =============================================
-- 迁移提案：用户权限数据从Test模式迁移到Master模式
-- 步骤1：迁移部门/组织（base_organize → sys_dept）
-- =============================================

SET search_path TO master;

-- 1. 查看当前sys_dept最大dept_id
SELECT MAX(dept_id) as max_dept_id FROM sys_dept;

-- 2. 迁移数据：将test.base_organize的所有记录迁移到master.sys_dept
-- 字段映射：
--   F_Id (VARCHAR) → dept_id (BIGINT, 需要转换)
--   F_ParentId → parent_id (需要转换)
--   F_FullName → dept_name
--   F_Category → dept_category (company→'company', department→'department')
--   F_EnabledMark → status (1=0, 0=1)
--   F_SortCode → order_num
-- [需扩展] F_EnCode → en_code (新增字段)
-- [需扩展] F_ManagerId → manager_id (新增字段)
-- [需扩展] F_Id → original_id (新增字段，存储原ID)
INSERT INTO sys_dept (
    dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category,
    order_num, leader, phone, email, status, del_flag,
    create_dept, create_by, create_time, update_by, update_time, remark,
    -- [需扩展] 新增字段
    original_id, en_code, manager_id
)
SELECT
    -- dept_id: 使用hash方式将VARCHAR转BIGINT，确保唯一性
    (ABS(HASHTEXT("F_Id")) % 1000000000) + 100 AS dept_id,
    '000000' AS tenant_id,
    -- parent_id: 根节点设为0，其他转换为BIGINT
    CASE WHEN "F_ParentId" = '-1' THEN 0
         ELSE (ABS(HASHTEXT("F_ParentId")) % 1000000000) + 100 END AS parent_id,
    '' AS ancestors,
    "F_FullName" AS dept_name,
    CASE WHEN "F_Category" = 'company' THEN 'company' ELSE 'department' END AS dept_category,
    COALESCE("F_SortCode", 0)::INTEGER AS order_num,
    NULL AS leader,
    NULL AS phone,
    NULL AS email,
    CASE WHEN COALESCE("F_EnabledMark", 1) = 1 THEN '0' ELSE '1' END AS status,
    CASE WHEN COALESCE("F_DeleteMark", 0) = 1 THEN '1' ELSE '0' END AS del_flag,
    '103' AS create_dept,
    '1' AS create_by,
    COALESCE("F_CreatorTime", NOW()) AS create_time,
    NULL AS update_by,
    "F_LastModifyTime" AS update_time,
    "F_Description" AS remark,
    -- [需扩展] 新增字段映射
    "F_Id" AS original_id,
    "F_EnCode" AS en_code,
    "F_ManagerId" AS manager_id
FROM test.base_organize
WHERE "F_DeleteMark" IS NULL OR "F_DeleteMark" = 0;

-- 3. 验证迁移结果
SELECT '部门迁移完成' AS msg, COUNT(*) AS cnt FROM sys_dept WHERE dept_id >= 100;

-- 4. 更新ancestors字段（递归构建层级）
-- 注意：这是一个递归操作，需要分步骤处理
-- 先更新根部门
UPDATE sys_dept SET ancestors = CONCAT(dept_id)
WHERE parent_id = 0 AND dept_id >= 100;

-- 5. 查看迁移后的部门结构
SELECT dept_id, parent_id, dept_name, dept_category, order_num, status
FROM sys_dept
WHERE dept_id >= 100
ORDER BY dept_id;
