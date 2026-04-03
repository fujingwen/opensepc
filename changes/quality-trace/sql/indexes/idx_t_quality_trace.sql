-- Indexes for t_quality_trace

CREATE INDEX IF NOT EXISTS "idx_quality_trace_project_name"
  ON "master"."t_quality_trace" ("project_name");

CREATE INDEX IF NOT EXISTS "idx_quality_trace_product_name"
  ON "master"."t_quality_trace" ("product_name");

CREATE INDEX IF NOT EXISTS "idx_quality_trace_factory_name"
  ON "master"."t_quality_trace" ("factory_name");

CREATE INDEX IF NOT EXISTS "idx_quality_trace_batch_no"
  ON "master"."t_quality_trace" ("batch_no");

CREATE INDEX IF NOT EXISTS "idx_quality_trace_check_time"
  ON "master"."t_quality_trace" ("check_time");

CREATE INDEX IF NOT EXISTS "idx_quality_trace_del_flag"
  ON "master"."t_quality_trace" ("del_flag");
