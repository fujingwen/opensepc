-- 将历史空删除标记统一标准化为 0

UPDATE master.t_companyinfo
SET del_flag = 0
WHERE del_flag IS NULL;

SELECT del_flag, COUNT(*) AS cnt
FROM master.t_companyinfo
GROUP BY del_flag
ORDER BY del_flag;
