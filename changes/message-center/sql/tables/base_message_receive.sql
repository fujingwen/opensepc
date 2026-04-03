DROP TABLE IF EXISTS "master"."base_message_receive";
CREATE TABLE "master"."base_message_receive" (
  "id" varchar(50) NOT NULL,
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "message_id" varchar(50),
  "title" varchar(200) NOT NULL,
  "content" text,
  "message_type" varchar(20) NOT NULL DEFAULT 'warning',
  "business_type" varchar(20) NOT NULL DEFAULT 'manual',
  "sender_id" varchar(50),
  "sender_name" varchar(100),
  "receiver_user_id" varchar(50) NOT NULL,
  "receiver_name" varchar(100),
  "source_business_id" varchar(50),
  "legacy_type" integer,
  "read_status" varchar(20) NOT NULL DEFAULT 'unread',
  "read_time" timestamp,
  "read_count" integer NOT NULL DEFAULT 0,
  "send_time" timestamp NOT NULL DEFAULT now(),
  "create_dept" bigint,
  "create_by" bigint,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp NOT NULL DEFAULT now(),
  "del_flag" char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);

COMMENT ON TABLE "master"."base_message_receive" IS '消息收件箱表';
COMMENT ON COLUMN "master"."base_message_receive"."message_id" IS '人工消息主记录ID';
COMMENT ON COLUMN "master"."base_message_receive"."source_business_id" IS '外部业务来源ID';
COMMENT ON COLUMN "master"."base_message_receive"."legacy_type" IS '旧系统消息类型值';
