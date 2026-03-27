# 用户权限数据迁移提案

## Why

系统从Test模式（FlowEngine/Jeepage旧系统）迁移到Master模式（RuoYi-Cloud-Plus新系统），需要将原有的用户、组织、岗位、角色数据完整迁移到新系统，以实现：
- 统一用户权限管理
- 保留历史业务数据
- 平滑过渡不中断业务

当前两套系统数据隔离，无法共享用户资源，需要建立数据映射关系。

## What Changes

- 扩展 `sys_user` 表：新增15个字段用于存储Test模式的用户扩展信息
- 扩展 `sys_dept` 表：新增3个字段用于存储组织/部门扩展信息
- 数据迁移：将 `base_user`、`base_organize`、`base_position`、`base_userrelation` 表数据迁移到新系统对应表
- ID映射策略：将Test模式的VARCHAR类型ID转换为Master模式的BIGINT自增ID

## Capabilities

### New Capabilities

- **用户数据迁移**: 将Test模式的 `base_user` 表（5233条记录）迁移到 `sys_user` 表
- **组织数据迁移**: 将Test模式的 `base_organize` 表（46条记录）迁移到 `sys_dept` 表
- **岗位数据迁移**: 将Test模式的 `base_position` 表（52条记录）迁移到 `sys_post` 表
- **角色数据迁移**: 将Test模式的角色数据迁移到 `sys_role` 表
- **用户-角色关系迁移**: 将 `base_userrelation` 表（5220条记录）迁移到 `sys_user_role` 表

### Modified Capabilities

- **sys_user 表扩展**: 新增15个字段存储Test模式扩展信息
- **sys_dept 表扩展**: 新增3个字段存储部门扩展信息

## Impact

### 数据库

#### 字段扩展 - sys_user 表

| 字段名 | 类型 | 说明 | 来源字段 |
|-------|------|------|---------|
| is_administrator | integer | 管理员标识（0-普通用户,1-管理员） | F_IsAdministrator |
| original_id | varchar(50) | 原始用户ID（Test模式主键） | F_Id |
| organize_id | varchar(50) | 组织ID | F_OrganizeId |
| role_ids | text | 角色ID列表（逗号分隔） | F_RoleId |
| position_ids | text | 岗位ID列表（逗号分隔） | F_PositionId |
| birthday | timestamp | 生日 | F_Birthday |
| certificates_type | varchar(50) | 证件类型 | F_CertificatesType |
| certificates_number | varchar(100) | 证件号码 | F_CertificatesNumber |
| education | varchar(50) | 学历 | F_Education |
| entry_date | timestamp | 入职日期 | F_EntryDate |
| landline | varchar(50) | 座机 | F_Landline |
| urgent_contacts | varchar(100) | 紧急联系人 | F_UrgentContacts |
| urgent_tele_phone | varchar(50) | 紧急联系电话 | F_UrgentTelePhone |
| postal_address | text | 通讯地址 | F_PostalAddress |
| signature | text | 签名 | F_Signature |

#### 字段扩展 - sys_dept 表

| 字段名 | 类型 | 说明 | 来源字段 |
|-------|------|------|---------|
| original_id | varchar(50) | 原始部门ID（Test模式主键） | F_Id |
| en_code | varchar(100) | 部门编码 | F_EnCode |
| manager_id | varchar(50) | 负责人ID | F_ManagerId |

#### 数据迁移统计

| 操作 | 源表 | 目标表 | 数据量 | 状态 |
|------|------|--------|--------|------|
| 字段扩展 | - | sys_user | 15个字段 | ✅ 已完成 |
| 字段扩展 | - | sys_dept | 3个字段 | ✅ 已完成 |
| 组织迁移 | test.base_organize | master.sys_dept | 33条 | ✅ 已完成 |
| 岗位迁移 | test.base_position | master.sys_post | 52条 | ✅ 已完成 |
| 角色迁移 | test.base_userrelation | master.sys_role | 18条 | ✅ 已完成 |
| 用户迁移 | test.base_user | master.sys_user | ~5000条 | ⏳ 待执行 |
| 用户角色关系迁移 | test.base_userrelation | master.sys_user_role | 4914条 | ✅ 已完成 |

### 执行顺序

```
0. 字段扩展 (sql/000_field_extension.sql)          ──► 已完成
1. 组织迁移 (sql/001_dept_migration.sql)           ──► 已完成
2. 岗位迁移 (sql/002_position_migration.sql)       ──► 已完成
3. 角色迁移 (sql/003_role_migration.sql)           ──► 已完成
4. 用户迁移 (sql/004_user_migration.sql)           ──► 待执行
5. 用户角色关系迁移 (sql/005_user_role_migration.sql) ──► 已完成
```

### ID映射策略

由于Test模式使用VARCHAR类型ID，Master模式使用BIGINT自增ID，采用Hash映射：

| 类型 | ID范围 | 映射公式 |
|-----|-------|---------|
| 部门 | 100+ | (ABS(HASHTEXT(VARCHAR_ID)) % 1000000000) + 100 |
| 岗位 | 200+ | (ABS(HASHTEXT(VARCHAR_ID)) % 100000000) + 200 |
| 角色 | 1000+ | (ABS(HASHTEXT(VARCHAR_ID)) % 100000000) + 1000 |
| 用户 | 1000+ | (ABS(HASHTEXT(VARCHAR_ID)) % 100000000) + 1000 |

### 文件结构

```
openspec/changes/user-role-migration/
├── proposal.md                  # 提案主文档（本文档）
├── FIELD_MAPPING.md             # 字段映射说明
├── 角色.json                    # 角色数据示例
├── README.md                    # 执行记录
├── 问题记录.md                  # 问题记录
└── sql/
    ├── 000_field_extension.sql  # 步骤0：字段扩展（已执行）
    ├── 001_dept_migration.sql   # 步骤1：组织迁移（已执行）
    ├── 002_position_migration.sql# 步骤2：岗位迁移（已执行）
    ├── 003_role_migration.sql   # 步骤3：角色迁移（已执行）
    ├── 004_user_migration.sql   # 步骤4：用户迁移（待执行）
    └── 005_user_role_migration.sql# 步骤5：用户角色关系（已执行）
```

## Implementation

### 表关系映射

**Test模式（迁移前）**：
```
base_user
  ├── F_OrganizeId ──────► base_organize.F_Id (组织)
  ├── F_RoleId ──────────► 角色ID (逗号分隔)
  └── F_PositionId ──────► base_position.F_Id (岗位)

base_userrelation
  ├── F_UserId ──────────► base_user.F_Id
  ├── F_ObjectType ───────► Role/Position
  └── F_ObjectId ─────────► 角色或岗位ID
```

**Master模式（迁移后）**：
```
sys_user
  ├── dept_id ──────────► sys_dept.dept_id
  ├── organize_id ──────► sys_dept.original_id (通过扩展字段关联)
  └── sys_user_role ────► sys_role.role_id
```

### 字段映射详情

#### base_user → sys_user

| Test字段 | Master字段 | 说明 | 扩展 |
|---------|-----------|------|------|
| F_Id | user_id (BIGINT) | 用户ID | 需扩展：原ID存储 → original_id |
| F_Account | user_name | 账号 | ✅ 已映射 |
| F_RealName | nick_name / create_name | 真实姓名 | ✅ 已映射 |
| F_NickName | nick_name | 昵称 | ✅ 已映射 |
| F_IsAdministrator | - | 是否管理员 | ⚠️ **需扩展** → is_administrator |
| F_OrganizeId | dept_id | 组织ID | ⚠️ **需扩展** → organize_id |
| F_RoleId | - | 角色ID(逗号分隔) | ⚠️ **需扩展** → role_ids |
| F_PositionId | - | 岗位ID(逗号分隔) | ⚠️ **需扩展** → position_ids |
| F_MobilePhone | phonenumber | 手机号 | ✅ 已映射 |
| F_Email | email | 邮箱 | ✅ 已映射 |
| F_Gender | sex | 性别 | ✅ 已映射 |
| F_Password | password | 密码 | ✅ 已映射（重置为Hny@2022）|
| F_EnabledMark | status | 状态 | ✅ 已映射 |
| F_DeleteMark | del_flag | 删除标记 | ✅ 已映射 |
| F_LastLogIP | login_ip | 最后登录IP | ✅ 已映射 |
| F_LastLogTime | login_date | 最后登录时间 | ✅ 已映射 |
| F_CreateTime | create_time | 创建时间 | ✅ 已映射 |
| F_ModifyTime | update_time | 更新时间 | ✅ 已映射 |
| F_Birthday | - | 生日 | ⚠️ **需扩展** → birthday |
| F_CertificatesType | - | 证件类型 | ⚠️ **需扩展** → certificates_type |
| F_CertificatesNumber | - | 证件号码 | ⚠️ **需扩展** → certificates_number |
| F_Education | - | 学历 | ⚠️ **需扩展** → education |
| F_EntryDate | - | 入职日期 | ⚠️ **需扩展** → entry_date |
| F_Landline | - | 座机 | ⚠️ **需扩展** → landline |
| F_UrgentContacts | - | 紧急联系人 | ⚠️ **需扩展** → urgent_contacts |
| F_UrgentTelePhone | - | 紧急联系电话 | ⚠️ **需扩展** → urgent_tele_phone |
| F_PostalAddress | - | 通讯地址 | ⚠️ **需扩展** → postal_address |
| F_Signature | - | 签名 | ⚠️ **需扩展** → signature |

#### base_organize → sys_dept

| Test字段 | Master字段 | 说明 | 扩展 |
|---------|-----------|------|------|
| F_Id | dept_id | 部门ID | 需扩展：原ID存储 → original_id |
| F_ParentId | parent_id | 父部门ID | ✅ 已映射 |
| F_FullName | dept_name | 部门名称 | ✅ 已映射 |
| F_Category | dept_category | 部门类别 | ✅ 已映射 |
| F_EnCode | - | 部门编码 | ⚠️ **需扩展** → en_code |
| F_ManagerId | - | 负责人ID | ⚠️ **需扩展** → manager_id |
| F_OrganizeIdTree | ancestors | 组织树 | ⚠️ **需扩展** → ancestors |
| F_EnabledMark | status | 状态 | ✅ 已映射 |
| F_DeleteMark | del_flag | 删除标记 | ✅ 已映射 |

#### base_position → sys_post

| Test字段 | Master字段 | 说明 | 扩展 |
|---------|-----------|------|------|
| F_Id | post_id | 岗位ID | 需扩展：原ID存储 |
| F_FullName | post_name | 岗位名称 | ✅ 已映射 |
| F_EnCode | post_code | 岗位编码 | ✅ 已映射 |
| F_Type | post_category | 岗位类型 | ⚠️ **需扩展** |
| F_OrganizeId | dept_id | 所属组织 | ✅ 已映射 |
| F_EnabledMark | status | 状态 | ✅ 已映射 |
| F_DeleteMark | del_flag | 删除标记 | ✅ 已映射 |

## Rollback

如需回滚，执行以下SQL：

```sql
SET search_path TO master;

-- 删除迁移的数据
DELETE FROM sys_user_role WHERE user_id >= 1000;
DELETE FROM sys_user WHERE user_id >= 1000;
DELETE FROM sys_role WHERE role_id >= 1000;
DELETE FROM sys_post WHERE post_id >= 200;
DELETE FROM sys_dept WHERE dept_id >= 200;
DELETE FROM sys_dept WHERE dept_id >= 100;

-- 可选：删除扩展字段
ALTER TABLE sys_user DROP COLUMN IF EXISTS is_administrator;
ALTER TABLE sys_user DROP COLUMN IF EXISTS original_id;
ALTER TABLE sys_user DROP COLUMN IF EXISTS organize_id;
ALTER TABLE sys_user DROP COLUMN IF EXISTS role_ids;
ALTER TABLE sys_user DROP COLUMN IF EXISTS position_ids;
ALTER TABLE sys_user DROP COLUMN IF EXISTS birthday;
ALTER TABLE sys_user DROP COLUMN IF EXISTS certificates_type;
ALTER TABLE sys_user DROP COLUMN IF EXISTS certificates_number;
ALTER TABLE sys_user DROP COLUMN IF EXISTS education;
ALTER TABLE sys_user DROP COLUMN IF EXISTS entry_date;
ALTER TABLE sys_user DROP COLUMN IF EXISTS landline;
ALTER TABLE sys_user DROP COLUMN IF EXISTS urgent_contacts;
ALTER TABLE sys_user DROP COLUMN IF EXISTS urgent_tele_phone;
ALTER TABLE sys_user DROP COLUMN IF EXISTS postal_address;
ALTER TABLE sys_user DROP COLUMN IF EXISTS signature;
ALTER TABLE sys_dept DROP COLUMN IF EXISTS original_id;
ALTER TABLE sys_dept DROP COLUMN IF EXISTS en_code;
ALTER TABLE sys_dept DROP COLUMN IF EXISTS manager_id;
```

## Acceptance Criteria

### 功能验收

- [x] 字段扩展SQL执行成功，无报错
- [x] 组织迁移完成，数据完整（33条）
- [x] 岗位迁移完成，数据完整（52条）
- [x] 角色迁移完成，数据完整（18条）
- [x] 用户-角色关系迁移完成，数据完整（4914条）
- [ ] 用户迁移完成，数据完整

### 数据验收

- [x] 部门/组织数据：33条记录正确迁移
- [x] 岗位数据：52条记录正确迁移到 sys_post
- [x] 角色数据：18条记录正确迁移到 sys_role
- [x] 用户角色关系：4914条记录正确迁移到 sys_user_role
- [ ] 用户数据：约5000条记录待迁移

### ID映射验证

- [x] 部门ID范围：100+
- [x] 岗位ID范围：200+
- [x] 角色ID范围：1000+
- [x] 用户ID范围：1000+

### 回滚验收

- [ ] 回滚SQL执行成功，无报错
- [ ] 回滚后数据完全恢复

## Notes

1. **密码处理**: 迁移的用户密码会被重置为默认密码 `Hny@2022`
2. **数据覆盖**: 相同账号的用户会被更新（如果使用ON CONFLICT）
3. **ID冲突**: 如果映射后的ID与现有数据冲突，需要调整映射策略
4. **角色名称**: 迁移的角色使用自动生成的名称，需要后续手动维护
5. **用户-企业关联**: 迁移后sys_user通过organize_id字段关联到部门，再通过部门关联企业
6. **已有角色保留**: 原有角色（如超级管理员、生产企业等）未删除，与迁移角色共存