-- 修复 create_by 类型问题：更新现有数据
-- 执行此脚本修复 PostgreSQL 类型错误

-- 查看当前 create_by 的值
SELECT id, record_product_name, create_by, update_by
FROM master.t_record_product
WHERE create_by IS NOT NULL;

-- 将 create_by 修复为 '1'（根据实际业务需求调整）
UPDATE master.t_record_product SET create_by = '1' WHERE create_by IS NOT NULL;

-- 将 update_by 修复为 '1'
UPDATE master.t_record_product SET update_by = '1' WHERE update_by IS NOT NULL;

-- 验证修复结果
SELECT id, record_product_name, create_by, update_by
FROM master.t_record_product
LIMIT 10;
