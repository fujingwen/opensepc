-- 备案产品管理表索引
-- 主键索引已在 CREATE TABLE 时创建

-- 备案证号索引
CREATE INDEX IF NOT EXISTS idx_t_record_product_record_no ON master.t_record_product(record_no);

-- 删除标志索引
CREATE INDEX IF NOT EXISTS idx_t_record_product_del_flag ON master.t_record_product(del_flag);

-- 租户ID索引
CREATE INDEX IF NOT EXISTS idx_t_record_product_tenant_id ON master.t_record_product(tenant_id);

-- 备案产品名称索引（用于模糊搜索）
CREATE INDEX IF NOT EXISTS idx_t_record_product_name ON master.t_record_product(record_product_name);

-- 生产厂家索引
CREATE INDEX IF NOT EXISTS idx_t_record_product_manufactur ON master.t_record_product(manufactur);
