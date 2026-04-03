CREATE INDEX IF NOT EXISTS "idx_base_message_sender_id" ON "master"."base_message" ("sender_id");
CREATE INDEX IF NOT EXISTS "idx_base_message_type" ON "master"."base_message" ("message_type");
CREATE INDEX IF NOT EXISTS "idx_base_message_send_time" ON "master"."base_message" ("send_time");
CREATE INDEX IF NOT EXISTS "idx_base_message_del_flag" ON "master"."base_message" ("del_flag");

CREATE INDEX IF NOT EXISTS "idx_base_message_receive_message_id" ON "master"."base_message_receive" ("message_id");
CREATE INDEX IF NOT EXISTS "idx_base_message_receive_receiver_id" ON "master"."base_message_receive" ("receiver_user_id");
CREATE INDEX IF NOT EXISTS "idx_base_message_receive_message_type" ON "master"."base_message_receive" ("message_type");
CREATE INDEX IF NOT EXISTS "idx_base_message_receive_business_type" ON "master"."base_message_receive" ("business_type");
CREATE INDEX IF NOT EXISTS "idx_base_message_receive_send_time" ON "master"."base_message_receive" ("send_time");
CREATE INDEX IF NOT EXISTS "idx_base_message_receive_del_flag" ON "master"."base_message_receive" ("del_flag");
