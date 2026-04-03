-- Historical migration SQL for t_quality_trace
-- Use only when target master table has not been populated yet.

INSERT INTO "master"."t_quality_trace" (
    "id",
    "original_id",
    "check_organize",
    "project_no",
    "project_name",
    "product_name",
    "factory_name",
    "batch_no",
    "check_project_name",
    "data_status",
    "is_collect",
    "conclusion_mark",
    "conclusion",
    "report_time",
    "check_time",
    "enabled_mark",
    "create_by",
    "create_time",
    "update_by",
    "update_time",
    "delete_by",
    "delete_time",
    "del_flag"
)
SELECT
    "F_Id",
    "F_OriginalId",
    "F_CheckOrganize",
    "F_ProjectNo",
    "F_ProjectName",
    "F_ProductName",
    "F_FactoryName",
    "F_Batch",
    "F_CheckProjectName",
    "F_DataStatus",
    "F_IsCollect",
    "F_ConclusionMark",
    "F_Conclusion",
    "F_ReportTime",
    "F_CheckTime",
    "F_EnabledMark",
    "F_CreatorUserId",
    "F_CreatorTime",
    "F_LastModifyUserId",
    "F_LastModifyTime",
    "F_DeleteUserId",
    "F_DeleteTime",
    COALESCE("F_DeleteMark", 0)
FROM "test"."t_quality_trace" src
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."t_quality_trace" target
  WHERE target.id = src."F_Id"
);
