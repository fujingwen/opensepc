-- Menu and Permission SQL for Quality Trace Module

INSERT INTO "master"."sys_menu" (
  menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark
) VALUES
  (2029132000000000001, '质量追溯', 0, 21, 'quality', '', 1, 0, 'M', '0', '0', '', 'guide', 103, 1, now(), NULL, NULL, '质量追溯顶级菜单')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (
  menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark
) VALUES
  (2029132000000000101, '抽测缺陷建材产品', 2029132000000000001, 1, 'spot-testing', 'quality/spot-testing/index', 1, 0, 'C', '0', '0', 'materials:qualityTrace:spot:list', 'filter', 103, 1, now(), NULL, NULL, '抽测缺陷建材产品页面'),
  (2029132000000000102, '检测缺陷建材产品', 2029132000000000001, 2, 'detect-testing', 'quality/detect-testing/index', 1, 0, 'C', '0', '0', 'materials:qualityTrace:detect:list', 'apple', 103, 1, now(), NULL, NULL, '检测缺陷建材产品页面'),
  (2029132000000000103, '缺陷建材使用情况', 2029132000000000001, 3, 'usage', 'quality/usage/index', 1, 0, 'C', '0', '0', 'materials:qualityTrace:usage:list', 'tickets', 103, 1, now(), NULL, NULL, '缺陷建材使用情况页面'),
  (2029132000000000104, '缺陷建材厂家', 2029132000000000001, 4, 'factory', 'quality/factory/index', 1, 0, 'C', '0', '0', 'materials:qualityTrace:factory:list', 'operation', 103, 1, now(), NULL, NULL, '缺陷建材厂家页面')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (
  menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark
) VALUES
  (2029132000000000111, '查询', 2029132000000000101, 1, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:spot:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000112, '导入', 2029132000000000101, 2, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:spot:import', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000113, '删除', 2029132000000000101, 3, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:spot:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000121, '查询', 2029132000000000102, 1, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:detect:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000122, '删除', 2029132000000000102, 2, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:detect:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000123, '复检合格', 2029132000000000102, 3, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:detect:recheck', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000131, '查询', 2029132000000000103, 1, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:usage:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000132, '隐藏', 2029132000000000103, 2, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:usage:hide', '#', 103, 1, now(), NULL, NULL, ''),
  (2029132000000000141, '查询', 2029132000000000104, 1, '', '', 1, 0, 'F', '0', '0', 'materials:qualityTrace:factory:query', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;
