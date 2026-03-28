DROP TABLE IF EXISTS "master"."msg_message";
CREATE TABLE "master"."msg_message" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_msg_message'),
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "title" varchar(200) NOT NULL,
  "content" text NOT NULL,
  "message_type" varchar(20) NOT NULL DEFAULT 'message',
  "business_type" varchar(20) NOT NULL DEFAULT 'manual',
  "sender_id" bigint NOT NULL,
  "sender_name" varchar(100),
  "send_time" timestamp NOT NULL DEFAULT now(),
  "create_dept" bigint,
  "create_by" bigint,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp NOT NULL DEFAULT now(),
  "del_flag" char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);

COMMENT ON TABLE "master"."msg_message" IS '消息通知主表';
COMMENT ON COLUMN "master"."msg_message"."id" IS '主键ID';
COMMENT ON COLUMN "master"."msg_message"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."msg_message"."title" IS '标题';
COMMENT ON COLUMN "master"."msg_message"."content" IS '内容';
COMMENT ON COLUMN "master"."msg_message"."message_type" IS '消息类型(message/warning)';
COMMENT ON COLUMN "master"."msg_message"."business_type" IS '业务类型(manual/audit/timeout)';
COMMENT ON COLUMN "master"."msg_message"."sender_id" IS '发送人用户ID';
COMMENT ON COLUMN "master"."msg_message"."sender_name" IS '发送人名称';
COMMENT ON COLUMN "master"."msg_message"."send_time" IS '发送时间';
COMMENT ON COLUMN "master"."msg_message"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."msg_message"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."msg_message"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."msg_message"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."msg_message"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."msg_message"."del_flag" IS '删除标记(0存在 1删除)';
