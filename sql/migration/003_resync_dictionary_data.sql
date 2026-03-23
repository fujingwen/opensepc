-- ======================================
-- 重新同步数据到 master 模式
-- ======================================

-- 重新创建 master.base_dictionarytype 表并同步数据
DROP TABLE IF EXISTS "master"."base_dictionarytype";
CREATE TABLE "master"."base_dictionarytype" (
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

-- 从test表同步数据
INSERT INTO "master"."base_dictionarytype" (
  "id", "parent_id", "full_name", "en_code", "is_tree", "description", "sort_code", "enabled_mark",
  "create_by", "create_time", "update_by", "update_time", "del_flag"
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
  "F_CreatorUserId",
  "F_CreatorTime",
  "F_LastModifyUserId",
  "F_LastModifyTime",
  CASE WHEN "F_DeleteMark" = 1 THEN '2' ELSE '0' END
FROM "test"."base_dictionarytype"
WHERE "F_DeleteMark" IS NULL OR "F_DeleteMark" = 0;

-- 添加索引
CREATE INDEX "idx_base_dictionarytype_parent" ON "master"."base_dictionarytype"("parent_id");
CREATE INDEX "idx_base_dictionarytype_istree" ON "master"."base_dictionarytype"("is_tree");

-- 添加注释
COMMENT ON TABLE "master"."base_dictionarytype" IS '字典类型表';
COMMENT ON COLUMN "master"."base_dictionarytype"."id" IS '主键ID';
COMMENT ON COLUMN "master"."base_dictionarytype"."parent_id" IS '父级ID';
COMMENT ON COLUMN "master"."base_dictionarytype"."full_name" IS '字典名称';
COMMENT ON COLUMN "master"."base_dictionarytype"."en_code" IS '字典编码';
COMMENT ON COLUMN "master"."base_dictionarytype"."is_tree" IS '是否树形(0-否,1-是)';
COMMENT ON COLUMN "master"."base_dictionarytype"."description" IS '描述';
COMMENT ON COLUMN "master"."base_dictionarytype"."sort_code" IS '排序码';
COMMENT ON COLUMN "master"."base_dictionarytype"."enabled_mark" IS '状态(0-停用,1-正常)';

-- ======================================
-- 重新创建 master.base_dictionarydata 表并同步数据
-- ======================================

DROP TABLE IF EXISTS "master"."base_dictionarydata";
CREATE TABLE "master"."base_dictionarydata" (
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

-- 从test表同步数据
INSERT INTO "master"."base_dictionarydata" (
  "id", "parent_id", "full_name", "en_code", "simple_spelling", "is_default", "description",
  "sort_code", "enabled_mark", "is_title", "is_custom", "dictionary_type_id", "zjc_code",
  "create_by", "create_time", "update_by", "update_time", "del_flag"
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
  "F_CreatorUserId",
  "F_CreatorTime",
  "F_LastModifyUserId",
  "F_LastModifyTime",
  CASE WHEN "F_DeleteMark" = 1 THEN '2' ELSE '0' END
FROM "test"."base_dictionarydata"
WHERE "F_DeleteMark" IS NULL OR "F_DeleteMark" = 0;

-- 添加索引
CREATE INDEX "idx_base_dictionarydata_type" ON "master"."base_dictionarydata"("dictionary_type_id");
CREATE INDEX "idx_base_dictionarydata_parent" ON "master"."base_dictionarydata"("parent_id");

-- 添加注释
COMMENT ON TABLE "master"."base_dictionarydata" IS '字典数据表';
COMMENT ON COLUMN "master"."base_dictionarydata"."id" IS '主键ID';
COMMENT ON COLUMN "master"."base_dictionarydata"."parent_id" IS '父级ID';
COMMENT ON COLUMN "master"."base_dictionarydata"."full_name" IS '字典名称';
COMMENT ON COLUMN "master"."base_dictionarydata"."en_code" IS '字典编码';
COMMENT ON COLUMN "master"."base_dictionarydata"."dictionary_type_id" IS '字典类型ID';
