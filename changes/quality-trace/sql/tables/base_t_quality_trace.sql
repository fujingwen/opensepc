-- Quality trace table supplement SQL
-- The real table already exists in master. This SQL is used to document
-- the expected target structure and add missing runtime columns only.

ALTER TABLE "master"."t_quality_trace"
  ADD COLUMN IF NOT EXISTS "recheck_status" integer DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "recheck_remark" varchar(1000),
  ADD COLUMN IF NOT EXISTS "recheck_attachment" varchar(500),
  ADD COLUMN IF NOT EXISTS "recheck_time" timestamp(0),
  ADD COLUMN IF NOT EXISTS "recheck_by" varchar(50);
