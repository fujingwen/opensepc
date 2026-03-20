-- ----------------------------
-- Migration: Add tenant_id to mat_product table
-- Date: 2026-03-13
-- Description: Add tenant_id column to mat_product table for multi-tenant support
-- ----------------------------

-- Add tenant_id column to mat_product table
ALTER TABLE "master"."mat_product" ADD COLUMN IF NOT EXISTS "tenant_id" varchar(20) DEFAULT '000000';

-- Add index for tenant_id
DROP INDEX IF EXISTS "master"."idx_product_tenant_id";
CREATE INDEX "idx_product_tenant_id" ON "master"."mat_product" ("tenant_id");

-- Add column comment
COMMENT ON COLUMN "master"."mat_product"."tenant_id" IS '租户编号';
