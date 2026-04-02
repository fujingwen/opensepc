-- ============================================================
-- 迁移前冲突检查
-- 说明：当前策略是不删除 master 中已有手动字典，只输出与待迁移编码冲突的记录供人工核查
-- ============================================================

-- 1. 检查字典类型编码冲突
SELECT
    'dict_type_conflict' AS conflict_type,
    s.dict_id::text AS target_id,
    s.dict_type,
    s.dict_name,
    s.remark
FROM master.sys_dict_type s
WHERE EXISTS (
    SELECT 1
    FROM test.base_dictionarytype t
    WHERE COALESCE(t."F_DeleteMark", 0) = 0
      AND t."F_IsTree" = 0
      AND t."F_EnCode" = s.dict_type
)
ORDER BY s.dict_type;

-- 2. 检查字典数据编码冲突
SELECT
    'dict_data_conflict' AS conflict_type,
    d.dict_code::text AS target_id,
    d.dict_type,
    d.dict_label,
    d.dict_value,
    d.remark
FROM master.sys_dict_data d
WHERE EXISTS (
    SELECT 1
    FROM test.base_dictionarydata sd
    JOIN test.base_dictionarytype st
      ON sd."F_DictionaryTypeId" = st."F_Id"
    WHERE COALESCE(sd."F_DeleteMark", 0) = 0
      AND COALESCE(st."F_DeleteMark", 0) = 0
      AND st."F_IsTree" = 0
      AND st."F_EnCode" = d.dict_type
      AND sd."F_EnCode" = d.dict_value
)
ORDER BY d.dict_type, d.dict_value;
