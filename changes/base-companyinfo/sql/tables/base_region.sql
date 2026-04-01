-- ----------------------------
-- Table structure for base_region
-- ----------------------------
DROP TABLE IF EXISTS "master"."base_region";
CREATE TABLE "master"."base_region" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_base_region'),
  "region_code" varchar(6) NOT NULL,
  "region_name" varchar(100) NOT NULL,
  "parent_code" varchar(6) NOT NULL,
  "region_level" smallint NOT NULL,
  "sort" int NOT NULL DEFAULT 0,
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
DROP INDEX IF EXISTS "master"."idx_region_code";
DROP INDEX IF EXISTS "master"."idx_parent_code";
DROP INDEX IF EXISTS "master"."idx_region_level";

CREATE UNIQUE INDEX "idx_region_code" ON "master"."base_region" ("region_code");
CREATE INDEX "idx_parent_code" ON "master"."base_region" ("parent_code");
CREATE INDEX "idx_region_level" ON "master"."base_region" ("region_level");

-- Add column comments
COMMENT ON COLUMN "master"."base_region"."id" IS '主键ID';
COMMENT ON COLUMN "master"."base_region"."region_code" IS '地区代码';
COMMENT ON COLUMN "master"."base_region"."region_name" IS '地区名称';
COMMENT ON COLUMN "master"."base_region"."parent_code" IS '上级地区代码';
COMMENT ON COLUMN "master"."base_region"."region_level" IS '地区级别(1-省,2-市,3-区县)';
COMMENT ON COLUMN "master"."base_region"."sort" IS '排序';
COMMENT ON COLUMN "master"."base_region"."status" IS '状态(0-正常,1-禁用)';
COMMENT ON COLUMN "master"."base_region"."create_dept" IS '创建部门';
COMMENT ON COLUMN "master"."base_region"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."base_region"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."base_region"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."base_region"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."base_region"."remark" IS '备注';
COMMENT ON COLUMN "master"."base_region"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "master"."base_region"."del_flag" IS '删除标志(0-存在,2-删除)';

-- Add table comment
COMMENT ON TABLE "master"."base_region" IS '省市区地区表';
