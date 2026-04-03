-- 1. test.base_message -> master.base_message
INSERT INTO "master"."base_message" (
  "id", "tenant_id", "title", "content", "message_type", "business_type", "receiver_user_ids",
  "sender_id", "sender_name", "priority_level", "legacy_source", "legacy_type", "remark", "sort_code",
  "enabled_mark", "send_time", "create_by", "create_time", "update_by", "update_time", "del_flag"
)
SELECT
  bm."F_Id",
  '000000',
  bm."F_Title",
  coalesce(bm."F_BodyText", ''),
  'message',
  'manual',
  bm."F_ToUserIds",
  bm."F_CreatorUserId",
  coalesce(su.user_name, bm."F_CreatorUserId"),
  bm."F_PriorityLevel",
  'test.base_message',
  bm."F_Type",
  bm."F_Description",
  bm."F_SortCode",
  coalesce(bm."F_EnabledMark", 1),
  coalesce(bm."F_CreatorTime", now()),
  case when bm."F_CreatorUserId" ~ '^[0-9]+$' then bm."F_CreatorUserId"::bigint else null end,
  coalesce(bm."F_CreatorTime", now()),
  case when bm."F_LastModifyUserId" ~ '^[0-9]+$' then bm."F_LastModifyUserId"::bigint else null end,
  coalesce(bm."F_LastModifyTime", bm."F_CreatorTime", now()),
  case when coalesce(bm."F_DeleteMark", 0) = 1 then '1' else '0' end
FROM test.base_message bm
LEFT JOIN master.sys_user su ON su.user_id::text = bm."F_CreatorUserId"
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."base_message" t WHERE t."id" = bm."F_Id"
);

-- 2. test.t_message -> master.base_message
INSERT INTO "master"."base_message" (
  "id", "tenant_id", "title", "content", "message_type", "business_type", "receiver_user_ids",
  "sender_id", "sender_name", "status", "legacy_source", "send_time", "create_by", "create_time",
  "update_by", "update_time", "del_flag"
)
SELECT
  tm."F_Id",
  '000000',
  tm."F_Title",
  coalesce(tm."F_Content", ''),
  'message',
  'manual',
  tm."F_ReceiverId",
  tm."F_CreatorUserId",
  coalesce(su.user_name, tm."F_CreatorUserId"),
  tm."F_Status",
  'test.t_message',
  coalesce(tm."F_CreatorTime", now()),
  case when tm."F_CreatorUserId" ~ '^[0-9]+$' then tm."F_CreatorUserId"::bigint else null end,
  coalesce(tm."F_CreatorTime", now()),
  case when tm."F_LastModifyUserId" ~ '^[0-9]+$' then tm."F_LastModifyUserId"::bigint else null end,
  coalesce(tm."F_LastModifyTime", tm."F_CreatorTime", now()),
  case when coalesce(tm."F_DeleteMark", 0) = 1 then '1' else '0' end
FROM test.t_message tm
LEFT JOIN master.sys_user su ON su.user_id::text = tm."F_CreatorUserId"
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."base_message" t WHERE t."id" = tm."F_Id"
);

-- 3. test.base_messagereceive -> master.base_message_receive
INSERT INTO "master"."base_message_receive" (
  "id", "tenant_id", "message_id", "title", "content", "message_type", "business_type",
  "sender_id", "sender_name", "receiver_user_id", "receiver_name", "source_business_id",
  "legacy_type", "read_status", "read_time", "read_count", "send_time",
  "create_by", "create_time", "del_flag"
)
SELECT
  br."F_Id",
  '000000',
  case
    when exists (select 1 from test.base_message bm where bm."F_Id" = br."F_MessageId") then br."F_MessageId"
    when exists (select 1 from test.t_message tm where tm."F_Id" = br."F_MessageId") then br."F_MessageId"
    else null
  end,
  coalesce(br."F_Title", ''),
  nullif(br."F_Content", ''),
  case
    when exists (select 1 from test.base_message bm where bm."F_Id" = br."F_MessageId") then 'message'
    when exists (select 1 from test.t_message tm where tm."F_Id" = br."F_MessageId") then 'message'
    else 'warning'
  end,
  case
    when exists (select 1 from test.base_message bm where bm."F_Id" = br."F_MessageId") then 'manual'
    when exists (select 1 from test.t_message tm where tm."F_Id" = br."F_MessageId") then 'manual'
    when br."F_Type" = 5 then 'timeout'
    else 'audit'
  end,
  br."F_SendUser",
  su_send.user_name,
  br."F_UserId",
  su_receive.user_name,
  case
    when exists (select 1 from test.base_message bm where bm."F_Id" = br."F_MessageId") then null
    when exists (select 1 from test.t_message tm where tm."F_Id" = br."F_MessageId") then null
    else br."F_MessageId"
  end,
  br."F_Type",
  case when coalesce(br."F_IsRead", 0) = 1 then 'read' else 'unread' end,
  br."F_ReadTime",
  coalesce(br."F_ReadCount", 0),
  coalesce(br."F_CreatorTime", now()),
  null,
  coalesce(br."F_CreatorTime", now()),
  '0'
FROM test.base_messagereceive br
LEFT JOIN master.sys_user su_send ON su_send.user_id::text = br."F_SendUser"
LEFT JOIN master.sys_user su_receive ON su_receive.user_id::text = br."F_UserId"
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."base_message_receive" t WHERE t."id" = br."F_Id"
);

-- 4. test.t_message 补充拆分收件记录（仅补没有被 base_messagereceive 覆盖的人工消息）
INSERT INTO "master"."base_message_receive" (
  "id", "tenant_id", "message_id", "title", "content", "message_type", "business_type",
  "sender_id", "sender_name", "receiver_user_id", "receiver_name", "read_status", "read_count",
  "send_time", "create_by", "create_time", "del_flag"
)
SELECT
  tm."F_Id" || '_' || row_number() over(partition by tm."F_Id" order by receiver_id.receiver_user_id),
  '000000',
  tm."F_Id",
  tm."F_Title",
  tm."F_Content",
  'message',
  'manual',
  tm."F_CreatorUserId",
  coalesce(su_send.user_name, tm."F_CreatorUserId"),
  receiver_id.receiver_user_id,
  su_receive.user_name,
  case when coalesce(tm."F_Status", 0) = 2 then 'read' else 'unread' end,
  0,
  coalesce(tm."F_CreatorTime", now()),
  case when tm."F_CreatorUserId" ~ '^[0-9]+$' then tm."F_CreatorUserId"::bigint else null end,
  coalesce(tm."F_CreatorTime", now()),
  case when coalesce(tm."F_DeleteMark", 0) = 1 then '1' else '0' end
FROM test.t_message tm
CROSS JOIN LATERAL (
  SELECT trim(value) as receiver_user_id
  FROM regexp_split_to_table(coalesce(tm."F_ReceiverId", ''), ',') value
  WHERE trim(value) <> ''
) receiver_id
LEFT JOIN master.sys_user su_send ON su_send.user_id::text = tm."F_CreatorUserId"
LEFT JOIN master.sys_user su_receive ON su_receive.user_id::text = receiver_id.receiver_user_id
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."base_message_receive" t
  WHERE t."message_id" = tm."F_Id"
    AND t."receiver_user_id" = receiver_id.receiver_user_id
);

-- 5. test.base_message_template -> master.base_message_template
INSERT INTO "master"."base_message_template" (
  "id", "tenant_id", "category", "full_name", "title", "is_station_letter", "is_email", "is_we_com",
  "is_ding_talk", "is_sms", "sms_id", "template_json", "content", "enabled_mark",
  "create_by", "create_time", "update_by", "update_time", "del_flag"
)
SELECT
  bt."F_Id",
  '000000',
  bt."F_Category",
  bt."F_FullName",
  bt."F_Title",
  coalesce(bt."F_IsStationLetter", 0),
  coalesce(bt."F_IsEmail", 0),
  coalesce(bt."F_IsWeCom", 0),
  coalesce(bt."F_IsDingTalk", 0),
  coalesce(bt."F_IsSMS", 0),
  bt."F_SmsId",
  bt."F_TemplateJson",
  bt."F_Content",
  coalesce(bt."F_EnabledMark", 1),
  case when bt."F_CreatorUserId" ~ '^[0-9]+$' then bt."F_CreatorUserId"::bigint else null end,
  coalesce(bt."F_CreatorTime", now()),
  case when bt."F_LastModifyUserId" ~ '^[0-9]+$' then bt."F_LastModifyUserId"::bigint else null end,
  coalesce(bt."F_LastModifyTime", bt."F_CreatorTime", now()),
  case when coalesce(bt."F_DeleteMark", 0) = 1 then '1' else '0' end
FROM test.base_message_template bt
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."base_message_template" t WHERE t."id" = bt."F_Id"
);

-- 6. master.msg_message -> master.base_message
INSERT INTO "master"."base_message" (
  "id", "tenant_id", "title", "content", "message_type", "business_type",
  "sender_id", "sender_name", "legacy_source", "send_time",
  "create_dept", "create_by", "create_time", "update_by", "update_time", "del_flag"
)
SELECT
  mm.id::text,
  coalesce(mm.tenant_id, '000000'),
  mm.title,
  coalesce(mm.content, ''),
  case
    when coalesce(mm.business_type, '') like 'mat_product_%' then 'warning'
    else coalesce(mm.message_type, 'message')
  end,
  case
    when coalesce(mm.business_type, '') like 'mat_product_%' then 'audit'
    else left(coalesce(mm.business_type, 'manual'), 20)
  end,
  mm.sender_id::text,
  mm.sender_name,
  'master.msg_message',
  coalesce(mm.send_time, mm.create_time, now()),
  mm.create_dept,
  mm.create_by,
  coalesce(mm.create_time, now()),
  mm.update_by,
  coalesce(mm.update_time, mm.create_time, now()),
  case when mm.del_flag = '1' then '1' else '0' end
FROM master.msg_message mm
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."base_message" t WHERE t."id" = mm.id::text
);

-- 7. master.msg_message_user -> master.base_message_receive
INSERT INTO "master"."base_message_receive" (
  "id", "tenant_id", "message_id", "title", "content", "message_type", "business_type",
  "sender_id", "sender_name", "receiver_user_id", "receiver_name",
  "read_status", "read_time", "read_count", "send_time",
  "create_dept", "create_by", "create_time", "update_by", "update_time", "del_flag"
)
SELECT
  mmu.id::text,
  coalesce(mmu.tenant_id, bm.tenant_id, '000000'),
  mmu.message_id::text,
  coalesce(bm.title, ''),
  bm.content,
  coalesce(bm.message_type, 'message'),
  coalesce(bm.business_type, 'manual'),
  bm.sender_id,
  bm.sender_name,
  mmu.receiver_user_id::text,
  mmu.receiver_name,
  coalesce(mmu.read_status, 'unread'),
  mmu.read_time,
  0,
  coalesce(bm.send_time, mmu.create_time, now()),
  mmu.create_dept,
  mmu.create_by,
  coalesce(mmu.create_time, now()),
  mmu.update_by,
  coalesce(mmu.update_time, mmu.create_time, now()),
  case when mmu.del_flag = '1' then '1' else '0' end
FROM master.msg_message_user mmu
LEFT JOIN "master"."base_message" bm ON bm.id = mmu.message_id::text
WHERE NOT EXISTS (
  SELECT 1 FROM "master"."base_message_receive" t WHERE t."id" = mmu.id::text
);
