-- ----------------------------
-- Add create_dept column to all base tables
-- ----------------------------

-- Add create_dept to base_production_enterprise
ALTER TABLE "master"."base_production_enterprise" ADD COLUMN IF NOT EXISTS "create_dept" bigint;
COMMENT ON COLUMN "master"."base_production_enterprise"."create_dept" IS '创建部门';

-- Add create_dept to base_construction_enterprise
ALTER TABLE "master"."base_construction_enterprise" ADD COLUMN IF NOT EXISTS "create_dept" bigint;
COMMENT ON COLUMN "master"."base_construction_enterprise"."create_dept" IS '创建部门';

-- Add create_dept to base_agent
ALTER TABLE "master"."base_agent" ADD COLUMN IF NOT EXISTS "create_dept" bigint;
COMMENT ON COLUMN "master"."base_agent"."create_dept" IS '创建部门';

-- Add create_dept to base_region
ALTER TABLE "master"."base_region" ADD COLUMN IF NOT EXISTS "create_dept" bigint;
COMMENT ON COLUMN "master"."base_region"."create_dept" IS '创建部门';
