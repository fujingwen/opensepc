## Context

当前系统已有建材记录管理模块，但缺少基础数据管理能力。生产企业、施工企业、代理商等基础信息目前无法在系统中管理，导致建材记录录入时无法选择相关企业信息。需要建立基础数据管理模块，为建材记录管理提供数据支撑。

技术栈：

- 后端：Java 17, Spring Boot 3.2.6, MyBatis-Plus 3.5.7, Sa-Token 1.38.0
- 前端：Vue 3.4.31, Vite 5.3.2, Element Plus 2.7.6, Pinia

## Goals / Non-Goals

**Goals:**

- 实现生产企业、施工企业、代理商三个页面的完整CRUD功能
- 实现省市区三级联动选择功能
- 实现电话号码格式验证
- 实现数据导出功能
- 为后续统一用户信息管理预留菜单入口
- 实现基于用户角色的差异化数据展示功能

**Non-Goals:**

- 统一用户信息页面功能实现（本次不实现）
- 企业间关联关系管理（如代理商与生产企业的业务关系）
- 数据权限控制（所有用户可访问）

## Decisions

### 数据库设计

**数据存储架构**

- **sys_user 表**: 仅存储用户基本信息(用户名、昵称、密码等),不存储企业相关信息
- **base_production 表**: 存储生产企业信息,通过 user_id 关联用户,同时冗余存储 nick_name 方便查询
- **base_construction 表**: 存储施工企业信息,通过 user_id 关联用户,同时冗余存储 nick_name 方便查询
- **base_agent 表**: 存储代理商信息,通过 production_enterprise_id 关联生产企业

**数据关系**

```
sys_user (用户表)
├── user_id (主键)
├── user_name (用户名)
├── nick_name (昵称)
└── ...

base_production (生产企业表) - 一对一关系
├── id (主键)
├── user_id (外键,关联 sys_user.user_id,唯一索引)
├── nick_name (冗余字段,存储用户昵称)
├── contact_person (联系人)
├── contact_phone (联系电话)
├── province_code (省份代码)
├── city_code (城市代码)
├── district_code (区县代码)
├── address (详细地址)
└── ...

base_construction (施工企业表) - 一对一关系
├── id (主键)
├── user_id (外键,关联 sys_user.user_id,唯一索引)
├── nick_name (冗余字段,存储用户昵称)
├── contact_person (联系人)
├── contact_phone (联系电话)
├── province_code (省份代码)
├── city_code (城市代码)
├── district_code (区县代码)
├── address (详细地址)
└── ...
```

**生产企业表 (base_production)**

```sql
CREATE TABLE base_production (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL COMMENT '关联用户ID',
  nick_name VARCHAR(200) NOT NULL COMMENT '用户昵称(冗余字段)',
  enterprise_name VARCHAR(200) NOT NULL COMMENT '生产企业名称',
  contact_person VARCHAR(100) NOT NULL COMMENT '联系人',
  contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
  province VARCHAR(50) NOT NULL COMMENT '省',
  city VARCHAR(50) NOT NULL COMMENT '市',
  district VARCHAR(50) NOT NULL COMMENT '区',
  detail_address VARCHAR(500) NOT NULL COMMENT '详细地址',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  create_by VARCHAR(50) COMMENT '创建人',
  update_by VARCHAR(50) COMMENT '更新人',
  deleted TINYINT DEFAULT 0 COMMENT '删除标记 0-未删除 1-已删除',
  UNIQUE KEY uk_user_id (user_id),
  INDEX idx_enterprise_name (enterprise_name)
) COMMENT='生产企业表';
```

**施工企业表 (base_construction)**

```sql
CREATE TABLE base_construction (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL COMMENT '关联用户ID',
  nick_name VARCHAR(200) NOT NULL COMMENT '用户昵称(冗余字段)',
  enterprise_name VARCHAR(200) NOT NULL COMMENT '施工企业名称',
  contact_person VARCHAR(100) NOT NULL COMMENT '联系人',
  contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
  province VARCHAR(50) NOT NULL COMMENT '省',
  city VARCHAR(50) NOT NULL COMMENT '市',
  district VARCHAR(50) NOT NULL COMMENT '区',
  detail_address VARCHAR(500) NOT NULL COMMENT '详细地址',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  create_by VARCHAR(50) COMMENT '创建人',
  update_by VARCHAR(50) COMMENT '更新人',
  deleted TINYINT DEFAULT 0 COMMENT '删除标记 0-未删除 1-已删除',
  UNIQUE KEY uk_user_id (user_id),
  INDEX idx_enterprise_name (enterprise_name)
) COMMENT='施工企业表';
```

**代理商表 (base_agent)**

```sql
CREATE TABLE base_agent (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  production_enterprise_id BIGINT NOT NULL COMMENT '所属生产企业ID',
  agent_name VARCHAR(200) NOT NULL COMMENT '代理商名称',
  province VARCHAR(50) NOT NULL COMMENT '省',
  city VARCHAR(50) NOT NULL COMMENT '市',
  district VARCHAR(50) NOT NULL COMMENT '区',
  detail_address VARCHAR(500) NOT NULL COMMENT '详细地址',
  contact_person VARCHAR(100) NOT NULL COMMENT '联系人',
  contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
  user_account VARCHAR(50) NOT NULL COMMENT '用户账号',
  user_password VARCHAR(100) NOT NULL COMMENT '用户密码',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  create_by VARCHAR(50) COMMENT '创建人',
  update_by VARCHAR(50) COMMENT '更新人',
  deleted TINYINT DEFAULT 0 COMMENT '删除标记 0-未删除 1-已删除',
  INDEX idx_agent_name (agent_name),
  INDEX idx_production_enterprise_id (production_enterprise_id)
) COMMENT='代理商表';
```

**省市区数据表 (base_region)**

```sql
CREATE TABLE base_region (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(20) NOT NULL COMMENT '行政区划代码',
  name VARCHAR(50) NOT NULL COMMENT '名称',
  level TINYINT NOT NULL COMMENT '级别 1-省 2-市 3-区',
  parent_code VARCHAR(20) COMMENT '父级代码',
  INDEX idx_code (code),
  INDEX idx_parent_code (parent_code)
) COMMENT='省市区表';
```

### 菜单和权限设计

**菜单结构**

```
基础数据 (base)
├── 生产企业
│   base:production:list
│   base/production/index
│   ├── 查询: base:production:query
│   ├── 新增: base:production:add
│   ├── 修改: base:production:edit
│   ├── 删除: base:production:remove
│   └── 导出: base:production:export
├── 施工企业
│   base:construction:list
│   base/construction/index
│   ├── 查询: base:construction:query
│   ├── 新增: base:construction:add
│   ├── 修改: base:construction:edit
│   ├── 删除: base:construction:remove
│   └── 导出: base:construction:export
├── 代理商
│   base:agent:list
│   base/agent/index
│   ├── 查询: base:agent:query
│   ├── 新增: base:agent:add
│   ├── 修改: base:agent:edit
│   ├── 删除: base:agent:remove
│   └── 导出: base:agent:export
└── 统一用户信息 - 预留
    base:unifiedUser:list
```

### 后端API设计

**通用API规范**

- 所有接口使用Sa-Token进行身份验证
- 统一返回格式：{ code, msg, data }
- 分页查询使用Page对象

**生产企业API**

- GET /api/base/production/getByUserId - 根据用户ID获取生产企业信息,权限：base:production:query
  - 如果查询不到记录,自动创建一条记录并返回
- GET /api/base/production/list - 分页查询（支持企业名称模糊查询），权限：base:production:query
- POST /api/base/production - 新增，权限：base:production:add
- PUT /api/base/production - 修改，权限：base:production:edit
- DELETE /api/base/production/{id} - 删除，权限：base:production:remove
- GET /api/base/production/export - 导出Excel，权限：base:production:export

**施工企业API**

- GET /api/base/construction/getByUserId - 根据用户ID获取施工企业信息,权限：base:construction:query
  - 如果查询不到记录,自动创建一条记录并返回
- GET /api/base/construction/list - 分页查询（支持企业名称模糊查询），权限：base:construction:query
- POST /api/base/construction - 新增，权限：base:construction:add
- PUT /api/base/construction - 修改，权限：base:construction:edit
- DELETE /api/base/construction/{id} - 删除，权限：base:construction:remove
- GET /api/base/construction/export - 导出Excel，权限：base:construction:export

**代理商API**

- GET /api/base/agent/list - 分页查询（支持代理商名称模糊查询），权限：base:agent:query
- POST /api/base/agent - 新增，权限：base:agent:add
- PUT /api/base/agent - 修改，权限：base:agent:edit
- DELETE /api/base/agent/{id} - 删除，权限：base:agent:remove
- GET /api/base/agent/export - 导出Excel，权限：base:agent:export
- GET /api/base/agent/production-enterprises - 获取所有生产企业（用于下拉选择），权限：base:agent:query

**省市区API**

- GET /base/region/level/1 - 获取所有省份，权限：base:region:query
- GET /base/region/children/{provinceCode} - 根据省份代码获取城市，权限：base:region:query
- GET /base/region/children/{cityCode} - 根据城市代码获取区县，权限：base:region:query

### 前端设计

**页面结构**

- 使用Element Plus的Table组件展示数据列表
- 使用Dialog组件实现新增/修改弹窗
- 使用Form组件实现表单验证
- 使用Select组件实现省市区三级联动
- 使用ElMessage进行操作反馈

**后端数据过滤逻辑**

**用户角色判断**

- 后端调用 `system/user/getInfo` 接口获取当前用户信息
- 从返回值中获取 `roles` 字段，判断用户角色
- 如果 `roles` 中存在 `roleKey` 为 `"production"`，表示当前用户是生产企业用户
- 如果 `roles` 中存在 `roleKey` 为 `"construction"`，表示当前用户是施工企业用户

**生产企业数据过滤**

- 如果当前用户是生产企业用户（roleKey为"production"）：
  - 调用 `GET /api/base/production/getByUserId` 接口，传入当前用户 userId
  - 后端根据 userId 查询 base_production 表
  - 如果查询到记录，返回该记录
  - 如果查询不到记录，自动创建一条记录（user_id、nick_name 从 sys_user 获取，其他字段使用默认值或空值），然后返回
  - 前端列表展示返回的单条记录
- 如果当前用户不是生产企业用户：
  - 返回所有生产企业信息（管理员）

**施工企业数据过滤**

- 如果当前用户是施工企业用户（roleKey为"construction"）：
  - 调用 `GET /api/base/construction/getByUserId` 接口，传入当前用户 userId
  - 后端根据 userId 查询 base_construction 表
  - 如果查询到记录，返回该记录
  - 如果查询不到记录，自动创建一条记录（user_id、nick_name 从 sys_user 获取，其他字段使用默认值或空值），然后返回
  - 前端列表展示返回的单条记录
- 如果当前用户不是施工企业用户：
  - 返回所有施工企业信息（管理员）

**代理商数据过滤**

- 根据当前用户的 `userId` 查询所有供应商
- 供应商通过生产企业创建，与当前用户关联
- 保持现有逻辑不变

**生产企业页面**

**查询条件**

- 生产企业名称（模糊查询）

**列表展示字段**

- 生产企业名称
- 联系人
- 联系电话
- 省市区（省份+城市+区县）
- 详细地址
- 创建时间
- 操作（编辑、删除）

**新增页面字段**

- 生产企业名称（input，必填，最大长度200）
- 联系人（input，必填，最大长度100）
- 联系电话（input，必填，需要验证电话格式）
- 省市区（必填，三级联动选择，先选省再加载市再加载区）
- 详细地址（input，必填，最大长度500）

**编辑页面字段**

- 生产企业名称（不可编辑，仅展示）
- 联系人（可编辑）
- 联系电话（可编辑）
- 省市区（可编辑）
- 详细地址（可编辑）
- 创建时间（不可编辑，仅展示）

**表单验证规则**

- 企业名称：必填，最大长度200
- 联系人：必填，最大长度100
- 联系电话：必填，使用正则验证手机号或座机号格式
  - 手机号：/^1[3-9]\d{9}$/
  - 座机号：/^0\d{2,3}-?\d{7,8}$/
- 省市区：必填，三级联动
- 详细地址：必填，最大长度500

**施工企业页面**

**查询条件**

- 施工企业名称（模糊查询）

**列表展示字段**

- 施工企业名称
- 联系人
- 联系电话
- 省市区（省份+城市+区县）
- 详细地址
- 创建时间
- 操作（编辑、删除）

**新增页面字段**

- 施工企业名称（input，必填，最大长度200）
- 联系人（input，必填，最大长度100）
- 联系电话（input，必填，需要验证电话格式）
- 省市区（必填，三级联动选择，先选省再加载市再加载区）
- 详细地址（input，必填，最大长度500）

**编辑页面字段**

- 施工企业名称（不可编辑，仅展示）
- 联系人（可编辑）
- 联系电话（可编辑）
- 省市区（可编辑）
- 详细地址（可编辑）
- 创建时间（不可编辑，仅展示）

**表单验证规则**

- 企业名称：必填，最大长度200
- 联系人：必填，最大长度100
- 联系电话：必填，使用正则验证手机号或座机号格式
  - 手机号：/^1[3-9]\d{9}$/
  - 座机号：/^0\d{2,3}-?\d{7,8}$/
- 省市区：必填，三级联动
- 详细地址：必填，最大长度500

**代理商页面**

**查询条件**

- 代理商名称（模糊查询）

**列表展示字段**

- 所属生产企业
- 代理商名称
- 详细地址
- 联系人
- 联系电话
- 创建时间
- 操作（编辑、删除）

**新增页面字段**

- 所属生产企业（select，查询生产企业页面所有数据，必填）
- 代理商名称（input，必填，最大长度200）
- 代理商省市区（必填，三级联动选择，先选省再加载市再加载区）
- 代理商详细地址（input，必填，最大长度500）
- 联系人（input，必填，最大长度100）
- 联系电话（input，必填，需要验证电话格式）
- 用户账号（input，必填，长度6-20之间，使用正则验证：/^[a-zA-Z0-9_]{6,20}$/）
- 用户密码（input，必填，长度8-16位，必须包含数字、字母、特殊字符）
- 备注（input，必填，长度6-20之间）

**编辑页面字段**

- 所属生产企业（可编辑）
- 代理商名称（不可编辑，仅展示）
- 代理商省市区（可编辑）
- 代理商详细地址（可编辑）
- 联系人（可编辑）
- 联系电话（可编辑）
- 用户账号（不可编辑，仅展示）
- 用户密码（可编辑）
- 备注（可编辑）
- 创建时间（不可编辑，仅展示）

**表单验证规则**

- 所属生产企业：必填，从生产企业列表选择
- 代理商名称：必填，最大长度200
- 代理商省市区：必填，三级联动
- 代理商详细地址：必填，最大长度500
- 联系人：必填，最大长度100
- 联系电话：必填，使用正则验证手机号或座机号格式
  - 手机号：/^1[3-9]\d{9}$/
  - 座机号：/^0\d{2,3}-?\d{7,8}$/
- 用户账号：必填，长度6-20，使用正则 /^[a-zA-Z0-9_]{6,20}$/
- 用户密码：必填，长度8-16位，必须包含数字、字母、特殊字符
- 备注：必填，长度6-20

**省市区页面**

**查询条件**

- 地区名称（模糊查询）
- 地区级别（省/市/区县筛选）

**列表展示字段**

- 地区代码
- 地区名称
- 父级地区
- 地区级别（1-省，2-市，3-区县）
- 排序
- 状态
- 创建时间
- 操作（编辑、删除）

**新增页面字段**

- 地区代码（input，必填，最大长度6）
- 地区名称（input，必填，最大长度100）
- 父级地区（select，从上级地区列表选择，省为空）
- 地区级别（select，必填：1-省，2-市，3-区县）
- 排序（input，必填，数字）
- 状态（select，必填：0-正常，1-禁用）

**编辑页面字段**

- 地区代码（可编辑）
- 地区名称（可编辑）
- 父级地区（可编辑，省为空）
- 地区级别（可编辑）
- 排序（可编辑）
- 状态（可编辑）
- 创建时间（不可编辑，仅展示）

**表单验证规则**

- 地区代码：必填，最大长度6，唯一性验证
- 地区名称：必填，最大长度100
- 父级地区：省为空时必填
- 地区级别：必填，1-省，2-市，3-区县
- 排序：必填，数字
- 状态：必填，0-正常，1-禁用

**路由设计**

```
/base
  /production - 生产企业
  /construction - 施工企业
  /agent - 代理商
  /region - 省市区
  /unifiedUser - 统一用户信息（预留）
```

**组件复用**

- 创建RegionSelect组件，实现省市区三级联动选择
  - 组件路径：`src/components/RegionSelect/index.vue`
  - 功能特性：
    - 使用单个input显示，格式为"山东省/青岛市/李沧区"
    - 点击input弹出三级联动选择器
    - 选择省份后自动加载城市列表
    - 选择城市后自动加载区县列表
    - 只有选择到区县后才算完成选择
    - 支持清空操作
    - 支持编辑时回显已选择的地区
  - 组件API：
    - Props：
      - `modelValue`: Object类型，包含provinceCode、provinceName、cityCode、cityName、districtCode、districtName
      - `level`: Number类型，默认3，表示选择级别（2表示省市，3表示省市区）
    - Events：
      - `update:modelValue`: 更新选择值
      - `change`: 选择变化时触发
  - 数据来源：
    - 使用`@/api/base/region`中的API接口
    - `getRegionByLevel(1)`: 获取所有省份
    - `getRegionByParentCode(code)`: 根据父级代码获取子级列表

- 创建EnterpriseSelect组件，实现生产企业下拉选择

### 数据验证策略

**电话号码验证**

- 前端：使用正则表达式验证
  - 手机号：/^1[3-9]\d{9}$/
  - 座机号：/^0\d{2,3}-?\d{7,8}$/
- 后端：使用相同的正则表达式进行二次验证

**用户账号验证**

- 前端：长度6-20，只允许字母、数字、下划线
- 后端：使用正则 /^[a-zA-Z0-9_]{6,20}$/ 验证

### 省市区数据管理方案

**数据来源**

- 使用国家统计局最新行政区划数据
- 初始化时导入省市区数据到region表

**数据加载策略**

- 前端采用懒加载方式
- 选择省份后加载该省的城市列表
- 选择城市后加载该市的区县列表

**缓存策略**

- 省份列表在应用启动时加载并缓存
- 城市/区县数据使用Pinia缓存，避免重复请求

**后端地区名称填充**

- 在Service层实现地区名称自动填充
- 查询列表、详情时自动填充省市区名称
- 填充逻辑：
  - 根据provinceCode查询region表获取provinceName
  - 根据cityCode查询region表获取cityName
  - 根据districtCode查询region表获取districtName
-- 受影响的实体：
  - BaseProductionVo
  - BaseConstructionVo
  - BaseAgentVo
- 实现方式：
  - 在Service实现类中注入IBaseRegionService
  - 创建fillRegionName方法填充单个对象的地区名称
  - 创建fillRegionNames方法批量填充地区名称
  - 在查询方法中调用填充方法

## Risks / Trade-offs

**风险1：省市区数据更新**

- 风险：行政区划可能调整，需要定期更新数据
- 缓解：提供省市区数据导入功能，支持从Excel或JSON文件批量更新

**风险2：电话号码格式多样性**

- 风险：不同地区的电话号码格式可能存在差异
- 缓解：采用宽松的正则表达式，允许常见格式，并在验证失败时提供友好提示

**风险3：数据导出性能**

- 风险：大量数据导出可能导致性能问题
- 缓解：限制单次导出数量（如最多10000条），并提供分批次导出选项

**权衡：统一用户信息页面**

- 决策：本次不实现统一用户信息页面，仅预留菜单入口
- 理由：统一用户信息可能涉及复杂的权限管理和用户关联关系，需要单独的需求分析和设计

## Migration Plan

1. **数据库迁移**
   - 执行SQL脚本创建4张表（base_production、base_construction、base_agent、base_region）
   - 导入省市区初始化数据
   - 执行迁移脚本 `base_remove_user_fields.sql`，从 sys_user 表中删除企业相关字段
   - 注意：现有用户数据不进行迁移，只有新增用户需要处理

2. **后端部署**
   - 部署新的Controller、Service、Mapper
   - 实现 `getByUserId` 接口，支持自动创建记录逻辑
   - 配置省市区数据接口

3. **前端部署**
   - 部署新的页面组件
   - 修改生产企业/施工企业页面的查询逻辑，调用 `getByUserId` 接口
   - 配置路由和菜单
   - 部署省市区选择组件

4. **回滚策略**
   - 保留数据库迁移脚本，支持回滚
   - 前端可通过路由配置快速禁用新页面

## Open Questions

1. 省市区数据是否需要支持多语言？（当前仅支持中文）
2. 代理商与生产企业的业务关系是否需要记录？（如代理期限、代理区域等）
3. 是否需要数据导入功能？（目前仅支持导出）
4. 统一用户信息页面的具体需求是什么？（本次预留，待后续明确）
