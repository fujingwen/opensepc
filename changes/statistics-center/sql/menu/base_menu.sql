-- Menu and Permission SQL for Statistics Center Module

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029131000000000001, '统计中心', 0, 22, 'statistics', '', 1, 0, 'M', '0', '0', '', 'histogram', 103, 1, now(), NULL, NULL, '统计中心顶级菜单')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029131000000000101, '统计分析', 2029131000000000001, 1, 'analysis', 'statistics/analysis/index', 1, 0, 'C', '0', '0', 'materials:statistics:list', 'data-analysis', 103, 1, now(), NULL, NULL, '统计分析页面'),
  (2029131000000000102, '采购价格分析', 2029131000000000001, 2, 'price', 'statistics/price/index', 1, 0, 'C', '0', '0', 'materials:price:list', 'trend-charts', 103, 1, now(), NULL, NULL, '采购价格分析页面')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029131000000000111, '查询', 2029131000000000101, 1, '', '', 1, 0, 'F', '0', '0', 'materials:statistics:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029131000000000112, '导出', 2029131000000000101, 2, '', '', 1, 0, 'F', '0', '0', 'materials:statistics:export', '#', 103, 1, now(), NULL, NULL, ''),
  (2029131000000000121, '查询', 2029131000000000102, 1, '', '', 1, 0, 'F', '0', '0', 'materials:price:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029131000000000122, '导出', 2029131000000000102, 2, '', '', 1, 0, 'F', '0', '0', 'materials:price:export', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;
