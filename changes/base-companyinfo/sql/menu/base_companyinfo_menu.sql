-- ----------------------------
-- Menu and Permission SQL for Enterprise Info Module
-- 基于数据库实际数据更新
-- ----------------------------

SET search_path TO master;

-- 一级目录菜单（基础数据）
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000001, '基础数据', 0, 50, 'base', NULL, 1, 0, 'M', '0', '0', '', 'database', 103, 1, now(), NULL, NULL, '基础数据目录')
ON CONFLICT (menu_id) DO NOTHING;

-- 二级菜单（生产企业）company_type=2
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000002, '生产企业', 5000001, 1, 'production', 'base/production/index', 1, 0, 'C', '0', '0', 'base:production:list', 'factory', 103, 1, now(), NULL, NULL, '生产企业管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 生产企业按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000003, '查询', 5000002, 1, '', '', 1, 0, 'F', '0', '0', 'base:production:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000004, '新增', 5000002, 2, '', '', 1, 0, 'F', '0', '0', 'base:production:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000005, '修改', 5000002, 3, '', '', 1, 0, 'F', '0', '0', 'base:production:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000006, '删除', 5000002, 4, '', '', 1, 0, 'F', '0', '0', 'base:production:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000007, '导出', 5000002, 5, '', '', 1, 0, 'F', '0', '0', 'base:production:export', '#', 103, 1, now(), NULL, NULL, '');

-- 二级菜单（施工企业）company_type=1
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000008, '施工企业', 5000001, 2, 'construction', 'base/construction/index', 1, 0, 'C', '0', '0', 'base:construction:list', 'build', 103, 1, now(), NULL, NULL, '施工企业管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 施工企业按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000009, '查询', 5000008, 1, '', '', 1, 0, 'F', '0', '0', 'base:construction:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000010, '新增', 5000008, 2, '', '', 1, 0, 'F', '0', '0', 'base:construction:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000011, '修改', 5000008, 3, '', '', 1, 0, 'F', '0', '0', 'base:construction:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000012, '删除', 5000008, 4, '', '', 1, 0, 'F', '0', '0', 'base:construction:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000013, '导出', 5000008, 5, '', '', 1, 0, 'F', '0', '0', 'base:construction:export', '#', 103, 1, now(), NULL, NULL, '');

-- 二级菜单（代理商）company_type=3
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000014, '代理商', 5000001, 3, 'agent', 'base/agent/index', 1, 0, 'C', '0', '0', 'base:agent:list', 'truck', 103, 1, now(), NULL, NULL, '代理商管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 代理商按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000015, '查询', 5000014, 1, '', '', 1, 0, 'F', '0', '0', 'base:agent:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000016, '新增', 5000014, 2, '', '', 1, 0, 'F', '0', '0', 'base:agent:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000017, '修改', 5000014, 3, '', '', 1, 0, 'F', '0', '0', 'base:agent:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000018, '删除', 5000014, 4, '', '', 1, 0, 'F', '0', '0', 'base:agent:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000019, '导出', 5000014, 5, '', '', 1, 0, 'F', '0', '0', 'base:agent:export', '#', 103, 1, now(), NULL, NULL, '');