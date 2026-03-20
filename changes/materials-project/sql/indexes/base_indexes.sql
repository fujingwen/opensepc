-- ----------------------------
-- Indexes for mat_project
-- ----------------------------

DROP INDEX IF EXISTS "master"."idx_project_name";
CREATE INDEX "idx_project_name" ON "master"."mat_project" ("project_name");

DROP INDEX IF EXISTS "master"."idx_construction_permit";
CREATE INDEX "idx_construction_permit" ON "master"."mat_project" ("construction_permit");

DROP INDEX IF EXISTS "master"."idx_construction_unit";
CREATE INDEX "idx_construction_unit" ON "master"."mat_project" ("construction_unit");

DROP INDEX IF EXISTS "master"."idx_project_progress";
CREATE INDEX "idx_project_progress" ON "master"."mat_project" ("project_progress");

DROP INDEX IF EXISTS "master"."idx_quality_supervision_agency";
CREATE INDEX "idx_quality_supervision_agency" ON "master"."mat_project" ("quality_supervision_agency");
