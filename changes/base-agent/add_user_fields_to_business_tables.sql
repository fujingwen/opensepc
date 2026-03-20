-- ----------------------------
-- Migration: Add user_id to base_production and base_construction tables
-- Description: Add user_id column to support new data architecture
-- Date: 2026-03-09
-- ----------------------------

-- Add columns to base_production table
ALTER TABLE master.base_production ADD COLUMN IF NOT EXISTS user_id bigint;

-- Add columns to base_construction table
ALTER TABLE master.base_construction ADD COLUMN IF NOT EXISTS user_id bigint;

-- Note: Unique constraint uk_user_id already exists on both tables, skipping constraint creation

-- Add column comments for base_production
COMMENT ON COLUMN master.base_production.user_id IS '关联用户ID';

-- Add column comments for base_construction
COMMENT ON COLUMN master.base_construction.user_id IS '关联用户ID';
