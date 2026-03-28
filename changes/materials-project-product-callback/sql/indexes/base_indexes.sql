CREATE INDEX IF NOT EXISTS idx_t_project_project_name
    ON master.t_project (project_name);

CREATE INDEX IF NOT EXISTS idx_t_project_construction_unit
    ON master.t_project (construction_unit);

CREATE INDEX IF NOT EXISTS idx_t_project_progress
    ON master.t_project (project_progress);
