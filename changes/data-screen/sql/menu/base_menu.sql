-- Menu and Permission SQL for Data Screen Module

INSERT INTO "master"."sys_menu" (
  menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark
)
VALUES
  (2029133000000000001, '数据大屏', 0, 39, 'dashboard', '', 1, 0, 'M', '0', '0', '', 'dashboard', 103, 1, now(), NULL, NULL, '建材数据大屏顶层菜单')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (
  menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark
)
VALUES
  (2029133000000000101, '建材数据大屏', 2029133000000000001, 1, 'materials', 'dashboard/materials/index', 1, 0, 'C', '0', '0', 'materials:dashboard:view', 'dashboard', 103, 1, now(), NULL, NULL, '建材数据大屏页面')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (
  menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark
)
VALUES
  (2029133000000000111, '查看', 2029133000000000101, 1, '', '', 1, 0, 'F', '0', '0', 'materials:dashboard:query', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_role_menu" (role_id, menu_id)
SELECT 1, v.menu_id
FROM (VALUES
  (2029133000000000001::bigint),
  (2029133000000000101::bigint),
  (2029133000000000111::bigint)
) AS v(menu_id)
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_role_menu" rm
  WHERE rm.role_id = 1
    AND rm.menu_id = v.menu_id
);
