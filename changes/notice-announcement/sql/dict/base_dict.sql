INSERT INTO "master"."sys_dict_type" (
  "dict_id", "tenant_id", "dict_name", "dict_type", "create_dept", "create_by", "create_time", "update_by", "update_time", "remark"
)
SELECT *
FROM (
  VALUES
    (2034535000000000004, '000000', '公告类型', 'msg_notice_type', 103, 1, now(), NULL::bigint, NULL::timestamp, '通知公告模块-公告类型'),
    (2034535000000000005, '000000', '公告发布状态', 'msg_publish_status', 103, 1, now(), NULL::bigint, NULL::timestamp, '通知公告模块-发布状态')
) AS t("dict_id", "tenant_id", "dict_name", "dict_type", "create_dept", "create_by", "create_time", "update_by", "update_time", "remark")
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."sys_dict_type" sdt
  WHERE sdt."dict_type" = t."dict_type"
);

INSERT INTO "master"."sys_dict_data" (
  "dict_code", "tenant_id", "dict_sort", "dict_label", "dict_value", "dict_type", "css_class", "list_class", "is_default",
  "create_dept", "create_by", "create_time", "update_by", "update_time", "remark"
)
SELECT *
FROM (
  VALUES
    (2034535000000000401, '000000', 1, '系统公告', 'system', 'msg_notice_type', '', 'primary', 'Y', 103, 1, now(), NULL::bigint, NULL::timestamp, '系统公告'),
    (2034535000000000402, '000000', 2, '库存信息发布', 'inventory', 'msg_notice_type', '', 'success', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '库存信息发布'),
    (2034535000000000403, '000000', 3, '采购信息发布', 'purchase', 'msg_notice_type', '', 'warning', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '采购信息发布'),
    (2034535000000000500, '000000', 1, '草稿', 'draft', 'msg_publish_status', '', 'info', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '草稿'),
    (2034535000000000501, '000000', 2, '已发布', 'published', 'msg_publish_status', '', 'success', 'Y', 103, 1, now(), NULL::bigint, NULL::timestamp, '已发布'),
    (2034535000000000502, '000000', 3, '已关闭', 'closed', 'msg_publish_status', '', 'danger', 'N', 103, 1, now(), NULL::bigint, NULL::timestamp, '已关闭')
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
