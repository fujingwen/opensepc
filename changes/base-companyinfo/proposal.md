# 企业信息管理提案

## Why

系统需要对企业进行统一管理，当前通过 `t_companyinfo` 表的 `company_type` 字段区分三种企业类型：

- `company_type = 1`: 施工企业
- `company_type = 2`: 生产企业
- `company_type = 3`: 代理商

需要实现对这三类企业的完整CRUD管理功能。

## What Changes

- 新增"施工企业管理"页面（F_TYPE=1）：实现新增、删除、修改、查询、导出功能
- 新增"生产企业管理"页面（F_TYPE=2）：实现新增、删除、修改、查询、导出功能
- 新增"代理商管理"页面（F_TYPE=3）：实现新增、删除、修改、查询、导出功能
- 实现省市区三级联动选择功能
- 实现电话号码格式验证
- 实现数据导出功能
- **新增企业时自动创建用户并分配角色**
  - 新增生产企业时：自动在 `sys_user` 表创建用户，分配"生产单位人员"角色
  - 新增施工企业时：自动在 `sys_user` 表创建用户，分配"施工单位人员"角色
  - 新增代理商时：自动在 `sys_user` 表创建用户，分配"供应商人员"角色

## Capabilities

### New Capabilities

- `base_companyinfo`: 企业信息管理，通过 company_type 字段区分三种类型
  - 施工企业管理（company_type=1）
  - 生产企业管理（company_type=2）
  - 代理商管理（company_type=3）

### Modified Capabilities

- 统一使用 t_companyinfo 表存储所有企业信息，废弃独立的 base_production、base_construction、base_agent 表
- 新增企业时自动关联创建系统用户（自动创建用户+分配角色）

## Impact

### 文件结构

```
├── 后端代码
│   ├── controller: BaseCompanyInfoController.java
│   ├── service: BaseCompanyInfoService.java
│   ├── mapper: BaseCompanyInfoMapper.java
│   └── model: BaseCompanyInfo.java
│
├── 前端代码
│   ├── views/base/companyinfo/construction.vue   # 施工企业
│   ├── views/base/companyinfo/production.vue    # 生产企业
│   ├── views/base/companyinfo/agent.vue          # 代理商
│   └── api/base/companyinfo.js
│
└── 数据库表SQL脚本
    ├── sql/tables/master_t_companyinfo.sql       # 已有
    ├── sql/menu/base_companyinfo_menu.sql
    └── sql/sequences/seq_t_companyinfo.sql        # 已有
```

### 现有数据迁移

- 将 base_production、base_construction、base_agent 表的数据迁移到 t_companyinfo
- 根据原表设置对应的 company_type 值

### 菜单和权限

基于数据库现有权限设计：

| 菜单ID | 菜单名称 | 父级ID | 路径 | 组件 | 权限标识 |
|--------|---------|--------|------|------|---------|
| 5000001 | 基础数据 | 0 | base | - | - |
| 5000002 | 生产企业 | 5000001 | production | base/production/index | base:production:list |
| 5000003 | 查询 | 5000002 | - | - | base:production:query |
| 5000004 | 新增 | 5000002 | - | - | base:production:add |
| 5000005 | 修改 | 5000002 | - | - | base:production:edit |
| 5000006 | 删除 | 5000002 | - | - | base:production:remove |
| 5000007 | 导出 | 5000002 | - | - | base:production:export |
| 5000008 | 施工企业 | 5000001 | construction | base/construction/index | base:construction:list |
| 5000009 | 查询 | 5000008 | - | - | base:construction:query |
| 5000010 | 新增 | 5000008 | - | - | base:construction:add |
| 5000011 | 修改 | 5000008 | - | - | base:construction:edit |
| 5000012 | 删除 | 5000008 | - | - | base:construction:remove |
| 5000013 | 导出 | 5000008 | - | - | base:construction:export |
| 5000014 | 代理商 | 5000001 | agent | base/agent/index | base:agent:list |
| 5000015 | 查询 | 5000014 | - | - | base:agent:query |
| 5000016 | 新增 | 5000014 | - | - | base:agent:add |
| 5000017 | 修改 | 5000014 | - | - | base:agent:edit |
| 5000018 | 删除 | 5000014 | - | - | base:agent:remove |
| 5000019 | 导出 | 5000014 | - | - | base:agent:export |

### 新增企业自动创建用户逻辑

#### 角色映射关系

| 企业类型 | company_type | 分配角色 | role_key |
|---------|-------------|---------|----------|
| 生产企业 | 2 | 生产单位人员 | scdwry |
| 施工企业 | 1 | 施工单位人员 | sgdwry |
| 代理商 | 3 | 供应商人员 | gysjs |

#### 角色ID（待确认）

| 角色名称 | 角色Key | role_id |
|---------|--------|---------|
| 生产单位人员 | scdwry | 275393296988112133 |
| 施工单位人员 | sgdwry | 275855349104248069 |
| 供应商人员 | gysjs | 305829674242540805 |

#### 用户创建规则

当新增企业时，自动创建配套用户：

| 字段 | 取值 |
|------|------|
| user_name | 企业名称（companyName） |
| nick_name | 企业名称（companyName） |
| password | 默认密码 Hny@2022 |
| status | 正常（0） |
| role_ids | 根据企业类型分配对应角色 |
| dept_id | 无（NULL）或创建对应部门 |
| phonenumber | 企业联系电话（contactPhone） |
| email | 暂无（空） |
| tenant_id | 000000（默认租户） |

#### 实现方式

1. **Service层扩展**: 在 `BaseCompanyInfoServiceImpl.insertBaseCompanyInfo()` 方法中
   - 企业插入成功后，调用 SysUserService 创建用户
   - 根据 companyType 查询对应角色ID
   - 构建 SysUserBo 并插入用户
   - 自动建立用户与企业之间的关联

2. **用户-企业关联**: 通过以下方式之一建立关联
   - 方案A：t_companyinfo 表增加 user_id 字段
   - 方案B：企业表保留原 user_id 关联字段

#### 异常处理

- 如果角色不存在，跳过用户创建，记录日志警告
- 如果用户创建失败，企业创建仍可成功（记录日志）
- 需要事务保证企业创建和用户创建的一致性

## Implementation

### 企业创建流程

```
用户提交企业信息
        │
        ▼
保存企业信息到 t_companyinfo
        │
        ▼
根据 companyType 获取角色ID
  - companyType=1 → 施工企业 → sgdwry
  - companyType=2 → 生产企业 → scdwry
  - companyType=3 → 代理商 → gysjs
        │
        ▼
构建 SysUserBo
  - user_name = companyName
  - nick_name = companyName
  - password = Hny@2022（BCrypt加密）
  - role_ids = [对应角色ID]
  - status = '0'
        │
        ▼
调用 SysUserService.insertUser()
        │
        ▼
返回结果
```

### 关键接口

```java
// BaseCompanyInfoServiceImpl 中新增方法
private Long getRoleIdByCompanyType(Integer companyType) {
    // 根据 companyType 返回对应的角色ID
    // companyType=1: sgdwry (施工单位人员) → 275855349104248069
    // companyType=2: scdwry (生产单位人员) → 275393296988112133
    // companyType=3: gysjs (供应商人员) → 305829674242540805
}

private void createUserForCompany(BaseCompanyInfo company) {
    // 1. 获取角色ID
    Long roleId = getRoleIdByCompanyType(company.getCompanyType());
    if (roleId == null) {
        log.warn("企业[{}]类型[{}]未找到对应角色，跳过用户创建", company.getCompanyName(), company.getCompanyType());
        return;
    }

    // 2. 构建用户信息
    SysUserBo userBo = new SysUserBo();
    userBo.setUserName(company.getCompanyName());
    userBo.setNickName(company.getCompanyName());
    userBo.setPassword("Hny@2022"); // 默认密码
    userBo.setPhonenumber(company.getContactPhone());
    userBo.setStatus("0");
    userBo.setRoleIds(new Long[]{roleId});
    userBo.setTenantId("000000");

    // 3. 调用系统服务创建用户
    sysUserService.insertUser(userBo);
}
```

### 依赖服务

- `SysUserService`: 系统用户服务，用于创建用户
- `SysRoleService`: 系统角色服务，用于查询角色ID

## Rollback

删除企业时，同步删除关联的用户：

```sql
-- 删除企业时级联删除用户（如果已建立关联）
DELETE FROM sys_user WHERE user_id = (SELECT user_id FROM t_companyinfo WHERE id = ?);
DELETE FROM sys_user_role WHERE user_id = (SELECT user_id FROM t_companyinfo WHERE id = ?);
DELETE FROM t_companyinfo WHERE id = ?;
```

## Acceptance Criteria

- [ ] 施工企业新增成功时，系统自动创建用户并分配"施工单位人员"角色
- [ ] 生产企业新增成功时，系统自动创建用户并分配"生产单位人员"角色
- [ ] 代理商新增成功时，系统自动创建用户并分配"供应商人员"角色
- [ ] 新创建的用户可使用默认密码 Hny@2022 登录系统
- [ ] 用户可查看自己的角色权限
- [ ] 删除企业时，用户同步删除（或可选保留）

## Notes

1. **角色ID固定**: 三个角色ID是固定的，需要确认数据库中是否存在这些角色
2. **密码策略**: 默认密码为 Hny@2022，首次登录后应提示修改密码
3. **事务保证**: 企业创建和用户创建应在同一事务中，保证数据一致性
4. **重复检查**: 需检查用户名是否已存在，避免重复创建
5. **日志记录**: 用户创建失败时记录日志，不影响企业创建主流程