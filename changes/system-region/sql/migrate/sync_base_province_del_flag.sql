-- 统一 base_province 删除标记语义
-- 当前口径：del_flag = 0 正常，del_flag = 2 删除

UPDATE master.base_province
SET del_flag = CASE
    WHEN COALESCE(delete_mark, 0) = 1 THEN 2
    ELSE 0
END
WHERE del_flag IS NULL
   OR del_flag NOT IN (0, 2)
   OR (COALESCE(delete_mark, 0) = 1 AND del_flag <> 2)
   OR (COALESCE(delete_mark, 0) <> 1 AND del_flag <> 0);

SELECT del_flag, COUNT(*) AS cnt
FROM master.base_province
GROUP BY del_flag
ORDER BY del_flag;
