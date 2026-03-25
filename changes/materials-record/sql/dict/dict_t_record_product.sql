-- 备案产品相关字典配置
-- 执行前请确保字典表已存在

-- 字典类型：是否可用 (enabled_mark)
INSERT INTO sys_dict_type (dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark)
VALUES (80, '是否可用', 'record_enabled_mark', '0', 'admin', NOW(), NULL, NULL, '备案产品是否可用字典')
ON CONFLICT (dict_id) DO NOTHING;

-- 字典数据：是否可用
INSERT INTO sys_dict_data (dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
VALUES (80, 1, '禁用', '0', 'record_enabled_mark', 'danger', 'default', 'N', '0', 'admin', NOW(), NULL, NULL, '禁用状态')
ON CONFLICT (dict_code) DO NOTHING;

INSERT INTO sys_dict_data (dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
VALUES (81, 2, '正常', '1', 'record_enabled_mark', 'success', 'default', 'Y', '0', 'admin', NOW(), NULL, NULL, '正常状态')
ON CONFLICT (dict_code) DO NOTHING;

-- 字典类型：发送标志 (send_flag)
INSERT INTO sys_dict_type (dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark)
VALUES (81, '发送标志', 'send_flag', '0', 'admin', NOW(), NULL, NULL, '备案产品发送标志字典')
ON CONFLICT (dict_id) DO NOTHING;

-- 字典数据：发送标志
INSERT INTO sys_dict_data (dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
VALUES (82, 1, '未发送', '0', 'send_flag', 'info', 'default', 'Y', '0', 'admin', NOW(), NULL, NULL, '未发送')
ON CONFLICT (dict_code) DO NOTHING;

INSERT INTO sys_dict_data (dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
VALUES (83, 2, '已发送', '1', 'send_flag', 'success', 'default', 'N', '0', 'admin', NOW(), NULL, NULL, '已发送')
ON CONFLICT (dict_code) DO NOTHING;
