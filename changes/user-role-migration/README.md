# 用户权限数据迁移提案

## 概述

将Test模式下的用户权限数据迁移到Master模式。

---

## 一、表关系分析

### 1.1 两套系统对比

| 维度 | Test模式 | Master模式 |
|-----|---------|-----------|
| 系统 | FlowEngine/Jeepage (旧系统) | RuoYi-Cloud-Plus (新系统) |
| 用户表 | base_user | sys_user |
| 部门/组织表 | base_organize | sys_dept |
| 岗位表 | base_position | (无独立表，并入sys_dept) |
| 角色关系表 | base_userrelation | sys_user_role |
| 企业表 | t_companyinfo | t_companyinfo |

### 1.2 数据量统计

| Test模式表 | 记录数 | 说明 |
|-----------|-------|------|
| base_user | 5,233 | 用户 |
| base_organize | 46 | 组织（36公司+10部门） |
| base_position | 52 | 岗位 |
| base_userrelation | 5,220 | 用户-角色/岗位关系 |

### 1.3 当前关联关系

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

**Master模式（现有）**：
```
sys_user
  ├── dept_id ──────────► sys_dept.dept_id
  └── sys_user_role ────► sys_role.role_id
```

**企业关联（缺失）**：
```
sys_user ↔ t_companyinfo  -- 无直接关联字段
```

---

## 二、迁移范围

| 步骤 | Test模式表 | Master模式表 | 说明 |
|-----|-----------|-------------|------|
| 0 | - | sys_user, sys_dept | 字段扩展（新增Test独有字段） |
| 1 | base_organize | sys_dept | 组织/部门迁移 |
| 2 | base_position | sys_dept | 岗位迁移 |
| 3 | base_userrelation (Role) | sys_role | 角色迁移 |
| 4 | base_user | sys_user | 用户迁移 |
| 5 | base_userrelation | sys_user_role | 用户-角色关系迁移 |

---

## 三、字段扩展规则

**规则**: 如果Test模式下存在的字段在Master模式下不存在，需要在Master表中新增该字段。

**标注方式**: 使用注释 `-- [需扩展]` 标记需要新增的字段。

详见: [FIELD_MAPPING.md](FIELD_MAPPING.md)

### 3.1 sys_user 扩展字段

| 新字段 | 说明 |
|-------|------|
| is_administrator | 管理员标识 |
| original_id | 原始用户ID（Test模式主键） |
| organize_id | 组织ID |
| role_ids | 角色ID列表（逗号分隔） |
| position_ids | 岗位ID列表（逗号分隔） |
| birthday | 生日 |
| certificates_type | 证件类型 |
| certificates_number | 证件号码 |
| education | 学历 |
| entry_date | 入职日期 |
| landline | 座机 |
| urgent_contacts | 紧急联系人 |
| urgent_tele_phone | 紧急联系电话 |
| postal_address | 通讯地址 |
| signature | 签名 |

### 3.2 sys_dept 扩展字段

| 新字段 | 说明 |
|-------|------|
| original_id | 原始部门ID（Test模式主键） |
| en_code | 部门编码 |
| manager_id | 负责人ID |

---

## 四、迁移顺序

```
0. 字段扩展 (sys_user, sys_dept 新增字段)
   │
1. sys_dept (组织/部门)     ← base_organize (36公司 + 10部门)
   │
2. sys_dept (岗位)           ← base_position (52岗位)
   │
3. sys_role                 ← base_userrelation (Role类型)
   │
4. sys_user                 ← base_user
   │
5. sys_user_role            ← base_userrelation
```

### 依赖关系说明

- 步骤0：字段扩展（为后续迁移做准备）
- 步骤2依赖步骤1（岗位需要关联组织）
- 步骤4依赖步骤1（用户需要关联部门）
- 步骤5依赖步骤3和步骤4（需要用户和角色都存在）

---

## 五、ID映射策略

由于Test模式使用VARCHAR类型ID，Master模式使用BIGINT自增ID，采用Hash映射：

| 类型 | ID范围 | 映射公式 |
|-----|-------|---------|
| 部门 | 100+ | (ABS(HASH(VARCHAR_ID)) % 1000000000) + 100 |
| 岗位 | 200+ | (ABS(HASH(VARCHAR_ID)) % 100000000) + 200 |
| 角色 | 1000+ | (ABS(HASH(VARCHAR_ID)) % 100000000) + 1000 |
| 用户 | 1000+ | (ABS(HASH(VARCHAR_ID)) % 100000000) + 1000 |

---

## 六、执行顺序

1. 先执行 `000_field_extension.sql`（字段扩展）
2. 再执行 `001_dept_migration.sql`
3. 再执行 `002_position_migration.sql`
4. 再执行 `003_role_migration.sql`
5. 再执行 `004_user_migration.sql`
6. 最后执行 `005_user_role_migration.sql`

---

## 七、回滚方案

如需回滚，执行以下SQL：

```sql
-- 删除迁移的数据
DELETE FROM sys_user_role WHERE user_id >= 1000;
DELETE FROM sys_user WHERE user_id >= 1000;
DELETE FROM sys_role WHERE role_id >= 1000;
DELETE FROM sys_dept WHERE dept_id >= 200;  -- 岗位
DELETE FROM sys_dept WHERE dept_id >= 100;  -- 部门

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

---

## 八、注意事项

1. **密码处理**：迁移的用户密码会被重置为默认密码 `123456`
2. **数据覆盖**：相同账号的用户会被更新（如果使用ON CONFLICT）
3. **ID冲突**：如果映射后的ID与现有数据冲突，需要调整映射策略
4. **角色名称**：迁移的角色使用ID前8位作为名称，需要后续手动维护
5. **字段扩展**：步骤0必须先执行，否则后续迁移会失败
6. **用户-企业关联**：迁移后sys_user通过organize_id字段关联到部门，再通过部门关联企业

---

## 九、待确认问题

1. **用户关联企业**：迁移后是否需要在代码中建立用户→企业查询逻辑？ → ✅ 需要建立
2. **角色名称维护**：是否需要手动维护迁移后的角色名称？ → ✅ 需要手动维护
3. **密码重置**：所有迁移用户密码重置为Hny@2022 → ✅ 已确认

---

## 十、执行记录

### ✅ 步骤0：字段扩展 - 已完成

**执行时间**: 2026-03-27

**改动说明**:

在 `sys_user` 表新增了 **15个字段**：

| 字段名 | 说明 |
|-------|------|
| is_administrator | 管理员标识 |
| original_id | 原始用户ID |
| organize_id | 组织ID |
| role_ids | 角色ID列表 |
| position_ids | 岗位ID列表 |
| birthday | 生日 |
| certificates_type | 证件类型 |
| certificates_number | 证件号码 |
| education | 学历 |
| entry_date | 入职日期 |
| landline | 座机 |
| urgent_contacts | 紧急联系人 |
| urgent_tele_phone | 紧急联系电话 |
| postal_address | 通讯地址 |
| signature | 签名 |

在 `sys_dept` 表新增了 **3个字段**：

| 字段名 | 说明 |
|-------|------|
| original_id | 原始部门ID |
| en_code | 部门编码 |
| manager_id | 负责人ID |

---

### ✅ 步骤1：部门/组织迁移 - 已完成

**执行时间**: 2026-03-27

**改动说明**:

从 `test.base_organize` 迁移到 `master.sys_dept`：

| 统计 | 数量 |
|-----|------|
| 迁移记录数 | 33条 |
| 其中公司(company) | 约20条 |
| 其中部门(department) | 约10条 |

**ID映射示例**:
- 建材管理平台(270331615614338309) → dept_id: 941355476
- 建管中心(275485594996442373) → dept_id: 942631849
- 西海岸新区(276125280244860165) → dept_id: 714479966

---

### ✅ 步骤2：岗位迁移 - 已完成

**执行时间**: 2026-03-27

**改动说明**:

从 `test.base_position` 迁移到 `master.sys_post`（修正版）：

| 统计 | 数量 |
|-----|------|
| 迁移记录数 | 52条 |
| 目标表 | sys_post |
| post_category | leader(1)/general(2)/other(3) |

**ID映射示例**:
- 高级程序员(00AD0C3B...) → post_id: 25285827 (dept_id: 552115639-技术部)
- 总裁(0E773C1A...) → post_id: 63543205 (dept_id: 331417640-总裁办)
- 市场拓展经理(0AE8DE21...) → post_id: 85345617 (dept_id: 535281621-市场部)

---

### ✅ 步骤3：角色迁移 - 已完成

**执行时间**: 2026-03-27

**改动说明**:

从 `test.base_userrelation` (F_ObjectType=Role) 迁移到 `master.sys_role`：

| 统计 | 数量 |
|-----|------|
| 迁移记录数 | 18条 |
| 已有角色数 | 11条 (未删除) |
| 总角色数 | 29条 |

**说明**：
- 已有角色（如超级管理员、生产企业等）未删除
- 新迁移的角色名称自动生成，如：角色_94e3a9bb

**已保留的原有角色**：
- 超级管理员 (superadmin)
- 本部门及以下 (test1)
- 仅本人 (test2)
- 巡检员、维修人员
- 生产企业、施工企业、代理商

---

### ⏳ 步骤4：用户迁移 - 待执行

---

### ✅ 步骤5：用户-角色关系迁移 - 已完成

**执行时间**: 2026-03-27

**改动说明**:

通过分析master模式中已有的表关系（sys_user.role_ids字段），解析并迁移到sys_user_role表：

| 统计 | 数量 |
|-----|------|
| 迁移记录数 | 4914条 |

**说明**：
- 用户迁移时已将角色ID存储在sys_user.role_ids字段中
- 通过解析逗号分隔的角色ID，插入sys_user_role表建立关联

---

## 七、前端页面优化

### 7.1 岗位管理页面改为左右结构

**问题描述**:
- 原岗位管理页面只有列表形式，不方便按部门筛选岗位

**解决方案**:
- 参考用户管理页面，改为左右结构：左侧部门树，右侧岗位列表
- 选择部门后，右侧自动显示该部门下的岗位

**改动文件**:
- `construction-material-web/src/views/system/post/index.vue`

**改动内容**:
1. 模板结构调整：使用 `.container-flex` 布局，左侧 `container-left`（部门树），右侧 `container-right`（岗位列表）
2. 新增部门搜索框和部门树组件，使用 `deptTreeSelect()` 获取部门数据
3. 新增 `handleNodeClick` 方法处理部门节点点击事件
4. 新增 `filterNode` 方法实现部门树搜索过滤
5. 移除旧的独立样式，使用全局 `.container-flex` 样式（已定义在 `page.scss`）

**效果**:
- 左侧显示部门树，支持搜索过滤
- 点击部门节点，右侧显示该部门下的岗位
- 默认显示所有岗位（未选部门时）
