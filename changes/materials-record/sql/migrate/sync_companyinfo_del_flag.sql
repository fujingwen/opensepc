-- 将历史 enabled_mark 删除语义统一映射到 del_flag
-- 当前约定：del_flag = 0 未删除，del_flag = 2 删除
-- 本脚本仅处理生产企业（company_type = 2）

UPDATE master.t_companyinfo
SET del_flag = CASE
                   WHEN COALESCE(enabled_mark, 1) = 0 THEN 2
                   ELSE 0
               END
WHERE company_type = 2
  AND (
      del_flag IS NULL
      OR del_flag NOT IN (0, 2)
      OR (COALESCE(enabled_mark, 1) = 0 AND del_flag <> 2)
      OR (COALESCE(enabled_mark, 1) <> 0 AND del_flag <> 0)
  );

-- 校验映射结果
SELECT company_type,
       enabled_mark,
       del_flag,
       COUNT(1) AS total
FROM master.t_companyinfo
WHERE company_type = 2
GROUP BY company_type, enabled_mark, del_flag
ORDER BY enabled_mark, del_flag;
