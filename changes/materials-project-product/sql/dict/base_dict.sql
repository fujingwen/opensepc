-- ----------------------------
-- Dictionary Data for Engineering Project & Building Material Product Module
-- 整合自 materials-project 和 materials-product 提案
-- ----------------------------

-- ============== 工程项目字典 ==============

-- 工程进度字典
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (201, '000000', '工程进度', 'project_progress', 103, now(), '建材填报管理-工程项目-工程项目进度')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (601, '000000', 1, '施工前准备阶段', '1', 'project_progress', '', '', 'N', 103, now(), ''),
  (602, '000000', 2, '土方开挖及基坑支护阶段', '2', 'project_progress', '', '', 'N', 103, now(), ''),
  (603, '000000', 3, '基础施工阶段', '3', 'project_progress', '', '', 'N', 103, now(), ''),
  (604, '000000', 4, '总体结构 1/2 前阶段', '4', 'project_progress', '', '', 'N', 103, now(), ''),
  (605, '000000', 5, '总体结构 1/2 后阶段', '5', 'project_progress', '', '', 'N', 103, now(), ''),
  (606, '000000', 6, '装饰安装阶段', '6', 'project_progress', '', '', 'N', 103, now(), ''),
  (607, '000000', 7, '竣工预验阶段', '7', 'project_progress', '', '', 'N', 103, now(), ''),
  (608, '000000', 8, '停工', '8', 'project_progress', '', '', 'N', 103, now(), '');

-- 有无填报字典
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (202, '000000', '有无填报', 'has_report', 103, now(), '建材填报管理-工程项目-有无填报')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (609, '000000', 1, '有', '1', 'has_report', '', '', 'N', 103, now(), ''),
  (610, '000000', 2, '无', '2', 'has_report', '', '', 'N', 103, now(), '');

-- 是否对接一体化平台编码字典
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (203, '000000', '是否对接一体化平台编码', 'is_integrated', 103, now(), '建材填报管理-工程项目-是否对接一体化平台编码')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (611, '000000', 1, '是', '1', 'is_integrated', '', '', 'N', 103, now(), ''),
  (612, '000000', 2, '否', '2', 'is_integrated', '', '', 'N', 103, now(), '');

-- 工程性质字典（数据来源待确认）
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (204, '000000', '工程性质', 'project_nature', 103, now(), '建材填报管理-工程项目-工程性质')
ON CONFLICT (dict_id) DO NOTHING;

-- 工程结构型式字典（数据来源待确认）
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (205, '000000', '工程结构型式', 'project_structure', 103, now(), '建材填报管理-工程项目-工程结构型式')
ON CONFLICT (dict_id) DO NOTHING;

-- ============== 建材产品字典 ==============

-- 信息确认状态
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (301, '000000', '信息确认状态', 'info_confirm_status', 103, now(), '建材填报管理-建材产品-信息确认状态')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (701, '000000', 1, '待信息确认', '0', 'info_confirm_status', '', 'warning', 'Y', 103, now(), ''),
  (702, '000000', 2, '信息确认通过', '1', 'info_confirm_status', '', 'success', 'N', 103, now(), ''),
  (703, '000000', 3, '信息确认不通过', '2', 'info_confirm_status', '', 'danger', 'N', 103, now(), ''),
  (704, '000000', 4, '待再次信息确认', '3', 'info_confirm_status', '', 'warning', 'N', 103, now(), ''),
  (705, '000000', 5, '信息确认再次不通过', '4', 'info_confirm_status', '', 'danger', 'N', 103, now(), '');

-- 信息确认超时
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (302, '000000', '信息确认超时', 'info_confirm_timeout', 103, now(), '建材填报管理-建材产品-信息确认超时')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (706, '000000', 1, '是', '1', 'info_confirm_timeout', '', 'danger', 'N', 103, now(), ''),
  (707, '000000', 2, '否', '2', 'info_confirm_timeout', '', 'success', 'N', 103, now(), '');

-- 信息确认不通过类别
-- 注意：运行时字典类型以 shbtgyylb 为准；
-- t_project_product 历史业务数据中仍可能直接保存旧 base_dictionarydata.id，前端展示需兼容两种口径。
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (303, '000000', '信息确认不通过类别', 'shbtgyylb', 103, now(), '建材填报管理-建材产品-信息确认不通过类别')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (708, '000000', 1, '资料不全（不符）', '1', 'shbtgyylb', '', '', 'N', 103, now(), ''),
  (709, '000000', 2, '疑似假冒', '2', 'shbtgyylb', '', '', 'N', 103, now(), ''),
  (710, '000000', 3, '采购数量不符', '3', 'shbtgyylb', '', '', 'N', 103, now(), ''),
  (711, '000000', 4, '品牌填写错误', '4', 'shbtgyylb', '', '', 'N', 103, now(), ''),
  (712, '000000', 5, '填报规格与实际供货规格不符', '5', 'shbtgyylb', '', '', 'N', 103, now(), ''),
  (713, '000000', 6, '图片清晰度不够，无法辨识', '6', 'shbtgyylb', '', '', 'N', 103, now(), ''),
  (714, '000000', 7, '其他', '7', 'shbtgyylb', '', '', 'N', 103, now(), '');

-- 信息确认单位
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (306, '000000', '信息确认单位', 'info_confirm_unit_type', 103, now(), '建材填报管理-建材产品-信息确认单位')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (720, '000000', 1, '生产单位', '1', 'info_confirm_unit_type', '', '', 'N', 103, now(), ''),
  (721, '000000', 2, '监理单位', '2', 'info_confirm_unit_type', '', '', 'N', 103, now(), '');

-- 有无备案证号
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (304, '000000', '有无备案证号', 'has_certificate_number', 103, now(), '建材填报管理-建材产品-有无备案证号')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (715, '000000', 1, '有', '1', 'has_certificate_number', '', 'success', 'N', 103, now(), ''),
  (716, '000000', 2, '无', '0', 'has_certificate_number', '', 'danger', 'N', 103, now(), '');

-- 建材产品工程进度
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (305, '000000', '建材产品工程进度', 'product_project_progress', 103, now(), '建材填报管理-建材产品-工程进度')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (717, '000000', 1, '工程安装阶段', '1', 'product_project_progress', '', '', 'N', 103, now(), ''),
  (718, '000000', 2, '测试1', '2', 'product_project_progress', '', '', 'N', 103, now(), ''),
  (719, '000000', 3, '测试2', '3', 'product_project_progress', '', '', 'N', 103, now(), '');
