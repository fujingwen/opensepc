-- 继续插入剩余的角色数据 - 使用HASHTEXT转换ID
SET search_path TO master;

-- 公司业务人员 -> 9126c0cbbb954b84a856cc6f97617925
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260000 + (ABS(HASHTEXT('9126c0cbbb954b84a856cc6f97617925')) % 1000000), '000000', '公司业务人员', 'BusinessPersonnel', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 公司中层领导 -> 7195905c25cb42db9f4f419c36b2ff77
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260001 + (ABS(HASHTEXT('7195905c25cb42db9f4f419c36b2ff77')) % 1000000), '000000', '公司中层领导', 'CentreLeader', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 公司高层领导 -> 347307624a3b423b81d5cd5433a11b5d
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260002 + (ABS(HASHTEXT('347307624a3b423b81d5cd5433a11b5d')) % 1000000), '000000', '公司高层领导', 'HeightLeader', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 总经理助理 -> 7fabd37b625b44fa87c027ee85ebde6c
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260003 + (ABS(HASHTEXT('7fabd37b625b44fa87c027ee85ebde6c')) % 1000000), '000000', '总经理助理', 'GeneralAssistant', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 公司技术人员 -> 1d59f0e85c8e411b8e83e75075778035
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260004 + (ABS(HASHTEXT('1d59f0e85c8e411b8e83e75075778035')) % 1000000), '000000', '公司技术人员', 'Artisan', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 公司财务人员 -> fb62224ec67745aa87e56437ce5c92c6
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260005 + (ABS(HASHTEXT('fb62224ec67745aa87e56437ce5c92c6')) % 1000000), '000000', '公司财务人员', 'FinancialStaff', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

SELECT role_id, role_name, role_key FROM sys_role WHERE role_id > 1000000000 OR role_id > 90000000 ORDER BY role_id;