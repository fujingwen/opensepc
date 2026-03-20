-- ----------------------------
-- Menu and Permission SQL for Basic Data Module
-- ----------------------------

-- 一级目录菜单（基础数据）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000001, '基础数据', 0, 5, 'base', NULL, 1, 0, 'M', '0', '0', '', 'database', 103, 1, now(), NULL, NULL, '基础数据目录')
ON CONFLICT (menu_id) DO NOTHING;

-- 二级菜单（生产企业）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000002, '生产企业', 5000001, 1, 'production', 'base/production/index', 1, 0, 'C', '0', '0', 'base:production:list', 'factory', 103, 1, now(), NULL, NULL, '生产企业管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 生产企业按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000003, '查询', 5000002, 1, '', '', 1, 0, 'F', '0', '0', 'base:production:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000004, '新增', 5000002, 2, '', '', 1, 0, 'F', '0', '0', 'base:production:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000005, '修改', 5000002, 3, '', '', 1, 0, 'F', '0', '0', 'base:production:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000006, '删除', 5000002, 4, '', '', 1, 0, 'F', '0', '0', 'base:production:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000007, '导出', 5000002, 5, '', '', 1, 0, 'F', '0', '0', 'base:production:export', '#', 103, 1, now(), NULL, NULL, '');

-- 二级菜单（施工企业）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000008, '施工企业', 5000001, 2, 'construction', 'base/construction/index', 1, 0, 'C', '0', '0', 'base:construction:list', 'build', 103, 1, now(), NULL, NULL, '施工企业管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 施工企业按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000009, '查询', 5000008, 1, '', '', 1, 0, 'F', '0', '0', 'base:construction:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000010, '新增', 5000008, 2, '', '', 1, 0, 'F', '0', '0', 'base:construction:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000011, '修改', 5000008, 3, '', '', 1, 0, 'F', '0', '0', 'base:construction:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000012, '删除', 5000008, 4, '', '', 1, 0, 'F', '0', '0', 'base:construction:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000013, '导出', 5000008, 5, '', '', 1, 0, 'F', '0', '0', 'base:construction:export', '#', 103, 1, now(), NULL, NULL, '');

-- 二级菜单（代理商）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000014, '代理商', 5000001, 3, 'agent', 'base/agent/index', 1, 0, 'C', '0', '0', 'base:agent:list', 'truck', 103, 1, now(), NULL, NULL, '代理商管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 代理商按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000015, '查询', 5000014, 1, '', '', 1, 0, 'F', '0', '0', 'base:agent:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000016, '新增', 5000014, 2, '', '', 1, 0, 'F', '0', '0', 'base:agent:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000017, '修改', 5000014, 3, '', '', 1, 0, 'F', '0', '0', 'base:agent:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000018, '删除', 5000014, 4, '', '', 1, 0, 'F', '0', '0', 'base:agent:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000019, '导出', 5000014, 5, '', '', 1, 0, 'F', '0', '0', 'base:agent:export', '#', 103, 1, now(), NULL, NULL, '');

-- 二级菜单（统一用户信息）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000020, '统一用户信息', 5000001, 4, 'unifiedUser', 'base/unifiedUser/index', 1, 0, 'C', '0', '0', 'base:unifiedUser:list', 'user', 103, 1, now(), NULL, NULL, '统一用户信息页面（预留）')
ON CONFLICT (menu_id) DO NOTHING;

-- 统一用户信息按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000021, '查询', 5000020, 1, '', '', 1, 0, 'F', '0', '0', 'base:unifiedUser:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000022, '查看', 5000020, 2, '', '', 1, 0, 'F', '0', '0', 'base:unifiedUser:view', '#', 103, 1, now(), NULL, NULL, '');

-- 权限关联（示例数据，实际应根据系统角色配置）
INSERT INTO "master"."sys_role_menu" (role_id, menu_id, create_time)
VALUES
  (1, 5000001, now()),  -- 管理员角色拥有基础数据目录权限
  (1, 5000002, now()),  -- 管理员角色拥有生产企业菜单权限
  (1, 5000003, now()),  -- 管理员角色拥有生产企业查询权限
  (1, 5000004, now()),  -- 管理员角色拥有生产企业新增权限
  (1, 5000005, now()),  -- 管理员角色拥有生产企业修改权限
  (1, 5000006, now()),  -- 管理员角色拥有生产企业删除权限
  (1, 5000007, now()),  -- 管理员角色拥有生产企业导出权限
  (1, 5000008, now()),  -- 管理员角色拥有施工企业菜单权限
  (1, 5000014, now()),  -- 管理员角色拥有代理商菜单权限
  (1, 5000020, now());   -- 管理员角色拥有统一用户信息菜单权限
