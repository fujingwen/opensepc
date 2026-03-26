-- ----------------------------
-- Menu and Permission SQL for Quality Trace Module
-- ----------------------------

-- 质量追溯模块一级菜单
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (2200, '质量追溯', 0, 100, 'quality-trace', NULL, 1, 0, 'M', '0', '0', '', 'chart', 103, 1, now(), NULL, NULL, '质量追溯模块菜单')
ON CONFLICT (menu_id) DO NOTHING;

-- 抽测缺陷建材产品页面菜单
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (2201, '抽测缺陷建材产品', 2200, 1, 'spot-testing', 'quality/spot-testing/index', 1, 0, 'C', '0', '0', 'quality:spotTesting:list', 'documentation', 103, 1, now(), NULL, NULL, '抽测缺陷建材产品菜单')
ON CONFLICT (menu_id) DO NOTHING;

-- 查询按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (2202, '抽测缺陷建材产品查询', 2201, 1, '', '', 1, 0, 'F', '0', '0', 'quality:spotTesting:query', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;

-- 删除按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (2203, '抽测缺陷建材产品删除', 2201, 2, '', '', 1, 0, 'F', '0', '0', 'quality:spotTesting:remove', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;

-- 导入按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (2204, '抽测缺陷建材产品导入', 2201, 3, '', '', 1, 0, 'F', '0', '0', 'quality:spotTesting:import', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;