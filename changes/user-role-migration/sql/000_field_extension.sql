-- =============================================
-- 迁移提案：用户权限数据从Test模式迁移到Master模式
-- 步骤0：字段扩展（在迁移数据前执行）
-- =============================================
-- [需扩展] 说明：Test模式存在但Master模式不存在的字段，需要先在Master表中新增

SET search_path TO master;

-- 1. sys_user 表扩展字段
-- --------------------------------------------

-- [需扩展] 管理员标识：0-普通用户, 1-管理员
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS is_administrator INTEGER DEFAULT 0;

-- [需扩展] 原始用户ID (Test模式的主键，用于关联)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS original_id VARCHAR(50);

-- [需扩展] 组织ID (关联base_organize)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS organize_id VARCHAR(50);

-- [需扩展] 角色ID列表 (逗号分隔，兼容旧数据)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS role_ids TEXT;

-- [需扩展] 岗位ID列表 (逗号分隔)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS position_ids TEXT;

-- [需扩展] 生日
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS birthday TIMESTAMP;

-- [需扩展] 证件类型
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS certificates_type VARCHAR(50);

-- [需扩展] 证件号码
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS certificates_number VARCHAR(100);

-- [需扩展] 学历
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS education VARCHAR(50);

-- [需扩展] 入职日期
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS entry_date TIMESTAMP;

-- [需扩展] 座机
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS landline VARCHAR(50);

-- [需扩展] 紧急联系人
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS urgent_contacts VARCHAR(100);

-- [需扩展] 紧急联系电话
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS urgent_tele_phone VARCHAR(50);

-- [需扩展] 通讯地址
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS postal_address TEXT;

-- [需扩展] 签名
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS signature TEXT;

-- 2. sys_dept 表扩展字段
-- --------------------------------------------

-- [需扩展] 原始部门ID (Test模式的主键，用于关联)
ALTER TABLE sys_dept ADD COLUMN IF NOT EXISTS original_id VARCHAR(50);

-- [需扩展] 部门编码
ALTER TABLE sys_dept ADD COLUMN IF NOT EXISTS en_code VARCHAR(100);

-- [需扩展] 负责人ID
ALTER TABLE sys_dept ADD COLUMN IF NOT EXISTS manager_id VARCHAR(50);

-- 3. 验证扩展结果
-- --------------------------------------------
SELECT '字段扩展完成' AS msg;
SELECT column_name FROM information_schema.columns WHERE table_name = 'sys_user' AND column_name IN (
    'is_administrator', 'original_id', 'organize_id', 'role_ids', 'position_ids',
    'birthday', 'certificates_type', 'certificates_number', 'education', 'entry_date',
    'landline', 'urgent_contacts', 'urgent_tele_phone', 'postal_address', 'signature'
);
