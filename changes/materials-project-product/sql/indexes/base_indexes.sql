CREATE INDEX IF NOT EXISTS idx_t_project_project_name
    ON master.t_project (project_name);

CREATE INDEX IF NOT EXISTS idx_t_project_construction_unit
    ON master.t_project (construction_unit);

CREATE INDEX IF NOT EXISTS idx_t_project_progress
    ON master.t_project (project_progress);

CREATE INDEX IF NOT EXISTS idx_t_project_active_create_time
    ON master.t_project (create_time DESC)
    WHERE COALESCE(del_flag, 0) = 0;

CREATE INDEX IF NOT EXISTS idx_t_project_product_active_create_time
    ON master.t_project_product (create_time DESC)
    WHERE COALESCE(del_flag, 0) = 0;
