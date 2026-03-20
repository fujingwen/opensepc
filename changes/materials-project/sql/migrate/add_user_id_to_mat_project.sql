-- ----------------------------
-- Migration: Fix mat_project table structure
-- Date: 2026-03-10
-- Description: Add missing columns and fix data types for mat_project table
-- ----------------------------

-- Add tenant_id column to mat_project table
ALTER TABLE "master"."mat_project" ADD COLUMN "tenant_id" varchar(20);

-- Add create_dept column to mat_project table
ALTER TABLE "master"."mat_project" ADD COLUMN "create_dept" bigint;

-- Add user_id column to mat_project table
ALTER TABLE "master"."mat_project" ADD COLUMN "user_id" bigint;

-- Add column comments
COMMENT ON COLUMN "master"."mat_project"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."mat_project"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."mat_project"."user_id" IS '施工单位用户ID';

-- Fix data types for create_by and update_by (should be bigint instead of varchar)
ALTER TABLE "master"."mat_project" ALTER COLUMN "create_by" TYPE bigint USING create_by::bigint;
ALTER TABLE "master"."mat_project" ALTER COLUMN "update_by" TYPE bigint USING update_by::bigint;
