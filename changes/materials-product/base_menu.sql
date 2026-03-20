INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000200, '建材产品', 2029119644310482945, 2, 'product', 'materials/product/index', 1, 0, 'C', '0', '0', 'materials:product:list', 'example', 103, 1, now(), NULL, NULL, '建材产品管理页面')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000201, '查询', 5000200, 1, '', '', 1, 0, 'F', '0', '0', 'materials:product:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000202, '新增', 5000200, 2, '', '', 1, 0, 'F', '0', '0', 'materials:product:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000203, '修改', 5000200, 3, '', '', 1, 0, 'F', '0', '0', 'materials:product:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000204, '删除', 5000200, 4, '', '', 1, 0, 'F', '0', '0', 'materials:product:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000205, '详情', 5000200, 5, '', '', 1, 0, 'F', '0', '0', 'materials:product:detail', '#', 103, 1, now(), NULL, NULL, ''),
  (5000206, '导出', 5000200, 6, '', '', 1, 0, 'F', '0', '0', 'materials:product:export', '#', 103, 1, now(), NULL, NULL, ''),
  (5000207, '审核', 5000200, 7, '', '', 1, 0, 'F', '0', '0', 'materials:product:audit', '#', 103, 1, now(), NULL, NULL, '');
