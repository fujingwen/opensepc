CREATE TABLE "master"."mat_product" (
  "id" bigint NOT NULL DEFAULT nextval('master.seq_mat_product'),
  "tenant_id" varchar(20) NOT NULL DEFAULT '000000',
  "project_id" bigint NOT NULL,
  "construction_unit_name" varchar(200) NOT NULL,
  "project_progress" varchar(50) NOT NULL,
  "product_category" varchar(100),
  "product_name" varchar(200) NOT NULL,
  "product_spec" varchar(200),
  "unit" varchar(20),
  "production_unit_name" varchar(200),
  "production_unit_region" varchar(100),
  "production_unit_address" varchar(500),
  "supplier_name" varchar(200),
  "production_batch_number" varchar(100),
  "production_date" date,
  "purchase_quantity" decimal(18,2) NOT NULL,
  "purchase_price" decimal(18,2),
  "product_certificate" varchar(500),
  "factory_inspection_report" varchar(1000),
  "performance_inspection_report" varchar(2000),
  "product_photo" varchar(500),
  "entry_time" date,
  "agent_name" varchar(200),
  "supervision_request" varchar(500),
  "has_certificate_number" varchar(10),
  "certificate_number" varchar(100),
  "info_confirm_status" varchar(50),
  "info_confirm_timeout" varchar(10),
  "info_confirm_fail_type" varchar(50),
  "info_confirm_unit" varchar(200),
  "quality_supervision_agency" varchar(200),
  "del_flag" char(1) DEFAULT '0',
  "create_time" timestamp NOT NULL DEFAULT now(),
  "update_time" timestamp NOT NULL DEFAULT now(),
  "create_by" varchar(50),
  "update_by" varchar(50),
  PRIMARY KEY ("id")
);

DROP INDEX IF EXISTS "master"."idx_product_tenant_id";
CREATE INDEX "idx_product_tenant_id" ON "master"."mat_product" ("tenant_id");

DROP INDEX IF EXISTS "master"."idx_product_project_id";
CREATE INDEX "idx_product_project_id" ON "master"."mat_product" ("project_id");

DROP INDEX IF EXISTS "master"."idx_product_construction_unit";
CREATE INDEX "idx_product_construction_unit" ON "master"."mat_product" ("construction_unit_name");

DROP INDEX IF EXISTS "master"."idx_product_name";
CREATE INDEX "idx_product_name" ON "master"."mat_product" ("product_name");

DROP INDEX IF EXISTS "master"."idx_product_entry_time";
CREATE INDEX "idx_product_entry_time" ON "master"."mat_product" ("entry_time");

DROP INDEX IF EXISTS "master"."idx_product_confirm_status";
CREATE INDEX "idx_product_confirm_status" ON "master"."mat_product" ("info_confirm_status");

COMMENT ON COLUMN "master"."mat_product"."id" IS '主键ID';
COMMENT ON COLUMN "master"."mat_product"."tenant_id" IS '租户编号';
COMMENT ON COLUMN "master"."mat_product"."project_id" IS '工程项目ID';
COMMENT ON COLUMN "master"."mat_product"."construction_unit_name" IS '施工单位名称';
COMMENT ON COLUMN "master"."mat_product"."project_progress" IS '工程进度';
COMMENT ON COLUMN "master"."mat_product"."product_category" IS '产品类别';
COMMENT ON COLUMN "master"."mat_product"."product_name" IS '产品名称';
COMMENT ON COLUMN "master"."mat_product"."product_spec" IS '产品规格';
COMMENT ON COLUMN "master"."mat_product"."unit" IS '单位';
COMMENT ON COLUMN "master"."mat_product"."production_unit_name" IS '生产单位名称';
COMMENT ON COLUMN "master"."mat_product"."production_unit_region" IS '生产单位省市区';
COMMENT ON COLUMN "master"."mat_product"."production_unit_address" IS '生产单位详细地址';
COMMENT ON COLUMN "master"."mat_product"."supplier_name" IS '供应商名称';
COMMENT ON COLUMN "master"."mat_product"."production_batch_number" IS '生产批号';
COMMENT ON COLUMN "master"."mat_product"."production_date" IS '生产日期';
COMMENT ON COLUMN "master"."mat_product"."purchase_quantity" IS '采购数量';
COMMENT ON COLUMN "master"."mat_product"."purchase_price" IS '采购单价';
COMMENT ON COLUMN "master"."mat_product"."product_certificate" IS '产品合格证';
COMMENT ON COLUMN "master"."mat_product"."factory_inspection_report" IS '出厂检验报告';
COMMENT ON COLUMN "master"."mat_product"."performance_inspection_report" IS '性能检验报告';
COMMENT ON COLUMN "master"."mat_product"."product_photo" IS '实物照片';
COMMENT ON COLUMN "master"."mat_product"."entry_time" IS '进场时间';
COMMENT ON COLUMN "master"."mat_product"."agent_name" IS '代理商名称';
COMMENT ON COLUMN "master"."mat_product"."supervision_request" IS '监理申请';
COMMENT ON COLUMN "master"."mat_product"."has_certificate_number" IS '有无备案证号';
COMMENT ON COLUMN "master"."mat_product"."certificate_number" IS '备案证号';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_status" IS '信息确认状态';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_timeout" IS '信息确认超时';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_fail_type" IS '信息确认不通过类别';
COMMENT ON COLUMN "master"."mat_product"."info_confirm_unit" IS '信息确认单位';
COMMENT ON COLUMN "master"."mat_product"."quality_supervision_agency" IS '质量监督机构';
COMMENT ON COLUMN "master"."mat_product"."del_flag" IS '删除标志(0-存在,2-删除)';
COMMENT ON COLUMN "master"."mat_product"."create_time" IS '创建时间';
COMMENT ON COLUMN "master"."mat_product"."update_time" IS '更新时间';
COMMENT ON COLUMN "master"."mat_product"."create_by" IS '创建人';
COMMENT ON COLUMN "master"."mat_product"."update_by" IS '更新人';
COMMENT ON TABLE "master"."mat_product" IS '建材产品表';
