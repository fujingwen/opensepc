-- ----------------------------
-- Migration: Remove enterprise fields from sys_user table
-- Description: Remove enterprise-related fields from sys_user table as they are now stored in base_production and base_construction tables
-- Date: 2026-03-09
-- ----------------------------

-- Remove columns from sys_user table
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS contact_person;
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS province_code;
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS province_name;
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS city_code;
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS city_name;
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS district_code;
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS district_name;
ALTER TABLE master.sys_user DROP COLUMN IF EXISTS address;

-- Note: This migration removes the enterprise-related fields from sys_user table.
-- These fields are now stored in base_production and base_construction tables.
-- Existing user data in these fields will be lost, but according to requirements,
-- we only need to handle new users. Existing users do not need data migration.
