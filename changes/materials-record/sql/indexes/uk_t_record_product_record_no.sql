-- 备案证号严格唯一约束
-- 执行前请先清理 master.t_record_product 中已存在的重复未删除 record_no

-- 预检查重复数据
SELECT record_no, COUNT(1) AS duplicate_count
FROM master.t_record_product
WHERE COALESCE(del_flag, 0) = 0
GROUP BY record_no
HAVING COUNT(1) > 1;

-- 清理完成后再执行唯一索引
CREATE UNIQUE INDEX IF NOT EXISTS uk_t_record_product_record_no_active
    ON master.t_record_product(record_no)
    WHERE COALESCE(del_flag, 0) = 0;
