-- ----------------------------
-- Table structure for base_agent
-- ----------------------------
DROP TABLE IF EXISTS "master"."base_agent";
CREATE TABLE "master"."base_agent" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_base_agent'),
  "production_enterprise_id" bigint NOT NULL,
  "agent_name" varchar(200) NOT NULL,
  "contact_person" varchar(100) NOT NULL,
  "contact_phone" varchar(20) NOT NULL,
  "province_code" varchar(6) NOT NULL,
  "city_code" varchar(6) NOT NULL,
  "district_code" varchar(6) NOT NULL,
  "address" varchar(500) NOT NULL,
  "user_account" varchar(50) NOT NULL,
  "user_password" varchar(100) NOT NULL,
  "status" char(1) NOT NULL DEFAULT '0',
  "create_dept" bigint,
  "create_by" bigint NOT NULL,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp,
  "remark" varchar(500),
  "tenant_id" varchar(6) NOT NULL DEFAULT '000000',
  "del_flag" char(1) DEFAULT '0',
  PRIMARY KEY ("id")
);

-- Create indexes
DROP INDEX IF EXISTS "master"."idx_agent_name";
DROP INDEX IF EXISTS "master"."idx_production_enterprise_id";
DROP INDEX IF EXISTS "master"."idx_user_account";
DROP INDEX IF EXISTS "master"."idx_province_code";
DROP INDEX IF EXISTS "master"."idx_city_code";
DROP INDEX IF EXISTS "master"."idx_district_code";

CREATE INDEX "idx_agent_name" ON "master"."base_agent" ("agent_name");
CREATE INDEX "idx_production_enterprise_id" ON "master"."base_agent" ("production_enterprise_id");
CREATE INDEX "idx_user_account" ON "master"."base_agent" ("user_account");
CREATE INDEX "idx_province_code" ON "master"."base_agent" ("province_code");
CREATE INDEX "idx_city_code" ON "master"."base_agent" ("city_code");
CREATE INDEX "idx_district_code" ON "master"."base_agent" ("district_code");

-- Add column comments
COMMENT ON COLUMN "master"."base_agent"."id" IS '主键ID';
COMMENT ON COLUMN "master"."base_agent"."production_enterprise_id" IS '所属生产企业ID';
COMMENT ON COLUMN "master"."base_agent"."agent_name" IS '代理商名称';
COMMENT ON COLUMN "master"."base_agent"."contact_person" IS '联系人';
COMMENT ON COLUMN "master"."base_agent"."contact_phone" IS '联系电话';
COMMENT ON COLUMN "master"."base_agent"."province_code" IS '省份代码';
COMMENT ON COLUMN "master"."base_agent"."city_code" IS '城市代码';
COMMENT ON COLUMN "master"."base_agent"."district_code" IS '区县代码';
COMMENT ON COLUMN "master"."base_agent"."address" IS '详细地址';
COMMENT ON COLUMN "master"."base_agent"."user_account" IS '用户账号';
COMMENT ON COLUMN "master"."base_agent"."user_password" IS '用户密码';
COMMENT ON COLUMN "master"."base_agent"."status" IS '状态(0-正常,1-禁用)';
COMMENT ON COLUMN "master"."base_agent"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."base_agent"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."base_agent"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."base_agent"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."base_agent"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."base_agent"."remark" IS '备注';
COMMENT ON COLUMN "master"."base_agent"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "master"."base_agent"."del_flag" IS '删除标志(0-存在,2-删除)';

-- Add table comment
COMMENT ON TABLE "master"."base_agent" IS '代理商表';
