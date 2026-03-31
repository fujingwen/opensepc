-- ============================================================
-- 清理旧的建材模块手动字典数据
-- 删除 master.sys_dict_type 中 dict_id 在 201-305 范围的记录
-- 以及对应的 master.sys_dict_data 数据
-- ============================================================

-- 先删除关联的字典数据
DELETE FROM master.sys_dict_data
WHERE dict_type IN (
    SELECT dict_type FROM master.sys_dict_type
    WHERE dict_id >= 201 AND dict_id <= 305
);

-- 再删除字典类型
DELETE FROM master.sys_dict_type
WHERE dict_id >= 201 AND dict_id <= 305;
