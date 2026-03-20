-- ----------------------------
-- Dictionary Data for Engineering Project Module
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
