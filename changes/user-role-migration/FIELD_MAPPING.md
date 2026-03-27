# 字段扩展说明

## 一、字段扩展规则

**规则**: 如果Test模式下存在的字段在Master模式下不存在，需要在Master表中新增该字段。

**标注方式**: 使用注释 `-- [需扩展]` 标记需要新增的字段。

---

## 二、字段差异分析

### 2.1 base_user → sys_user

| Test字段 | Master字段 | 说明 | 扩展 |
|---------|-----------|------|------|
| F_Id | user_id (BIGINT) | 用户ID | 需扩展：原ID存储 |
| F_Account | user_name | 账号 | ✅ 已映射 |
| F_RealName | nick_name / create_name | 真实姓名 | ✅ 已映射 |
| F_NickName | nick_name | 昵称 | ✅ 已映射 |
| F_IsAdministrator | - | 是否管理员 | ⚠️ **需扩展** |
| F_OrganizeId | dept_id | 组织ID | ⚠️ **需扩展** |
| F_RoleId | - | 角色ID(逗号分隔) | ⚠️ **需扩展** |
| F_PositionId | - | 岗位ID(逗号分隔) | ⚠️ **需扩展** |
| F_MobilePhone | phonenumber | 手机号 | ✅ 已映射 |
| F_Email | email | 邮箱 | ✅ 已映射 |
| F_Gender | sex | 性别 | ✅ 已映射 |
| F_Password | password | 密码 | ✅ 已映射 |
| F_EnabledMark | status | 状态 | ✅ 已映射 |
| F_DeleteMark | del_flag | 删除标记 | ✅ 已映射 |
| F_LastLogIP | login_ip | 最后登录IP | ✅ 已映射 |
| F_LastLogTime | login_date | 最后登录时间 | ✅ 已映射 |
| F_CreateTime | create_time | 创建时间 | ✅ 已映射 |
| F_ModifyTime | update_time | 更新时间 | ✅ 已映射 |
| F_Birthday | - | 生日 | ⚠️ **需扩展** |
| F_CertificatesType | - | 证件类型 | ⚠️ **需扩展** |
| F_CertificatesNumber | - | 证件号码 | ⚠️ **需扩展** |
| F_Education | - | 学历 | ⚠️ **需扩展** |
| F_EntryDate | - | 入职日期 | ⚠️ **需扩展** |
| F_Landline | - | 座机 | ⚠️ **需扩展** |
| F_UrgentContacts | - | 紧急联系人 | ⚠️ **需扩展** |
| F_UrgentTelePhone | - | 紧急联系电话 | ⚠️ **需扩展** |
| F_PostalAddress | - | 通讯地址 | ⚠️ **需扩展** |
| F_Signature | - | 签名 | ⚠️ **需扩展** |

### 2.2 base_organize → sys_dept

| Test字段 | Master字段 | 说明 | 扩展 |
|---------|-----------|------|------|
| F_Id | dept_id | 部门ID | 需扩展：原ID存储 |
| F_ParentId | parent_id | 父部门ID | ✅ 已映射 |
| F_FullName | dept_name | 部门名称 | ✅ 已映射 |
| F_Category | dept_category | 部门类别 | ✅ 已映射 |
| F_EnCode | - | 部门编码 | ⚠️ **需扩展** |
| F_ManagerId | - | 负责人ID | ⚠️ **需扩展** |
| F_OrganizeIdTree | ancestors | 组织树 | ⚠️ **需扩展** |
| F_EnabledMark | status | 状态 | ✅ 已映射 |
| F_DeleteMark | del_flag | 删除标记 | ✅ 已映射 |

### 2.3 base_position → sys_dept (岗位)

| Test字段 | Master字段 | 说明 | 扩展 |
|---------|-----------|------|------|
| F_Id | dept_id | 岗位ID | 需扩展：原ID存储 |
| F_FullName | dept_name | 岗位名称 | ✅ 已映射 |
| F_EnCode | - | 岗位编码 | ⚠️ **需扩展** |
| F_Type | - | 岗位类型 | ⚠️ **需扩展** |
| F_OrganizeId | parent_id | 所属组织 | ✅ 已映射 |
| F_EnabledMark | status | 状态 | ✅ 已映射 |
| F_DeleteMark | del_flag | 删除标记 | ✅ 已映射 |

---

## 三、需要新增的字段汇总

### 3.1 sys_user 表需扩展字段

```sql
-- [需扩展] 管理员标识：0-普通用户, 1-管理员
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS is_administrator INTEGER DEFAULT 0;

-- [需扩展] 原始用户ID (Test模式的主键)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS original_id VARCHAR(50);

-- [需扩展] 组织ID (关联base_organize)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS organize_id VARCHAR(50);

-- [需扩展] 角色ID列表 (逗号分隔，兼容旧数据)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS role_ids TEXT;

-- [需扩展] 岗位ID列表 (逗号分隔)
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS position_ids TEXT;

-- [需扩展] 生日
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS birthday TIMESTAMP;

-- [需扩展] 证件类型
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS certificates_type VARCHAR(50);

-- [需扩展] 证件号码
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS certificates_number VARCHAR(100);

-- [需扩展] 学历
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS education VARCHAR(50);

-- [需扩展] 入职日期
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS entry_date TIMESTAMP;

-- [需扩展] 座机
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS landline VARCHAR(50);

-- [需扩展] 紧急联系人
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS urgent_contacts VARCHAR(100);

-- [需扩展] 紧急联系电话
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS urgent_tele_phone VARCHAR(50);

-- [需扩展] 通讯地址
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS postal_address TEXT;

-- [需扩展] 签名
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS signature TEXT;
```

### 3.2 sys_dept 表需扩展字段

```sql
-- [需扩展] 原始部门ID (Test模式的主键)
ALTER TABLE sys_dept ADD COLUMN IF NOT EXISTS original_id VARCHAR(50);

-- [需扩展] 部门编码
ALTER TABLE sys_dept ADD COLUMN IF NOT EXISTS en_code VARCHAR(100);

-- [需扩展] 负责人ID
ALTER TABLE sys_dept ADD COLUMN IF NOT EXISTS manager_id VARCHAR(50);
```

---

## 四、字段扩展SQL文件

详见: `sql/000_field_extension.sql`
