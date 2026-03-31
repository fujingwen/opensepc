-- ============================================================
-- 字典类型迁移：test.base_dictionarytype → master.sys_dict_type
-- 条件：F_IsTree = 0 且未删除
-- ============================================================

-- 创建临时序列用于生成新 dict_id
-- 起始值避开现有最大值 2034535000000000005
CREATE SEQUENCE IF NOT EXISTS tmp_dict_type_id_seq
    START WITH 2034535000000010001
    INCREMENT BY 1;

CREATE SEQUENCE IF NOT EXISTS tmp_dict_data_code_seq
    START WITH 2034535000000020001
    INCREMENT BY 1;

-- 迁移字典类型
INSERT INTO master.sys_dict_type (
    dict_id,
    tenant_id,
    dict_name,
    dict_type,
    create_dept,
    create_by,
    create_time,
    remark
)
SELECT
    nextval('tmp_dict_type_id_seq') AS dict_id,
    '000000' AS tenant_id,
    t."F_FullName" AS dict_name,
    t."F_EnCode" AS dict_type,
    103 AS create_dept,
    1 AS create_by,
    now() AS create_time,
    COALESCE(t."F_Description", '') AS remark
FROM test.base_dictionarytype t
WHERE COALESCE(t."F_DeleteMark", 0) = 0
  AND t."F_IsTree" = 0
  -- 排除已存在的同 dict_type（安全保护）
  AND NOT EXISTS (
      SELECT 1 FROM master.sys_dict_type s WHERE s.dict_type = t."F_EnCode"
  );

-- ============================================================
-- 字典数据迁移：test.base_dictionarydata → master.sys_dict_data
-- 条件：关联的字典类型为非树形且已迁移
-- ============================================================

INSERT INTO master.sys_dict_data (
    dict_code,
    tenant_id,
    dict_sort,
    dict_label,
    dict_value,
    dict_type,
    css_class,
    list_class,
    is_default,
    create_dept,
    create_by,
    create_time,
    remark
)
SELECT
    nextval('tmp_dict_data_code_seq') AS dict_code,
    '000000' AS tenant_id,
    COALESCE(d."F_SortCode", 0) AS dict_sort,
    d."F_FullName" AS dict_label,
    d."F_EnCode" AS dict_value,
    pt."F_EnCode" AS dict_type,
    '' AS css_class,
    '' AS list_class,
    CASE WHEN COALESCE(d."F_IsDefault", 0) = 1 THEN 'Y' ELSE 'N' END AS is_default,
    103 AS create_dept,
    1 AS create_by,
    now() AS create_time,
    COALESCE(d."F_Description", '') AS remark
FROM test.base_dictionarydata d
INNER JOIN test.base_dictionarytype pt
    ON d."F_DictionaryTypeId" = pt."F_Id"
WHERE COALESCE(d."F_DeleteMark", 0) = 0
  AND COALESCE(pt."F_DeleteMark", 0) = 0
  AND pt."F_IsTree" = 0
  -- 只迁移已成功写入 sys_dict_type 的类型对应的数据
  AND EXISTS (
      SELECT 1 FROM master.sys_dict_type s WHERE s.dict_type = pt."F_EnCode"
  );

-- 清理临时序列
DROP SEQUENCE IF EXISTS tmp_dict_type_id_seq;
DROP SEQUENCE IF EXISTS tmp_dict_data_code_seq;
