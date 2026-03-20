-- ----------------------------
-- Menu and Permission SQL for Engineering Project Module
-- ----------------------------

-- 二级菜单（工程项目）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000100, '工程项目', 2029119644310482945, 1, 'project', 'materials/project/index', 1, 0, 'C', '0', '0', 'materials:project:list', 'example', 103, 1, now(), NULL, NULL, '工程项目管理页面')
ON CONFLICT (menu_id) DO NOTHING;

-- 工程项目按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (5000101, '查询', 5000100, 1, '', '', 1, 0, 'F', '0', '0', 'materials:project:query', '#', 103, 1, now(), NULL, NULL, ''),
  (5000102, '新增', 5000100, 2, '', '', 1, 0, 'F', '0', '0', 'materials:project:add', '#', 103, 1, now(), NULL, NULL, ''),
  (5000103, '修改', 5000100, 3, '', '', 1, 0, 'F', '0', '0', 'materials:project:edit', '#', 103, 1, now(), NULL, NULL, ''),
  (5000104, '删除', 5000100, 4, '', '', 1, 0, 'F', '0', '0', 'materials:project:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (5000105, '详情', 5000100, 5, '', '', 1, 0, 'F', '0', '0', 'materials:project:detail', '#', 103, 1, now(), NULL, NULL, '');

-- 权限关联（示例数据，实际应根据系统角色配置）
INSERT INTO "master"."sys_role_menu" (role_id, menu_id, create_time)
VALUES
  (1, 5000100, now()),  -- 管理员角色拥有工程项目菜单权限
  (1, 5000101, now()),  -- 管理员角色拥有工程项目查询权限
  (1, 5000102, now()),  -- 管理员角色拥有工程项目新增权限
  (1, 5000103, now()),  -- 管理员角色拥有工程项目修改权限
  (1, 5000104, now()),  -- 管理员角色拥有工程项目删除权限
  (1, 5000105, now());  -- 管理员角色拥有工程项目详情权限
