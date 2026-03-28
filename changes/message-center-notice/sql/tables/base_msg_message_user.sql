DROP TABLE IF EXISTS "master"."msg_message_user";
CREATE TABLE "master"."msg_message_user" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_msg_message_user'),
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "message_id" bigint NOT NULL,
  "receiver_user_id" bigint NOT NULL,
  "receiver_name" varchar(100),
  "read_status" varchar(20) NOT NULL DEFAULT 'unread',
  "read_time" timestamp,
  "create_dept" bigint,
  "create_by" bigint,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp NOT NULL DEFAULT now(),
  "del_flag" char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);

COMMENT ON TABLE "master"."msg_message_user" IS '消息通知接收表';
COMMENT ON COLUMN "master"."msg_message_user"."id" IS '主键ID';
COMMENT ON COLUMN "master"."msg_message_user"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."msg_message_user"."message_id" IS '消息ID';
COMMENT ON COLUMN "master"."msg_message_user"."receiver_user_id" IS '接收人用户ID';
COMMENT ON COLUMN "master"."msg_message_user"."receiver_name" IS '接收人名称';
COMMENT ON COLUMN "master"."msg_message_user"."read_status" IS '已读状态(unread/read)';
COMMENT ON COLUMN "master"."msg_message_user"."read_time" IS '已读时间';
COMMENT ON COLUMN "master"."msg_message_user"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."msg_message_user"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."msg_message_user"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."msg_message_user"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."msg_message_user"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."msg_message_user"."del_flag" IS '删除标记(0存在 1删除)';
