-- ----------------------------
-- Runtime dictionary repair for materials-project-product
-- 1. 修正信息确认不通过类别字典类型漂移
-- 2. 回填信息确认单位字典缺失明细
-- 注意：执行后需清理对应字典缓存（如 Redis `sys_dict` 中的 `shbtgyylb`、`info_confirm_unit_type`）
-- ----------------------------

-- 确保信息确认不通过类别字典类型存在
INSERT INTO "master"."sys_dict_type" (
  dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark
)
SELECT 303, '000000', '信息确认不通过类别', 'shbtgyylb', 103, now(), '建材填报管理-建材产品-信息确认不通过类别'
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."sys_dict_type" WHERE dict_type = 'shbtgyylb'
);

-- 修正误写成 info_confirm_fail_type 的运行时字典
UPDATE "master"."sys_dict_data"
SET dict_type = 'shbtgyylb'
WHERE dict_type = 'info_confirm_fail_type'
  AND dict_label IN (
    '资料不全（不符）',
    '疑似假冒',
    '采购数量不符',
    '品牌填写错误',
    '填报规格与实际供货规格不符',
    '图片清晰度不够，无法辨识',
    '其他'
  );

-- 确保信息确认单位字典类型存在
INSERT INTO "master"."sys_dict_type" (
  dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark
)
SELECT 306, '000000', '信息确认单位', 'info_confirm_unit_type', 103, now(), '建材填报管理-建材产品-信息确认单位'
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."sys_dict_type" WHERE dict_type = 'info_confirm_unit_type'
);

-- 回填信息确认单位字典明细：1=生产单位
INSERT INTO "master"."sys_dict_data" (
  dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type,
  css_class, list_class, is_default, create_by, create_time, remark
)
SELECT
  720, '000000', 1, '生产单位', '1', 'info_confirm_unit_type',
  '', '', 'N', 103, now(), ''
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_data"
  WHERE dict_type = 'info_confirm_unit_type'
    AND dict_value = '1'
);

-- 回填信息确认单位字典明细：2=监理单位
INSERT INTO "master"."sys_dict_data" (
  dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type,
  css_class, list_class, is_default, create_by, create_time, remark
)
SELECT
  721, '000000', 2, '监理单位', '2', 'info_confirm_unit_type',
  '', '', 'N', 103, now(), ''
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_data"
  WHERE dict_type = 'info_confirm_unit_type'
    AND dict_value = '2'
);
