CREATE INDEX IF NOT EXISTS "idx_product_relation_product_id"
  ON "master"."t_product_relation" ("product_id");

CREATE INDEX IF NOT EXISTS "idx_product_relation_quality_trace_id"
  ON "master"."t_product_relation" ("quality_trace_id");

CREATE INDEX IF NOT EXISTS "idx_product_relation_hidden_flag"
  ON "master"."t_product_relation" ("hidden_flag");
