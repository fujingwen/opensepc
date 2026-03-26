-- ----------------------------
-- Indexes for t_quality_trace
-- ----------------------------

-- 租户ID索引
CREATE INDEX "idx_quality_trace_tenant_id" ON "master"."t_quality_trace" ("tenant_id");

-- 产品名称索引（用于模糊查询）
CREATE INDEX "idx_quality_trace_product_name" ON "master"."t_quality_trace" ("product_name");

-- 生产厂家索引
CREATE INDEX "idx_quality_trace_factory_name" ON "master"."t_quality_trace" ("factory_name");

-- 生产批号索引
CREATE INDEX "idx_quality_trace_batch" ON "master"."t_quality_trace" ("batch");

-- 检测时间索引（用于日期范围查询）
CREATE INDEX "idx_quality_trace_check_time" ON "master"."t_quality_trace" ("check_time");

-- 删除标记索引
CREATE INDEX "idx_quality_trace_del_flag" ON "master"."t_quality_trace" ("del_flag");