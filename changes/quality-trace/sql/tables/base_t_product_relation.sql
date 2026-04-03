-- Product relation table for quality trace

CREATE TABLE IF NOT EXISTS "master"."t_product_relation" (
  "id" varchar(50) NOT NULL,
  "tenant_id" varchar(50) NOT NULL DEFAULT '000000',
  "product_id" varchar(50) NOT NULL,
  "legacy_check_product_id" varchar(50),
  "quality_trace_id" varchar(50),
  "status" integer NOT NULL DEFAULT 1,
  "hidden_flag" integer NOT NULL DEFAULT 0,
  "hidden_by" varchar(50),
  "hidden_time" timestamp(0),
  "create_by" varchar(50),
  "create_time" timestamp(0),
  "update_by" varchar(50),
  "update_time" timestamp(0),
  "del_flag" integer NOT NULL DEFAULT 0,
  "create_dept" varchar(50) NOT NULL DEFAULT '103',
  PRIMARY KEY ("id")
);
