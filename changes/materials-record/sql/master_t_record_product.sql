-- 备案产品管理表
-- 从 test.t_record_product 迁移到 master.t_record_product
-- 迁移规则：
-- 1. 去掉 F_ 前缀，字段名改为小写下划线格式
-- 2. 添加默认字段：tenant_id, create_dept
-- 3. 添加外键关联 master.t_companyinfo (生产企业)
-- 4. 字段映射：
--    F_Id → id
--    F_RecordProductName → record_product_name
--    F_Manufactor → manufactor (关联 t_companyinfo.id)
--    F_RecordNo → record_no
--    F_BeginTime → begin_time
--    F_EndTime → end_time
--    F_EnabledMark → enabled_mark
--    F_CreatorTime → create_time
--    F_CreatorUserId → create_by
--    F_LastModifyTime → update_time
--    F_LastModifyUserId → update_by
--    F_DeleteMark → del_flag
--    F_DeleteTime → delete_time
--    F_DeleteUserId → delete_by
--    F_SendFlag → send_flag
--    F_SocialCreditCode → social_credit_code

CREATE TABLE master.t_record_product (
    id character varying(50) NOT NULL,
    record_product_name character varying(2000),
    manufactur character varying(500),
    manufacture_id character varying(50),
    record_no character varying(200),
    begin_time timestamp without time zone,
    end_time timestamp without time zone,
    enabled_mark integer,
    create_time timestamp without time zone,
    create_by character varying(50),
    update_time timestamp without time zone,
    update_by character varying(50),
    del_flag integer,
    delete_time timestamp without time zone,
    delete_by character varying(50),
    send_flag integer,
    social_credit_code character varying(255),
    tenant_id character varying(50),
    create_dept character varying(50)
);

COMMENT ON TABLE master.t_record_product IS '备案产品管理表';
COMMENT ON COLUMN master.t_record_product.id IS '主键';
COMMENT ON COLUMN master.t_record_product.record_product_name IS '备案产品名称';
COMMENT ON COLUMN master.t_record_product.manufactur IS '生产厂家名称(冗余)';
COMMENT ON COLUMN master.t_record_product.manufacture_id IS '生产企业ID(关联t_companyinfo.id)';
COMMENT ON COLUMN master.t_record_product.record_no IS '备案证号';
COMMENT ON COLUMN master.t_record_product.begin_time IS '备案证有效开始时间';
COMMENT ON COLUMN master.t_record_product.end_time IS '备案证有效结束时间';
COMMENT ON COLUMN master.t_record_product.enabled_mark IS '是否可用';
COMMENT ON COLUMN master.t_record_product.create_time IS '创建时间';
COMMENT ON COLUMN master.t_record_product.create_by IS '创建人';
COMMENT ON COLUMN master.t_record_product.update_time IS '修改时间';
COMMENT ON COLUMN master.t_record_product.update_by IS '修改人';
COMMENT ON COLUMN master.t_record_product.del_flag IS '删除标志';
COMMENT ON COLUMN master.t_record_product.delete_time IS '删除日期';
COMMENT ON COLUMN master.t_record_product.delete_by IS '删除人';
COMMENT ON COLUMN master.t_record_product.send_flag IS '发送标志';
COMMENT ON COLUMN master.t_record_product.social_credit_code IS '统一社会信用代码';
COMMENT ON COLUMN master.t_record_product.tenant_id IS '租户ID';
COMMENT ON COLUMN master.t_record_product.create_dept IS '创建部门';

-- 添加主键
ALTER TABLE master.t_record_product ADD CONSTRAINT pk_t_record_product PRIMARY KEY (id);

-- 创建索引
CREATE INDEX idx_t_record_product_record_no ON master.t_record_product(record_no);
CREATE INDEX idx_t_record_product_del_flag ON master.t_record_product(del_flag);
CREATE INDEX idx_t_record_product_tenant_id ON master.t_record_product(tenant_id);
CREATE INDEX idx_t_record_product_manufacture_id ON master.t_record_product(manufacture_id);

-- 添加外键约束 (关联 master.t_companyinfo，限制为生产企业 F_TYPE=2)
ALTER TABLE master.t_record_product ADD CONSTRAINT fk_record_product_companyinfo FOREIGN KEY (manufacture_id) REFERENCES master.t_companyinfo(id);
