DROP TABLE IF EXISTS "master"."msg_notice_publish";
CREATE TABLE "master"."msg_notice_publish" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_msg_notice_publish'),
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "notice_type" varchar(20) NOT NULL,
  "title" varchar(200) NOT NULL,
  "content" text NOT NULL,
  "publisher_user_id" bigint NOT NULL,
  "publisher_name" varchar(100),
  "company_id" varchar(50),
  "company_name" varchar(200),
  "publish_status" varchar(20) NOT NULL DEFAULT 'published',
  "publish_time" timestamp NOT NULL DEFAULT now(),
  "create_dept" bigint,
  "create_by" bigint,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp NOT NULL DEFAULT now(),
  "del_flag" char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);

COMMENT ON TABLE "master"."msg_notice_publish" IS '通知公告发布表';
COMMENT ON COLUMN "master"."msg_notice_publish"."id" IS '主键ID';
COMMENT ON COLUMN "master"."msg_notice_publish"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."msg_notice_publish"."notice_type" IS '公告类型(system/inventory/purchase)';
COMMENT ON COLUMN "master"."msg_notice_publish"."title" IS '标题';
COMMENT ON COLUMN "master"."msg_notice_publish"."content" IS '正文内容';
COMMENT ON COLUMN "master"."msg_notice_publish"."publisher_user_id" IS '发布人用户ID';
COMMENT ON COLUMN "master"."msg_notice_publish"."publisher_name" IS '发布人名称';
COMMENT ON COLUMN "master"."msg_notice_publish"."company_id" IS '企业ID';
COMMENT ON COLUMN "master"."msg_notice_publish"."company_name" IS '企业名称';
COMMENT ON COLUMN "master"."msg_notice_publish"."publish_status" IS '发布状态(draft/published/closed)';
COMMENT ON COLUMN "master"."msg_notice_publish"."publish_time" IS '发布时间';
COMMENT ON COLUMN "master"."msg_notice_publish"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."msg_notice_publish"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."msg_notice_publish"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."msg_notice_publish"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."msg_notice_publish"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."msg_notice_publish"."del_flag" IS '删除标记(0存在 1删除)';
