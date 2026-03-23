-- ======================================
-- 同步 test.base_dictionarytype 到 master 模式
-- ======================================

-- 创建 master.base_dictionarytype 表
DROP TABLE IF EXISTS "master"."base_dictionarytype";
CREATE TABLE "master"."base_dictionarytype" (
  "F_Id" varchar(50) NOT NULL,
  "F_ParentId" varchar(50),
  "F_FullName" varchar(50),
  "F_EnCode" varchar(50),
  "F_IsTree" integer,
  "F_Description" text,
  "F_SortCode" bigint,
  "F_EnabledMark" integer,
  "F_CreatorTime" timestamp without time zone,
  "F_CreatorUserId" varchar(50),
  "F_LastModifyTime" timestamp without time zone,
  "F_LastModifyUserId" varchar(50),
  "F_DeleteMark" integer,
  "F_DeleteTime" timestamp without time zone,
  "F_DeleteUserId" varchar(50),
  PRIMARY KEY ("F_Id")
);

-- 复制数据
INSERT INTO "master"."base_dictionarytype"
SELECT * FROM "test"."base_dictionarytype"
WHERE ("F_DeleteMark" IS NULL OR "F_DeleteMark" = 0);

-- 添加索引
CREATE INDEX idx_base_dictionarytype_parent ON "master"."base_dictionarytype"("F_ParentId");
CREATE INDEX idx_base_dictionarytype_istree ON "master"."base_dictionarytype"("F_IsTree");

-- ======================================
-- 同步 test.base_dictionarydata 到 master 模式
-- ======================================

-- 创建 master.base_dictionarydata 表
DROP TABLE IF EXISTS "master"."base_dictionarydata";
CREATE TABLE "master"."base_dictionarydata" (
  "F_Id" varchar(50) NOT NULL,
  "F_ParentId" varchar(50),
  "F_FullName" varchar(500),
  "F_EnCode" varchar(50),
  "F_SimpleSpelling" text,
  "F_IsDefault" integer,
  "F_Description" text,
  "F_SortCode" bigint,
  "F_EnabledMark" integer,
  "F_IsTitle" integer,
  "F_IsCustom" integer,
  "F_CreatorTime" timestamp without time zone,
  "F_CreatorUserId" varchar(50),
  "F_LastModifyTime" timestamp without time zone,
  "F_LastModifyUserId" varchar(50),
  "F_DeleteMark" integer,
  "F_DeleteTime" timestamp without time zone,
  "F_DeleteUserId" varchar(50),
  "F_DictionaryTypeId" varchar(50),
  "F_ZjcCode" varchar(50),
  PRIMARY KEY ("F_Id")
);

-- 复制数据
INSERT INTO "master"."base_dictionarydata"
SELECT * FROM "test"."base_dictionarydata"
WHERE ("F_DeleteMark" IS NULL OR "F_DeleteMark" = 0);

-- 添加索引
CREATE INDEX idx_base_dictionarydata_type ON "master"."base_dictionarydata"("F_DictionaryTypeId");
CREATE INDEX idx_base_dictionarydata_parent ON "master"."base_dictionarydata"("F_ParentId");
