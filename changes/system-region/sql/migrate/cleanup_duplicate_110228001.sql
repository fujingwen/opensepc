-- 清理 en_code='110228001' 的重复活动数据
-- 保留 id='110228001' 为唯一活动记录，其余重复记录按逻辑删除处理

UPDATE master.base_province
SET del_flag = 2,
    delete_time = COALESCE(delete_time, NOW()),
    delete_user_id = COALESCE(delete_user_id, 'system-region-fix')
WHERE en_code = '110228001'
  AND id <> '110228001'
  AND COALESCE(del_flag, 0) = 0;

SELECT id, en_code, full_name, del_flag
FROM master.base_province
WHERE en_code = '110228001'
ORDER BY id;
