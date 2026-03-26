-- ----------------------------
-- Table structure for t_quality_trace
-- ----------------------------
DROP TABLE IF EXISTS "master"."t_quality_trace";
CREATE TABLE "master"."t_quality_trace" (
  "id" varchar(50) NOT NULL,
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "original_id" varchar(50),
  "check_organize" varchar(200),
  "project_no" varchar(200),
  "project_name" varchar(500),
  "product_name" varchar(500),
  "factory_name" varchar(500),
  "batch" varchar(100),
  "check_project_name" varchar(800),
  "data_status" varchar(1),
  "is_collect" varchar(1),
  "conclusion_mark" varchar(50),
  "conclusion" varchar(500),
  "report_time" timestamp(0),
  "check_time" timestamp(0),
  "enabled_mark" smallint,
  "create_by" varchar(50),
  "create_time" timestamp(0),
  "update_by" varchar(50),
  "update_time" timestamp(0),
  "delete_by" varchar(50),
  "delete_time" timestamp(0),
  "del_flag" smallint DEFAULT 0,
  "create_dept" varchar(50) DEFAULT '103',
  PRIMARY KEY ("id", "tenant_id")
);

COMMENT ON TABLE "master"."t_quality_trace" IS '质量追溯表';
COMMENT ON COLUMN "master"."t_quality_trace"."id" IS '主键';
COMMENT ON COLUMN "master"."t_quality_trace"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."t_quality_trace"."original_id" IS '原始ID';
COMMENT ON COLUMN "master"."t_quality_trace"."check_organize" IS '检测单位';
COMMENT ON COLUMN "master"."t_quality_trace"."project_no" IS '工程编号';
COMMENT ON COLUMN "master"."t_quality_trace"."project_name" IS '工程名称';
COMMENT ON COLUMN "master"."t_quality_trace"."product_name" IS '检测产品名称';
COMMENT ON COLUMN "master"."t_quality_trace"."factory_name" IS '生产厂家';
COMMENT ON COLUMN "master"."t_quality_trace"."batch" IS '生产批号';
COMMENT ON COLUMN "master"."t_quality_trace"."check_project_name" IS '检测项目名称';
COMMENT ON COLUMN "master"."t_quality_trace"."data_status" IS '数据状态';
COMMENT ON COLUMN "master"."t_quality_trace"."is_collect" IS '是否已采集';
COMMENT ON COLUMN "master"."t_quality_trace"."conclusion_mark" IS '结论标志';
COMMENT ON COLUMN "master"."t_quality_trace"."conclusion" IS '结论';
COMMENT ON COLUMN "master"."t_quality_trace"."report_time" IS '报告日期';
COMMENT ON COLUMN "master"."t_quality_trace"."check_time" IS '检测时间';
COMMENT ON COLUMN "master"."t_quality_trace"."enabled_mark" IS '有效标志';
COMMENT ON COLUMN "master"."t_quality_trace"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."t_quality_trace"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."t_quality_trace"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."t_quality_trace"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."t_quality_trace"."delete_by" IS '删除人';
COMMENT ON COLUMN "master"."t_quality_trace"."delete_time" IS '删除时间';
COMMENT ON COLUMN "master"."t_quality_trace"."del_flag" IS '删除标记';
COMMENT ON COLUMN "master"."t_quality_trace"."create_dept" IS '创建部门';