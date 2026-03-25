-- 企业基础信息表
-- 从 test.t_companyinfo 迁移到 master.t_companyinfo
-- 迁移规则：
-- 1. 去掉 F_ 前缀，字段名改为小写下划线格式
-- 2. 添加默认字段：tenant_id, create_dept
-- 3. F_Type 区分企业类型：1-施工企业，2-生产企业，3-代理商
-- 字段映射：
--    F_Id → id
--    F_CompanyName → company_name
--    F_Area → area
--    F_Address → address
--    F_ContactUser → contact_user
--    F_ContactPhone → contact_phone
--    F_Type → company_type
--    F_ParentId → parent_id
--    F_EnabledMark → enabled_mark
--    F_CreatorUserId → create_by
--    F_CreatorTime → create_time
--    F_LastModifyUserId → update_by
--    F_LastModifyTime → update_time
--    F_DeleteUserId → delete_by
--    F_DeleteTime → delete_time
--    F_DeleteMark → del_flag
--    F_SendFlag → send_flag

CREATE TABLE master.t_companyinfo (
    id character varying(50) NOT NULL,
    company_name character varying(300),
    area character varying(150),
    address character varying(500),
    contact_user character varying(50),
    contact_phone character varying(50),
    company_type integer,
    parent_id character varying(50),
    enabled_mark integer,
    create_time timestamp without time zone,
    create_by character varying(50),
    update_time timestamp without time zone,
    update_by character varying(50),
    delete_time timestamp without time zone,
    delete_by character varying(50),
    del_flag integer,
    send_flag integer,
    tenant_id character varying(50),
    create_dept character varying(50)
);

COMMENT ON TABLE master.t_companyinfo IS '企业基础信息表';
COMMENT ON COLUMN master.t_companyinfo.id IS '主键';
COMMENT ON COLUMN master.t_companyinfo.company_name IS '公司名称';
COMMENT ON COLUMN master.t_companyinfo.area IS '省市区';
COMMENT ON COLUMN master.t_companyinfo.address IS '地址';
COMMENT ON COLUMN master.t_companyinfo.contact_user IS '联系人';
COMMENT ON COLUMN master.t_companyinfo.contact_phone IS '手机';
COMMENT ON COLUMN master.t_companyinfo.company_type IS '企业类型(1-施工企业,2-生产企业,3-代理商)';
COMMENT ON COLUMN master.t_companyinfo.parent_id IS '父级ID';
COMMENT ON COLUMN master.t_companyinfo.enabled_mark IS '有效标志';
COMMENT ON COLUMN master.t_companyinfo.create_time IS '创建时间';
COMMENT ON COLUMN master.t_companyinfo.create_by IS '创建用户';
COMMENT ON COLUMN master.t_companyinfo.update_time IS '修改时间';
COMMENT ON COLUMN master.t_companyinfo.update_by IS '修改用户';
COMMENT ON COLUMN master.t_companyinfo.delete_time IS '删除时间';
COMMENT ON COLUMN master.t_companyinfo.delete_by IS '删除用户';
COMMENT ON COLUMN master.t_companyinfo.del_flag IS '删除标志';
COMMENT ON COLUMN master.t_companyinfo.send_flag IS '发送标记';
COMMENT ON COLUMN master.t_companyinfo.tenant_id IS '租户ID';
COMMENT ON COLUMN master.t_companyinfo.create_dept IS '创建部门';

-- 添加主键
ALTER TABLE master.t_companyinfo ADD CONSTRAINT pk_t_companyinfo PRIMARY KEY (id);

-- 创建索引
CREATE INDEX idx_t_companyinfo_company_type ON master.t_companyinfo(company_type);
CREATE INDEX idx_t_companyinfo_del_flag ON master.t_companyinfo(del_flag);
CREATE INDEX idx_t_companyinfo_tenant_id ON master.t_companyinfo(tenant_id);
CREATE INDEX idx_t_companyinfo_company_name ON master.t_companyinfo(company_name);
CREATE INDEX idx_t_companyinfo_enabled_mark ON master.t_companyinfo(enabled_mark);
