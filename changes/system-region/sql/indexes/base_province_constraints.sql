-- base_province 约束与索引修复

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conrelid = 'master.base_province'::regclass
          AND conname = 'pk_base_province'
    ) THEN
        ALTER TABLE master.base_province
            ADD CONSTRAINT pk_base_province PRIMARY KEY (id);
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS uk_base_province_en_code_active
    ON master.base_province (en_code)
    WHERE COALESCE(del_flag, 0) = 0
      AND en_code IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_base_province_parent_id
    ON master.base_province (parent_id);

CREATE INDEX IF NOT EXISTS idx_base_province_del_flag
    ON master.base_province (del_flag);
