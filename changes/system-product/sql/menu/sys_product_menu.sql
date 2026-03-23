-- ----------------------------
-- Menu and Permission SQL for Product Module
-- ----------------------------

-- 二级菜单（产品管理）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2000, '产品管理', 1, 10, 'sysProduct', 'system/product/index', 1, 0, 'C', '0', '0', 'system:product:list', 'shopping', 103, 1, now(), NULL, NULL, '产品管理菜单')
ON CONFLICT (menu_id) DO NOTHING;

-- 按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2001, '查询', 2000, 1, '', '', 1, 0, 'F', '0', '0', 'system:product:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2002, '新增', 2000, 2, '', '', 1, 0, 'F', '0', '0', 'system:product:add', '#', 103, 1, now(), NULL, NULL, ''),
  (2003, '修改', 2000, 3, '', '', 1, 0, 'F', '0', '0', 'system:product:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (2004, '删除', 2000, 4, '', '', 1, 0, 'F', '0', '0', 'system:product:remove', '#', 103, 1, now(), NULL, NULL, '');
