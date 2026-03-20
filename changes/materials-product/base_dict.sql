INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (301, '000000', '信息确认状态', 'info_confirm_status', 103, now(), '建材填报管理-建材产品-信息确认状态')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (701, '000000', 1, '待信息确认', '1', 'info_confirm_status', '', 'warning', 'Y', 103, now(), ''),
  (702, '000000', 2, '信息确认通过', '2', 'info_confirm_status', '', 'success', 'N', 103, now(), ''),
  (703, '000000', 3, '信息确认不通过', '3', 'info_confirm_status', '', 'danger', 'N', 103, now(), ''),
  (704, '000000', 4, '待再次信息确认', '4', 'info_confirm_status', '', 'warning', 'N', 103, now(), ''),
  (705, '000000', 5, '信息确认再次不通过', '5', 'info_confirm_status', '', 'danger', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (302, '000000', '信息确认超时', 'info_confirm_timeout', 103, now(), '建材填报管理-建材产品-信息确认超时')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (706, '000000', 1, '是', '1', 'info_confirm_timeout', '', 'danger', 'N', 103, now(), ''),
  (707, '000000', 2, '否', '2', 'info_confirm_timeout', '', 'success', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (303, '000000', '信息确认不通过类别', 'info_confirm_fail_type', 103, now(), '建材填报管理-建材产品-信息确认不通过类别')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (708, '000000', 1, '资料不全（不符）', '1', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (709, '000000', 2, '疑似假冒', '2', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (710, '000000', 3, '采购数量不符', '3', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (711, '000000', 4, '品牌填写错误', '4', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (712, '000000', 5, '填报规格与实际供货规格不符', '5', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (713, '000000', 6, '图片清晰度不够，无法辨识', '6', 'info_confirm_fail_type', '', '', 'N', 103, now(), ''),
  (714, '000000', 7, '其他', '7', 'info_confirm_fail_type', '', '', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (304, '000000', '有无备案证号', 'has_certificate_number', 103, now(), '建材填报管理-建材产品-有无备案证号')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (715, '000000', 1, '有', '1', 'has_certificate_number', '', 'success', 'N', 103, now(), ''),
  (716, '000000', 2, '无', '2', 'has_certificate_number', '', 'danger', 'N', 103, now(), '');

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (305, '000000', '建材产品工程进度', 'product_project_progress', 103, now(), '建材填报管理-建材产品-工程进度')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (717, '000000', 1, '工程安装阶段', '1', 'product_project_progress', '', '', 'N', 103, now(), ''),
  (718, '000000', 2, '测试1', '2', 'product_project_progress', '', '', 'N', 103, now(), ''),
  (719, '000000', 3, '测试2', '3', 'product_project_progress', '', '', 'N', 103, now(), '');
