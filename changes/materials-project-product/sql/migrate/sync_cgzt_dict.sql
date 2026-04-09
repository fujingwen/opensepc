-- ----------------------------
-- Runtime dictionary repair for cgzt
-- 采购主体字典补齐
-- 来源：旧库字典 cgzt
-- 1. 建设单位 -> jsdw
-- 2. 施工单位 -> sgjthfgs
-- 3. 分包单位 -> fbdw
-- 执行后请清理对应字典缓存（如 Redis `sys_dict` 中的 `cgzt`）
-- ----------------------------

INSERT INTO "master"."sys_dict_type" (
  dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark
)
SELECT 307, '000000', '采购主体', 'cgzt', 103, now(), '建材填报管理-建材产品-采购主体'
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."sys_dict_type" WHERE dict_type = 'cgzt'
);

INSERT INTO "master"."sys_dict_data" (
  dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type,
  css_class, list_class, is_default, create_by, create_time, remark
)
SELECT
  722, '000000', 1, '建设单位', 'jsdw', 'cgzt',
  '', '', 'N', 103, now(), ''
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_data"
  WHERE dict_type = 'cgzt'
    AND dict_value = 'jsdw'
);

INSERT INTO "master"."sys_dict_data" (
  dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type,
  css_class, list_class, is_default, create_by, create_time, remark
)
SELECT
  723, '000000', 2, '施工单位', 'sgjthfgs', 'cgzt',
  '', '', 'N', 103, now(), ''
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_data"
  WHERE dict_type = 'cgzt'
    AND dict_value = 'sgjthfgs'
);

INSERT INTO "master"."sys_dict_data" (
  dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type,
  css_class, list_class, is_default, create_by, create_time, remark
)
SELECT
  724, '000000', 3, '分包单位', 'fbdw', 'cgzt',
  '', '', 'N', 103, now(), ''
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_data"
  WHERE dict_type = 'cgzt'
    AND dict_value = 'fbdw'
);
