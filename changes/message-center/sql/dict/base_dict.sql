-- Dict types
INSERT INTO "master"."sys_dict_type" (
  "dict_id", "tenant_id", "dict_name", "dict_type", "create_dept", "create_by", "create_time", "update_by", "update_time", "remark"
)
SELECT *
FROM (
  VALUES
    (2034535000000000001, '000000', '消息类型', 'msg_message_type', 103, 1, now(), NULL::bigint, NULL::timestamp, '消息通知模块-消息类型'),
    (2034535000000000002, '000000', '消息业务类型', 'msg_business_type', 103, 1, now(), NULL::bigint, NULL::timestamp, '消息通知模块-业务类型'),
    (2034535000000000003, '000000', '消息已读状态', 'msg_read_status', 103, 1, now(), NULL::bigint, NULL::timestamp, '消息通知模块-已读状态')
) AS t("dict_id", "tenant_id", "dict_name", "dict_type", "create_dept", "create_by", "create_time", "update_by", "update_time", "remark")
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_type" sdt
  WHERE sdt."dict_type" = t."dict_type"
);

-- Dict data
INSERT INTO "master"."sys_dict_data" (
  "dict_code", "tenant_id", "dict_sort", "dict_label", "dict_value", "dict_type", "css_class", "list_class", "is_default",
  "create_dept", "create_by", "create_time", "update_by", "update_time", "remark"
)
SELECT *
FROM (
  VALUES
    (2034535000000000101, '000000', 1, '普通消息', 'message', 'msg_message_type', '', 'primary', 'Y', 103, 1, now(), NULL::bigint, NULL::timestamp, '普通消息'),
    (2034535000000000102, '000000', 2, '预警信息', 'warning', 'msg_message_type', '', 'danger', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '预警信息'),
    (2034535000000000201, '000000', 1, '手工发送', 'manual', 'msg_business_type', '', 'primary', 'Y', 103, 1, now(), NULL::bigint, NULL::timestamp, '手工发送'),
    (2034535000000000202, '000000', 2, '审核提醒', 'audit', 'msg_business_type', '', 'warning', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '审核提醒'),
    (2034535000000000203, '000000', 3, '超时提醒', 'timeout', 'msg_business_type', '', 'danger', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '超时提醒'),
    (2034535000000000301, '000000', 1, '未读', 'unread', 'msg_read_status', '', 'warning', 'Y', 103, 1, now(), NULL::bigint, NULL::timestamp, '未读'),
    (2034535000000000302, '000000', 2, '已读', 'read', 'msg_read_status', '', 'success', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '已读')
) AS t(
  "dict_code", "tenant_id", "dict_sort", "dict_label", "dict_value", "dict_type", "css_class", "list_class", "is_default",
  "create_dept", "create_by", "create_time", "update_by", "update_time", "remark"
)
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_data" sdd
  WHERE sdd."dict_type" = t."dict_type"
    AND sdd."dict_value" = t."dict_value"
);
