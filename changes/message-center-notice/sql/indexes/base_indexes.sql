CREATE INDEX IF NOT EXISTS "idx_msg_message_sender_id" ON "master"."msg_message" ("sender_id");
CREATE INDEX IF NOT EXISTS "idx_msg_message_type" ON "master"."msg_message" ("message_type");
CREATE INDEX IF NOT EXISTS "idx_msg_message_send_time" ON "master"."msg_message" ("send_time");
CREATE INDEX IF NOT EXISTS "idx_msg_message_del_flag" ON "master"."msg_message" ("del_flag");

CREATE INDEX IF NOT EXISTS "idx_msg_message_user_message_id" ON "master"."msg_message_user" ("message_id");
CREATE INDEX IF NOT EXISTS "idx_msg_message_user_receiver_id" ON "master"."msg_message_user" ("receiver_user_id");
CREATE INDEX IF NOT EXISTS "idx_msg_message_user_read_status" ON "master"."msg_message_user" ("read_status");
CREATE INDEX IF NOT EXISTS "idx_msg_message_user_del_flag" ON "master"."msg_message_user" ("del_flag");

CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_type" ON "master"."msg_notice_publish" ("notice_type");
CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_company_id" ON "master"."msg_notice_publish" ("company_id");
CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_publish_time" ON "master"."msg_notice_publish" ("publish_time");
CREATE INDEX IF NOT EXISTS "idx_msg_notice_publish_del_flag" ON "master"."msg_notice_publish" ("del_flag");
