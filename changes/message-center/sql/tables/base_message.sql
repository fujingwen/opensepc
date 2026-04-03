DROP TABLE IF EXISTS "master"."base_message";
CREATE TABLE "master"."base_message" (
  "id" varchar(50) NOT NULL,
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "title" varchar(200) NOT NULL,
  "content" text NOT NULL,
  "message_type" varchar(20) NOT NULL DEFAULT 'message',
  "business_type" varchar(20) NOT NULL DEFAULT 'manual',
  "receiver_user_ids" text,
  "sender_id" varchar(50),
  "sender_name" varchar(100),
  "priority_level" integer,
  "status" integer,
  "legacy_source" varchar(30),
  "legacy_type" integer,
  "remark" text,
  "sort_code" bigint,
  "enabled_mark" integer DEFAULT 1,
  "send_time" timestamp NOT NULL DEFAULT now(),
  "create_dept" bigint,
  "create_by" bigint,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp NOT NULL DEFAULT now(),
  "del_flag" char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);

COMMENT ON TABLE "master"."base_message" IS '消息发送主表';
COMMENT ON COLUMN "master"."base_message"."receiver_user_ids" IS '接收人用户ID集合，逗号分隔';
COMMENT ON COLUMN "master"."base_message"."legacy_source" IS '迁移来源表';
COMMENT ON COLUMN "master"."base_message"."legacy_type" IS '旧系统消息类型值';
