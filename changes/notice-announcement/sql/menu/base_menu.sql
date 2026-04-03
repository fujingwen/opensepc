INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029122000000000002, '通知公告', 0, 21, 'notice', '', 1, 0, 'M', '0', '0', '', 'notification', 103, 1, now(), NULL, NULL, '通知公告顶级菜单')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029122000000000201, '系统公告', 2029122000000000002, 1, 'system', 'notice/system/index', 1, 0, 'C', '0', '0', 'notice:system:list', 'bell', 103, 1, now(), NULL, NULL, '系统公告页面'),
  (2029122000000000202, '库存信息发布', 2029122000000000002, 2, 'inventory', 'notice/inventory/index', 1, 0, 'C', '0', '0', 'notice:inventory:list', 'promotion', 103, 1, now(), NULL, NULL, '库存信息发布页面'),
  (2029122000000000203, '采购信息发布', 2029122000000000002, 3, 'purchase', 'notice/purchase/index', 1, 0, 'C', '0', '0', 'notice:purchase:list', 'back', 103, 1, now(), NULL, NULL, '采购信息发布页面')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029122000000000211, '查询', 2029122000000000201, 1, '', '', 1, 0, 'F', '0', '0', 'notice:system:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000212, '新增', 2029122000000000201, 2, '', '', 1, 0, 'F', '0', '0', 'notice:system:add', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000213, '删除', 2029122000000000201, 3, '', '', 1, 0, 'F', '0', '0', 'notice:system:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000221, '查询', 2029122000000000202, 1, '', '', 1, 0, 'F', '0', '0', 'notice:inventory:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000222, '新增', 2029122000000000202, 2, '', '', 1, 0, 'F', '0', '0', 'notice:inventory:add', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000223, '删除', 2029122000000000202, 3, '', '', 1, 0, 'F', '0', '0', 'notice:inventory:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000231, '查询', 2029122000000000203, 1, '', '', 1, 0, 'F', '0', '0', 'notice:purchase:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000232, '新增', 2029122000000000203, 2, '', '', 1, 0, 'F', '0', '0', 'notice:purchase:add', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000233, '删除', 2029122000000000203, 3, '', '', 1, 0, 'F', '0', '0', 'notice:purchase:remove', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;
