INSERT INTO "master"."t_product_relation" (
  "id",
  "product_id",
  "legacy_check_product_id",
  "status",
  "create_by",
  "create_time",
  "del_flag",
  "create_dept"
)
SELECT
  "F_Id",
  "F_ProductId",
  "F_CheckProductId",
  COALESCE("F_Status", 1),
  '1',
  now(),
  0,
  '103'
FROM "test"."t_product_relation" src
WHERE NOT EXISTS (
  SELECT 1
  FROM "master"."t_product_relation" target
  WHERE target.id = src."F_Id"
);
