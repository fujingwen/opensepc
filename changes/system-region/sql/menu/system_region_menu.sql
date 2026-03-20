-- ----------------------------
-- Menu and Permission SQL for System Region Module
-- ----------------------------

-- 二级菜单（行政区划管理）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (1066, '行政区划管理', 1, 9, 'region', 'system/region/index', 1, 0, 'C', '0', '0', 'system:region:list', 'location', 103, 1, now(), NULL, NULL, '行政区划管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 行政区划按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (1067, '查询', 1066, 1, '', '', 1, 0, 'F', '0', '0', 'system:region:query', '#', 103, 1, now(), NULL, NULL, ''),
  (1068, '新增', 1066, 2, '', '', 1, 0, 'F', '0', '0', 'system:region:add', '#', 103, 1, now(), NULL, NULL, ''),
  (1069, '修改', 1066, 3, '', '', 1, 0, 'F', '0', '0', 'system:region:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (1070, '删除', 1066, 4, '', '', 1, 0, 'F', '0', '0', 'system:region:remove', '#', 103, 1, now(), NULL, NULL, '');
