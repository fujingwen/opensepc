-- ----------------------------
-- Table structure for mat_project
-- ----------------------------
DROP TABLE IF EXISTS "master"."mat_project";
CREATE TABLE "master"."mat_project" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_mat_project'),
  "construction_permit" varchar(100) NOT NULL,
  "permit_issue_date" date NOT NULL,
  "project_name" varchar(200) NOT NULL,
  "project_nature" varchar(50) NOT NULL,
  "building_area" decimal(10,2) NOT NULL,
  "project_progress" varchar(50) NOT NULL,
  "project_address" varchar(500) NOT NULL,
  "structure_type" varchar(50) NOT NULL,
  "quality_supervision_agency" varchar(200) NOT NULL,
  "construction_unit" varchar(200) NOT NULL,
  "construction_unit_manager" varchar(100) NOT NULL,
  "manager_contact" varchar(20) NOT NULL,
  "has_report" varchar(10) NOT NULL,
  "is_integrated" varchar(10) NOT NULL,
  "remarks" text,
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_time" timestamp NOT NULL DEFAULT now(),
  "create_by" varchar(50),
  "update_by" varchar(50),
  "del_flag" char(1) DEFAULT '0',
  PRIMARY KEY ("id")
);

-- Add column comments
COMMENT ON COLUMN "master"."mat_project"."id" IS '主键ID';
COMMENT ON COLUMN "master"."mat_project"."construction_permit" IS '施工许可证';
COMMENT ON COLUMN "master"."mat_project"."permit_issue_date" IS '施工许可证发证日期';
COMMENT ON COLUMN "master"."mat_project"."project_name" IS '工程名称';
COMMENT ON COLUMN "master"."mat_project"."project_nature" IS '工程性质';
COMMENT ON COLUMN "master"."mat_project"."building_area" IS '建筑面积（平方米）';
COMMENT ON COLUMN "master"."mat_project"."project_progress" IS '工程进度';
COMMENT ON COLUMN "master"."mat_project"."project_address" IS '工程地址';
COMMENT ON COLUMN "master"."mat_project"."structure_type" IS '工程结构型式';
COMMENT ON COLUMN "master"."mat_project"."quality_supervision_agency" IS '质量监督机构';
COMMENT ON COLUMN "master"."mat_project"."construction_unit" IS '施工单位';
COMMENT ON COLUMN "master"."mat_project"."construction_unit_manager" IS '施工单位负责人';
COMMENT ON COLUMN "master"."mat_project"."manager_contact" IS '施工单位负责人联系方式';
COMMENT ON COLUMN "master"."mat_project"."has_report" IS '有无填报';
COMMENT ON COLUMN "master"."mat_project"."is_integrated" IS '是否对接一体化平台编码';
COMMENT ON COLUMN "master"."mat_project"."remarks" IS '备注';
COMMENT ON COLUMN "master"."mat_project"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."mat_project"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."mat_project"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."mat_project"."update_by" IS '更新人';
COMMENT ON COLUMN "master"."mat_project"."del_flag" IS '删除标志(0-存在,2-删除)';

-- Add table comment
COMMENT ON TABLE "master"."mat_project" IS '工程项目表';
