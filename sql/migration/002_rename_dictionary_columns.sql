-- ======================================
-- 修改 master.base_dictionarytype 表结构
-- ======================================

-- 1. 添加默认审计字段
ALTER TABLE "master"."base_dictionarytype" ADD COLUMN IF NOT EXISTS "tenant_id" varchar(20);
ALTER TABLE "master"."base_dictionarytype" ADD COLUMN IF NOT EXISTS "create_dept" bigint;
ALTER TABLE "master"."base_dictionarytype" ADD COLUMN IF NOT EXISTS "create_by" varchar(50);
ALTER TABLE "master"."base_dictionarytype" ADD COLUMN IF NOT EXISTS "create_time" timestamp;
ALTER TABLE "master"."base_dictionarytype" ADD COLUMN IF NOT EXISTS "update_by" varchar(50);
ALTER TABLE "master"."base_dictionarytype" ADD COLUMN IF NOT EXISTS "update_time" timestamp;
ALTER TABLE "master"."base_dictionarytype" ADD COLUMN IF NOT EXISTS "del_flag" char(1) DEFAULT '0';

-- 2. 迁移数据并重命名字段
DROP TABLE IF EXISTS "master"."base_dictionarytype_temp";
CREATE TABLE "master"."base_dictionarytype_temp" (
  "id" varchar(50) NOT NULL,
  "parent_id" varchar(50),
  "full_name" varchar(50),
  "en_code" varchar(50),
  "is_tree" integer,
  "description" text,
  "sort_code" bigint,
  "enabled_mark" integer,
  "tenant_id" varchar(20),
  "create_dept" bigint,
  "create_by" varchar(50),
  "create_time" timestamp,
  "update_by" varchar(50),
  "update_time" timestamp,
  "del_flag" char(1) DEFAULT '0',
  PRIMARY KEY ("id")
);

INSERT INTO "master"."base_dictionarytype_temp" (
  "id", "parent_id", "full_name", "en_code", "is_tree", "description", "sort_code", "enabled_mark",
  "tenant_id", "create_dept", "create_by", "create_time", "update_by", "update_time", "del_flag"
)
SELECT
  "F_Id",
  "F_ParentId",
  "F_FullName",
  "F_EnCode",
  "F_IsTree",
  "F_Description",
  "F_SortCode",
  "F_EnabledMark",
  NULL,
  NULL,
  "F_CreatorUserId",
  "F_CreatorTime",
  "F_LastModifyUserId",
  "F_LastModifyTime",
  CASE WHEN "F_DeleteMark" = 1 THEN '2' ELSE '0' END
FROM "master"."base_dictionarytype";

DROP TABLE "master"."base_dictionarytype";
ALTER TABLE "master"."base_dictionarytype_temp" RENAME TO "base_dictionarytype";

-- 3. 添加注释
COMMENT ON TABLE "master"."base_dictionarytype" IS '字典类型表';
COMMENT ON COLUMN "master"."base_dictionarytype"."id" IS '主键ID';
COMMENT ON COLUMN "master"."base_dictionarytype"."parent_id" IS '父级ID';
COMMENT ON COLUMN "master"."base_dictionarytype"."full_name" IS '字典名称';
COMMENT ON COLUMN "master"."base_dictionarytype"."en_code" IS '字典编码';
COMMENT ON COLUMN "master"."base_dictionarytype"."is_tree" IS '是否树形(0-否,1-是)';
COMMENT ON COLUMN "master"."base_dictionarytype"."description" IS '描述';
COMMENT ON COLUMN "master"."base_dictionarytype"."sort_code" IS '排序码';
COMMENT ON COLUMN "master"."base_dictionarytype"."enabled_mark" IS '状态(0-停用,1-正常)';

-- 4. 重建索引
CREATE INDEX "idx_base_dictionarytype_parent" ON "master"."base_dictionarytype"("parent_id");
CREATE INDEX "idx_base_dictionarytype_istree" ON "master"."base_dictionarytype"("is_tree");


-- ======================================
-- 修改 master.base_dictionarydata 表结构
-- ======================================

-- 1. 添加默认审计字段
ALTER TABLE "master"."base_dictionarydata" ADD COLUMN IF NOT EXISTS "tenant_id" varchar(20);
ALTER TABLE "master"."base_dictionarydata" ADD COLUMN IF NOT EXISTS "create_dept" bigint;
ALTER TABLE "master"."base_dictionarydata" ADD COLUMN IF NOT EXISTS "create_by" varchar(50);
ALTER TABLE "master"."base_dictionarydata" ADD COLUMN IF NOT EXISTS "create_time" timestamp;
ALTER TABLE "master"."base_dictionarydata" ADD COLUMN IF NOT EXISTS "update_by" varchar(50);
ALTER TABLE "master"."base_dictionarydata" ADD COLUMN IF NOT EXISTS "update_time" timestamp;
ALTER TABLE "master"."base_dictionarydata" ADD COLUMN IF NOT EXISTS "del_flag" char(1) DEFAULT '0';

-- 2. 迁移数据并重命名字段
DROP TABLE IF EXISTS "master"."base_dictionarydata_temp";
CREATE TABLE "master"."base_dictionarydata_temp" (
  "id" varchar(50) NOT NULL,
  "parent_id" varchar(50),
  "full_name" varchar(500),
  "en_code" varchar(50),
  "simple_spelling" text,
  "is_default" integer,
  "description" text,
  "sort_code" bigint,
  "enabled_mark" integer,
  "is_title" integer,
  "is_custom" integer,
  "dictionary_type_id" varchar(50),
  "zjc_code" varchar(50),
  "tenant_id" varchar(20),
  "create_dept" bigint,
  "create_by" varchar(50),
  "create_time" timestamp,
  "update_by" varchar(50),
  "update_time" timestamp,
  "del_flag" char(1) DEFAULT '0',
  PRIMARY KEY ("id")
);

INSERT INTO "master"."base_dictionarydata_temp" (
  "id", "parent_id", "full_name", "en_code", "simple_spelling", "is_default", "description",
  "sort_code", "enabled_mark", "is_title", "is_custom", "dictionary_type_id", "zjc_code",
  "tenant_id", "create_dept", "create_by", "create_time", "update_by", "update_time", "del_flag"
)
SELECT
  "F_Id",
  "F_ParentId",
  "F_FullName",
  "F_EnCode",
  "F_SimpleSpelling",
  "F_IsDefault",
  "F_Description",
  "F_SortCode",
  "F_EnabledMark",
  "F_IsTitle",
  "F_IsCustom",
  "F_DictionaryTypeId",
  "F_ZjcCode",
  NULL,
  NULL,
  "F_CreatorUserId",
  "F_CreatorTime",
  "F_LastModifyUserId",
  "F_LastModifyTime",
  CASE WHEN "F_DeleteMark" = 1 THEN '2' ELSE '0' END
FROM "master"."base_dictionarydata";

DROP TABLE "master"."base_dictionarydata";
ALTER TABLE "master"."base_dictionarydata_temp" RENAME TO "base_dictionarydata";

-- 3. 添加注释
COMMENT ON TABLE "master"."base_dictionarydata" IS '字典数据表';
COMMENT ON COLUMN "master"."base_dictionarydata"."id" IS '主键ID';
COMMENT ON COLUMN "master"."base_dictionarydata"."parent_id" IS '父级ID';
COMMENT ON COLUMN "master"."base_dictionarydata"."full_name" IS '字典名称';
COMMENT ON COLUMN "master"."base_dictionarydata"."en_code" IS '字典编码';
COMMENT ON COLUMN "master"."base_dictionarydata"."dictionary_type_id" IS '字典类型ID';

-- 4. 重建索引
CREATE INDEX "idx_base_dictionarydata_type" ON "master"."base_dictionarydata"("dictionary_type_id");
CREATE INDEX "idx_base_dictionarydata_parent" ON "master"."base_dictionarydata"("parent_id");
