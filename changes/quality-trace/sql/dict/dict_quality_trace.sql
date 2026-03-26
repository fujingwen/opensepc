-- ----------------------------
-- Dictionary SQL for Quality Trace Module
-- ----------------------------

-- Add unique constraint on dict_id if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'sys_dict_type_dict_id_key'
    ) THEN
        ALTER TABLE "master"."sys_dict_type"
        ADD CONSTRAINT sys_dict_type_dict_id_key UNIQUE (dict_id);
    END IF;
END $$;

-- 字典类型：有无对比数据
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (220, '000000', '有无对比数据', 'quality_trace_check_data', 103, now(), '质量追溯-抽测缺陷建材产品-有无对比数据')
ON CONFLICT (dict_id) DO NOTHING;

-- 字典数据：有
INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (660, '000000', 1, '有', '1', 'quality_trace_check_data', '', '', 'N', 103, now(), '有对比数据'),
  (661, '000000', 2, '无', '2', 'quality_trace_check_data', '', '', 'N', 103, now(), '无对比数据')
ON CONFLICT (dict_code) DO NOTHING;

-- 字典类型：结论
INSERT INTO "master"."sys_dict_type" (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
VALUES
  (221, '000000', '结论', 'quality_trace_conclusion', 103, now(), '质量追溯-抽测缺陷建材产品-结论')
ON CONFLICT (dict_id) DO NOTHING;

-- 字典数据：合格
INSERT INTO "master"."sys_dict_data" (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
VALUES
  (662, '000000', 1, '合格', '1', 'quality_trace_conclusion', '', '', 'N', 103, now(), '合格'),
  (663, '000000', 2, '不合格', '2', 'quality_trace_conclusion', '', '', 'N', 103, now(), '不合格')
ON CONFLICT (dict_code) DO NOTHING;