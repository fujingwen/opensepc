-- ----------------------------
-- Sequences for Basic Data Module
-- ----------------------------

-- 生产企业表序列
CREATE SEQUENCE IF NOT EXISTS "master"."seq_base_production"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- 施工企业表序列
CREATE SEQUENCE IF NOT EXISTS "master"."seq_base_construction"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- 代理商表序列
CREATE SEQUENCE IF NOT EXISTS "master"."seq_base_agent"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

-- 省市区表序列
CREATE SEQUENCE IF NOT EXISTS "master"."seq_base_region"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
