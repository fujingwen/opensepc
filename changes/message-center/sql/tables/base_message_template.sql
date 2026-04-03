DROP TABLE IF EXISTS "master"."base_message_template";
CREATE TABLE "master"."base_message_template" (
  "id" varchar(50) NOT NULL,
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "category" varchar(50),
  "full_name" varchar(50) NOT NULL,
  "title" varchar(200) NOT NULL,
  "is_station_letter" integer DEFAULT 0,
  "is_email" integer DEFAULT 0,
  "is_we_com" integer DEFAULT 0,
  "is_ding_talk" integer DEFAULT 0,
  "is_sms" integer DEFAULT 0,
  "sms_id" varchar(50),
  "template_json" text,
  "content" text,
  "enabled_mark" integer DEFAULT 1,
  "create_dept" bigint,
  "create_by" bigint,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp NOT NULL DEFAULT now(),
  "del_flag" char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);

COMMENT ON TABLE "master"."base_message_template" IS '消息模板表';
