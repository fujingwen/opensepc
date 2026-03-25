-- 建材填报管理模块菜单配置
-- 执行前请确保菜单表已存在

-- 模块菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2100, '建材填报管理', 0, 100, 'building-materials', NULL, 1, 0, 'M', '0', '0', '', 'system', 'admin', NOW(), NULL, NULL, '建材填报管理菜单')
ON CONFLICT (menu_id) DO NOTHING;

-- 备案产品管理页面菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2101, '备案产品管理', 2100, 1, 'record', 'building-materials/record/index', 1, 0, 'C', '0', '0', 'materials:record:list', 'peoples', 'admin', NOW(), NULL, NULL, '备案产品管理菜单')
ON CONFLICT (menu_id) DO NOTHING;

-- 备案产品查询按钮
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2102, '备案产品查询', 2101, 1, '', NULL, 1, 0, 'F', '0', '0', 'materials:record:query', '#', 'admin', NOW(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;

-- 备案产品新增按钮
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2103, '备案产品新增', 2101, 2, '', NULL, 1, 0, 'F', '0', '0', 'materials:record:add', '#', 'admin', NOW(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;

-- 备案产品修改按钮
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2104, '备案产品修改', 2101, 3, '', NULL, 1, 0, 'F', '0', '0', 'materials:record:edit', '#', 'admin', NOW(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;

-- 备案产品删除按钮
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2105, '备案产品删除', 2101, 4, '', NULL, 1, 0, 'F', '0', '0', 'materials:record:remove', '#', 'admin', NOW(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;
