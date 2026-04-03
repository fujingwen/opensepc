CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_type" ON "master"."msg_notice_publish" ("notice_type");
CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_company_id" ON "master"."msg_notice_publish" ("company_id");
CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_publish_time" ON "master"."msg_notice_publish" ("publish_time");
CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_del_flag" ON "master"."msg_notice_publish" ("del_flag");
