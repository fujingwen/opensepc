-- ----------------------------
-- Menu and Permission SQL for Product Dictionary Module
-- ----------------------------

-- 二级菜单（产品管理）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (3000, '产品管理dict', 1, 11, 'sysProductDict', 'system/product/index-dict', 1, 0, 'C', '0', '0', 'base:dictionary:list', 'shopping', 103, 1, now(), NULL, NULL, '产品管理菜单（字典）')
ON CONFLICT (menu_id) DO NOTHING;

-- 按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (3001, '查询', 3000, 1, '', '', 1, 0, 'F', '0', '0', 'base:dictionary:query', '#', 103, 1, now(), NULL, NULL, ''),
  (3002, '新增', 3000, 2, '', '', 1, 0, 'F', '0', '0', 'base:dictionary:add', '#', 103, 1, now(), NULL, NULL, ''),
  (3003, '修改', 3000, 3, '', '', 1, 0, 'F', '0', '0', 'base:dictionary:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (3004, '删除', 3000, 4, '', '', 1, 0, 'F', '0', '0', 'base:dictionary:remove', '#', 103, 1, now(), NULL, NULL, '');
