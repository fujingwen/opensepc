-- Dictionary SQL for Quality Trace Module

INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (2029132000000000201, '000000', '有无对比数据', 'quality_trace_compare_flag', 1, now(), '质量追溯-有无对比数据'),
  (2029132000000000202, '000000', '复检状态', 'quality_trace_recheck_status', 1, now(), '质量追溯-复检状态'),
  (2029132000000000203, '000000', '闭环状态', 'quality_trace_closed_loop', 1, now(), '质量追溯-闭环状态')
ON CONFLICT (dict_id) DO NOTHING;

INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (2029132000000000301, '000000', 1, '有', '1', 'quality_trace_compare_flag', '', '', 'N', 1, now(), ''),
  (2029132000000000302, '000000', 2, '无', '0', 'quality_trace_compare_flag', '', '', 'N', 1, now(), ''),
  (2029132000000000303, '000000', 1, '是', '1', 'quality_trace_recheck_status', '', 'success', 'N', 1, now(), ''),
  (2029132000000000304, '000000', 2, '否', '0', 'quality_trace_recheck_status', '', 'danger', 'N', 1, now(), ''),
  (2029132000000000305, '000000', 1, '已闭环', '1', 'quality_trace_closed_loop', '', 'success', 'N', 1, now(), ''),
  (2029132000000000306, '000000', 2, '未闭环', '0', 'quality_trace_closed_loop', '', 'warning', 'N', 1, now(), '')
ON CONFLICT (dict_code) DO NOTHING;
