-- ----------------------------
-- Menu and Permission SQL for Message Center
-- ----------------------------

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029122000000000001, '消息中心', 0, 20, 'message', '', 1, 0, 'M', '0', '0', '', 'message', 103, 1, now(), NULL, NULL, '消息中心顶级菜单')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029122000000000101, '发送消息', 2029122000000000001, 1, 'send', 'message/send/index', 1, 0, 'C', '0', '0', 'message:send:list', 'message', 103, 1, now(), NULL, NULL, '发送消息页面'),
  (2029122000000000102, '消息查看', 2029122000000000001, 2, 'receive', 'message/receive/index', 1, 0, 'C', '0', '0', 'message:receive:list', 'chat-dot-round', 103, 1, now(), NULL, NULL, '消息查看页面'),
  (2029122000000000103, '预警信息', 2029122000000000001, 3, 'warning', 'message/warning/index', 1, 0, 'C', '0', '0', 'message:warning:list', 'warning', 103, 1, now(), NULL, NULL, '预警信息页面')
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2029122000000000111, '查询', 2029122000000000101, 1, '', '', 1, 0, 'F', '0', '0', 'message:send:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000112, '新增', 2029122000000000101, 2, '', '', 1, 0, 'F', '0', '0', 'message:send:add', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000113, '删除', 2029122000000000101, 3, '', '', 1, 0, 'F', '0', '0', 'message:send:remove', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000121, '查询', 2029122000000000102, 1, '', '', 1, 0, 'F', '0', '0', 'message:receive:query', '#', 103, 1, now(), NULL, NULL, ''),
  (2029122000000000131, '查询', 2029122000000000103, 1, '', '', 1, 0, 'F', '0', '0', 'message:warning:query', '#', 103, 1, now(), NULL, NULL, '')
ON CONFLICT (menu_id) DO NOTHING;
