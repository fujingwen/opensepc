-- 添加用户密码字段到 base_agent 表
ALTER TABLE "master"."base_agent" ADD COLUMN "user_password" varchar(100) NOT NULL DEFAULT '';

-- 添加字段注释
COMMENT ON COLUMN "master"."base_agent"."user_password" IS '用户密码';