-- ----------------------------
-- Database Indexes for Basic Data Module
-- ----------------------------

-- 生产企业表索引
CREATE INDEX idx_production_enterprise_name ON "master"."base_production"("enterprise_name");
CREATE INDEX idx_production_enterprise_credit_code ON "master"."base_production"("credit_code");
CREATE INDEX idx_production_enterprise_province ON "master"."base_production"("province_code");
CREATE INDEX idx_production_enterprise_city ON "master"."base_production"("city_code");
CREATE INDEX idx_production_enterprise_district ON "master"."base_production"("district_code");
CREATE INDEX idx_production_enterprise_status ON "master"."base_production"("status");
CREATE INDEX idx_production_enterprise_tenant ON "master"."base_production"("tenant_id");

-- 施工企业表索引
CREATE INDEX idx_construction_enterprise_name ON "master"."base_construction"("enterprise_name");
CREATE INDEX idx_construction_enterprise_credit_code ON "master"."base_construction"("credit_code");
CREATE INDEX idx_construction_enterprise_province ON "master"."base_construction"("province_code");
CREATE INDEX idx_construction_enterprise_city ON "master"."base_construction"("city_code");
CREATE INDEX idx_construction_enterprise_district ON "master"."base_construction"("district_code");
CREATE INDEX idx_construction_enterprise_status ON "master"."base_construction"("status");
CREATE INDEX idx_construction_enterprise_tenant ON "master"."base_construction"("tenant_id");

-- 代理商表索引
CREATE INDEX idx_agent_name ON "master"."base_agent"("agent_name");
CREATE INDEX idx_agent_production_enterprise_id ON "master"."base_agent"("production_enterprise_id");
CREATE INDEX idx_agent_user_account ON "master"."base_agent"("user_account");
CREATE INDEX idx_agent_province ON "master"."base_agent"("province_code");
CREATE INDEX idx_agent_city ON "master"."base_agent"("city_code");
CREATE INDEX idx_agent_district ON "master"."base_agent"("district_code");
CREATE INDEX idx_agent_status ON "master"."base_agent"("status");
CREATE INDEX idx_agent_tenant ON "master"."base_agent"("tenant_id");

-- 省市区表索引
CREATE UNIQUE INDEX idx_region_code ON "master"."base_region"("region_code");
CREATE INDEX idx_region_parent_code ON "master"."base_region"("parent_code");
CREATE INDEX idx_region_level ON "master"."base_region"("region_level");
CREATE INDEX idx_region_status ON "master"."base_region"("status");
CREATE INDEX idx_region_tenant ON "master"."base_region"("tenant_id");

-- 组合索引优化常用查询
CREATE INDEX idx_production_enterprise_province_city ON "master"."base_production"("province_code", "city_code");
CREATE INDEX idx_construction_enterprise_province_city ON "master"."base_construction"("province_code", "city_code");
CREATE INDEX idx_agent_province_city ON "master"."base_agent"("province_code", "city_code");
CREATE INDEX idx_region_parent_level ON "master"."base_region"("parent_code", "region_level");