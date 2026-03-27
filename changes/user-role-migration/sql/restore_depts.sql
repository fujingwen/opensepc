-- =============================================
-- 恢复部门数据：新旧数据并存
-- 将之前被删除的原始部门数据重新插入
-- =============================================

SET search_path TO master;

-- 查看当前部门情况
SELECT '当前部门数量' as msg, COUNT(*) as cnt FROM sys_dept WHERE del_flag = '0';
SELECT 'parent_id=0的根部门' as msg, COUNT(*) as cnt FROM sys_dept WHERE del_flag = '0' AND parent_id = 0;

-- 1. 恢复原有的根部门（如果不存在）
-- 建材管理平台
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 941355476, '000000', 0, '941355476', '建材管理平台', 'company', 1, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 941355476 AND del_flag = '0');

-- 其他
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 345796081, '000000', 0, '345796081', '其他', 'company', 2, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 345796081 AND del_flag = '0');

-- 2. 恢复"其他"下的子部门
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 376557512, '000000', 345796081, '345796081,376557512', '人事部', 'department', 1, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 376557512 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 552115639, '000000', 345796081, '345796081,552115639', '技术部', 'department', 2, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 552115639 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 52776285, '000000', 345796081, '345796081,52776285', '仓储部', 'department', 3, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 52776285 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 747419046, '000000', 345796081, '345796081,747419046', '生产部', 'department', 4, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 747419046 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 486154784, '000000', 345796081, '345796081,486154784', '财务部', 'department', 5, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 486154784 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 363621211, '000000', 345796081, '345796081,363621211', '销售部', 'department', 6, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 363621211 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 535281621, '000000', 345796081, '345796081,535281621', '市场部', 'department', 7, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 535281621 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 620272006, '000000', 345796081, '345796081,620272006', '行政部', 'department', 8, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 620272006 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 331417640, '000000', 345796081, '345796081,331417640', '总裁办', 'department', 9, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 331417640 AND del_flag = '0');

-- 3. 恢复"建材管理平台"下的子部门
-- 生产单位
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 204913906, '000000', 941355476, '941355476,204913906', '生产单位', 'company', 1, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 204913906 AND del_flag = '0');

-- 建管中心
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 942631849, '000000', 941355476, '941355476,942631849', '建管中心', 'company', 2, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 942631849 AND del_flag = '0');

-- 施工单位
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 869489916, '000000', 941355476, '941355476,869489916', '施工单位', 'company', 3, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 869489916 AND del_flag = '0');

-- 4. 恢复"建管中心"下的子部门
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 95686342, '000000', 942631849, '941355476,942631849,95686342', '青岛市建筑工程管理服务中心', 'company', 1, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 95686342 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 30526919, '000000', 942631849, '941355476,942631849,30526919', '造价处', 'company', 2, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 30526919 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 617677216, '000000', 942631849, '941355476,942631849,617677216', '市政质监站', 'company', 3, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 617677216 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 155847380, '000000', 942631849, '941355476,942631849,155847380', '节能中心', 'company', 4, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 155847380 AND del_flag = '0');

-- 西海岸新区（区域）
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 714479966, '000000', 942631849, '941355476,942631849,714479966', '西海岸新区', 'company', 5, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 714479966 AND del_flag = '0');

-- 各区
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 787401389, '000000', 942631849, '941355476,942631849,787401389', '崂山区', 'company', 6, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 787401389 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 885797900, '000000', 942631849, '941355476,942631849,885797900', '城阳区', 'company', 7, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 885797900 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 441326665, '000000', 942631849, '941355476,942631849,441326665', '高新区', 'company', 8, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 441326665 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 250806530, '000000', 942631849, '941355476,942631849,250806530', '即墨区', 'company', 9, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 250806530 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 808776370, '000000', 942631849, '941355476,942631849,808776370', '胶州市', 'company', 10, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 808776370 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 604001319, '000000', 942631849, '941355476,942631849,604001319', '平度市', 'company', 11, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 604001319 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 532849964, '000000', 942631849, '941355476,942631849,532849964', '莱西市', 'company', 12, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 532849964 AND del_flag = '0');

-- 5. 恢复"西海岸新区"下的子部门
INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 991799033, '000000', 714479966, '941355476,942631849,714479966,991799033', '青岛灵山湾影视文化产业区', 'company', 1, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 991799033 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 44332318, '000000', 714479966, '941355476,942631849,714479966,44332318', '古镇口核心区', 'company', 2, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 44332318 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 192730874, '000000', 714479966, '941355476,942631849,714479966,192730874', '青岛经济技术开发区', 'company', 3, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 192730874 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 876834817, '000000', 714479966, '941355476,942631849,714479966,876834817', '青岛海洋高新区', 'company', 4, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 876834817 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 143402241, '000000', 714479966, '941355476,942631849,714479966,143402241', '泊里镇规划建设管理办公室', 'company', 5, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 143402241 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 566443083, '000000', 714479966, '941355476,942631849,714479966,566443083', '青岛董家口经济区管理委员会', 'company', 6, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 566443083 AND del_flag = '0');

INSERT INTO sys_dept (dept_id, tenant_id, parent_id, ancestors, dept_name, dept_category, order_num, status, del_flag, create_dept, create_by, create_time, remark)
SELECT 666875369, '000000', 714479966, '941355476,942631849,714479966,666875369', '青岛自贸片区·中德生态园', 'company', 7, '0', '0', '103', 1, NOW(), '系统原有部门'
WHERE NOT EXISTS (SELECT 1 FROM sys_dept WHERE dept_id = 666875369 AND del_flag = '0');

-- 验证结果
SELECT '恢复后部门数量' as msg, COUNT(*) as cnt FROM sys_dept WHERE del_flag = '0';
SELECT dept_id, parent_id, dept_name, dept_category FROM sys_dept WHERE del_flag = '0' ORDER BY parent_id, order_num;