-- 插入补充的角色数据
SET search_path TO master;

-- 仓库保管员 - Storekeeper
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260010 + (ABS(HASHTEXT('430cae253e6e49ed9a1a181c232c454c')) % 1000000), '000000', '仓库保管员', 'Storekeeper', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 热线客服 - CustomService
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260011 + (ABS(HASHTEXT('9ad2e5556a6943a88a009a5f3fc8c3f4')) % 1000000), '000000', '热线客服', 'CustomService', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 工程实施人员 - Implement
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260012 + (ABS(HASHTEXT('263e7baaba374a9cb850003318c36c75')) % 1000000), '000000', '工程实施人员', 'Implement', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 测试人员 - Testers
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260013 + (ABS(HASHTEXT('24eea52ee52f48b4a957dadf19af8b48')) % 1000000), '000000', '测试人员', 'Testers', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 开发人员 - Developer
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260014 + (ABS(HASHTEXT('e55532c906b348798b078ea0c17dbbb1')) % 1000000), '000000', '开发人员', 'Developer', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 总经理 - General
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260015 + (ABS(HASHTEXT('d2b2418a2f664c61abf0053ff5d57783')) % 1000000), '000000', '总经理', 'General', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 董事长 - Chairman
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260016 + (ABS(HASHTEXT('1e1a3ee8151c4100952b2e064bc477df')) % 1000000), '000000', '董事长', 'Chairman', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 内部员工 - Staff
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260017 + (ABS(HASHTEXT('6c3f9f53e1824ed597d4a6349fadd869')) % 1000000), '000000', '内部员工', 'Staff', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 用户管理员 - UserAdmin
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260018 + (ABS(HASHTEXT('61c01309ea7e407d8db81343b0f35d53')) % 1000000), '000000', '用户管理员', 'UserAdmin', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 审计员 - Auditor
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260019 + (ABS(HASHTEXT('5d2f759575cc478089f63735002a7e2d')) % 1000000), '000000', '审计员', 'Auditor', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 安全管理员 - SecurityAdministrator
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260020 + (ABS(HASHTEXT('86fca18153874ad6af2c45e92f7c9f0e')) % 1000000), '000000', '安全管理员', 'SecurityAdministrator', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 业务管理员 - BusinessManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260021 + (ABS(HASHTEXT('cfdee634223c45599e41e7914e01dec8')) % 1000000), '000000', '业务管理员', 'BusinessManager', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 助理 - Assistant
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260022 + (ABS(HASHTEXT('63aea62b253945ef95b23be9a47f6005')) % 1000000), '000000', '助理', 'Assistant', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 公司出纳 - Cashier
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260023 + (ABS(HASHTEXT('4102c375f22a4928858cc3b467ca3f11')) % 1000000), '000000', '公司出纳', 'Cashier', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 公司会计 - Accounting
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260024 + (ABS(HASHTEXT('27b4959fbb6d4bb4ba1256368928b14b')) % 1000000), '000000', '公司会计', 'Accounting', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 公司财务 - Financial
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260025 + (ABS(HASHTEXT('ee68990da3df416d9f7e103f8447cc8a')) % 1000000), '000000', '公司财务', 'Financial', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 财务分管领导 - FinancialLeadership
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260026 + (ABS(HASHTEXT('b518a7269a0b47b6927081bae86d3015')) % 1000000), '000000', '财务分管领导', 'FinancialLeadership', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 人事分管领导 - PersonnelLeadership
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260027 + (ABS(HASHTEXT('2db636ec5f304df1bfbb6f0843db4826')) % 1000000), '000000', '人事分管领导', 'PersonnelLeadership', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 业务分管领导 - BusinessLeadership
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260028 + (ABS(HASHTEXT('4038634aaa494dd1baf3649e093009ac')) % 1000000), '000000', '业务分管领导', 'BusinessLeadership', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 系统管理员 - SystemManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260029 + (ABS(HASHTEXT('94e3a9bb0fce4547886972998fddba1c')) % 1000000), '000000', '系统管理员', 'SystemManager', 0, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 生产企业人员 - scqyry
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 270397049369789701, '000000', '生产企业人员', 'scqyry', 1, '1', true, true, '0', '0', '103', '1', '2022-03-07', '', '系统';

-- 业务部主管 - BusinessDepManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260030 + (ABS(HASHTEXT('5c947606e3a449cb8670e053e5a22bd0')) % 1000000), '000000', '业务部主管', 'BusinessDepManager', 1, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 部门副主管 - AssistantManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260031 + (ABS(HASHTEXT('c7485f75127e4837931c7e3e67c206e4')) % 1000000), '000000', '部门副主管', 'AssistantManager', 1, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 财务部门主管 - Manager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260032 + (ABS(HASHTEXT('6b7d4076551e4ddc9893ec87ddb02f0c')) % 1000000), '000000', '财务部门主管', 'Manager', 3, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 工程部主管 - EngineeringDepManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260033 + (ABS(HASHTEXT('b13dcb3fcd704d448bc0aaaf77cc9369')) % 1000000), '000000', '工程部主管', 'EngineeringDepManager', 6, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 财务主管 - FinanceDepManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260034 + (ABS(HASHTEXT('956cc4716430436ca806be9d7b0e3c22')) % 1000000), '000000', '财务主管', 'FinanceDepManager', 6, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 人事主管 - PersonnelDepManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260035 + (ABS(HASHTEXT('69457a61a6ba47218849c651ae99f2e5')) % 1000000), '000000', '人事主管', 'PersonnelDepManager', 10, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 测试部主管 - TestDepManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260036 + (ABS(HASHTEXT('65edd7f20555492ebc632f3e0745265d')) % 1000000), '000000', '测试部主管', 'TestDepManager', 11, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 客户服务主管 - CustomerServiceDepManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260037 + (ABS(HASHTEXT('81983beb284a4b24a1541d062cf8d346')) % 1000000), '000000', '客户服务主管', 'CustomerServiceDepManager', 20, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

-- 开发部主管 - DevelopmentDepManager
INSERT INTO sys_role (role_id, tenant_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_dept, create_by, create_time, remark, create_name)
SELECT 91260038 + (ABS(HASHTEXT('fc6769adb74041ceae5db0cb8988fe8d')) % 1000000), '000000', '开发部主管', 'DevelopmentDepManager', 96, '1', true, true, '0', '0', '103', '1', '2017-10-27', '', '系统';

SELECT role_id, role_name, role_key FROM sys_role WHERE role_id > 90000000 ORDER BY role_id;