-- ----------------------------
-- Table structure for base_production
-- ----------------------------
DROP TABLE IF EXISTS "master"."base_production";
CREATE TABLE "master"."base_production" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_base_production'),
  "user_id" bigint NOT NULL,
  "nick_name" varchar(200) NOT NULL,
  "enterprise_name" varchar(200) NOT NULL,
  "contact_person" varchar(100) NOT NULL,
  "contact_phone" varchar(20) NOT NULL,
  "province_code" varchar(6) NOT NULL,
  "city_code" varchar(6) NOT NULL,
  "district_code" varchar(6) NOT NULL,
  "address" varchar(500) NOT NULL,
  "credit_code" varchar(50),
  "status" char(1) NOT NULL DEFAULT '0',
  "create_dept" bigint,
  "create_by" bigint NOT NULL,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_by" bigint,
  "update_time" timestamp,
  "remark" varchar(500),
  "tenant_id" varchar(6) NOT NULL DEFAULT '000000',
  "del_flag" char(1) DEFAULT '0',
  PRIMARY KEY ("id"),
  CONSTRAINT "uk_user_id" UNIQUE ("user_id")
);

-- Create indexes
DROP INDEX IF EXISTS "master"."idx_enterprise_name";
DROP INDEX IF EXISTS "master"."idx_credit_code";
DROP INDEX IF EXISTS "master"."idx_province_code";
DROP INDEX IF EXISTS "master"."idx_city_code";
DROP INDEX IF EXISTS "master"."idx_district_code";

CREATE INDEX "idx_enterprise_name" ON "master"."base_production" ("enterprise_name");
CREATE INDEX "idx_credit_code" ON "master"."base_production" ("credit_code");
CREATE INDEX "idx_province_code" ON "master"."base_production" ("province_code");
CREATE INDEX "idx_city_code" ON "master"."base_production" ("city_code");
CREATE INDEX "idx_district_code" ON "master"."base_production" ("district_code");

-- Add column comments
COMMENT ON COLUMN "master"."base_production"."id" IS '主键ID';
COMMENT ON COLUMN "master"."base_production"."user_id" IS '关联用户ID';
COMMENT ON COLUMN "master"."base_production"."nick_name" IS '用户昵称(冗余字段)';
COMMENT ON COLUMN "master"."base_production"."enterprise_name" IS '企业名称';
COMMENT ON COLUMN "master"."base_production"."contact_person" IS '联系人';
COMMENT ON COLUMN "master"."base_production"."contact_phone" IS '联系电话';
COMMENT ON COLUMN "master"."base_production"."province_code" IS '省份代码';
COMMENT ON COLUMN "master"."base_production"."city_code" IS '城市代码';
COMMENT ON COLUMN "master"."base_production"."district_code" IS '区县代码';
COMMENT ON COLUMN "master"."base_production"."address" IS '详细地址';
COMMENT ON COLUMN "master"."base_production"."credit_code" IS '统一社会信用代码';
COMMENT ON COLUMN "master"."base_production"."status" IS '状态(0-正常,1-禁用)';
COMMENT ON COLUMN "master"."base_production"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."base_production"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."base_production"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."base_production"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."base_production"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."base_production"."remark" IS '备注';
COMMENT ON COLUMN "master"."base_production"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "master"."base_production"."del_flag" IS '删除标志(0-存在,2-删除)';

-- Add table comment
COMMENT ON TABLE "master"."base_production" IS '生产企业表';
