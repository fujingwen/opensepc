# 企业信息管理详细设计

## Context

当前系统已有建材记录管理模块，但缺少基础数据管理能力。施工企业、生产企业、代理商等基础信息目前通过 t_companyinfo 表统一管理，通过 company_type 字段区分企业类型：
- company_type = 1: 施工企业
- company_type = 2: 生产企业
- company_type = 3: 代理商

需要建立企业信息管理功能，为建材记录管理提供数据支撑。

技术栈：
- 后端：Java 17, Spring Boot 3.2.6, MyBatis-Plus 3.5.7, Sa-Token 1.38.0
- 前端：Vue 3.4.31, Vite 5.3.2, Element Plus 2.7.6, Pinia

## Goals / Non-Goals

**Goals:**

- 实现施工企业、生产企业、代理商三个页面的完整CRUD功能
- 实现省市区三级联动选择功能
- 实现电话号码格式验证
- 实现数据导出功能
- 实现基于用户角色的差异化数据展示功能

**Non-Goals:**

- 统一用户信息页面功能实现（本次不实现）
- 企业间关联关系管理（如代理商与生产企业的业务关系）
- 数据权限控制（所有用户可访问）

## Decisions

### 数据表设计

**企业信息表 (t_companyinfo)**

```sql
CREATE TABLE master.t_companyinfo (
    id character varying(50) NOT NULL,
    company_name character varying(300),
    area character varying(150),
    address character varying(500),
    contact_user character varying(50),
    contact_phone character varying(50),
    company_type integer,  -- 1-施工企业, 2-生产企业, 3-代理商
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
```

**省市区数据表 (base_region)**

```sql
CREATE TABLE master.base_region (
    id BIGINT PRIMARY KEY,
    region_code VARCHAR(20) NOT NULL COMMENT '行政区划代码',
    region_name VARCHAR(50) NOT NULL COMMENT '名称',
    parent_code VARCHAR(20) COMMENT '父级代码',
    region_level INTEGER NOT NULL COMMENT '级别 1-省 2-市 3-区',
    sort INTEGER DEFAULT 0,
    status INTEGER DEFAULT 0,
    create_by VARCHAR(50),
    create_time TIMESTAMP
);
```

### 菜单和权限设计

**菜单结构**（基于数据库现有权限）

```
基础数据 (menu_id: 5000001, path: base)
├── 生产企业 (menu_id: 5000002)
│   路径: production
│   组件: base/production/index
│   权限: base:production:list
│   ├── 查询: base:production:query
│   ├── 新增: base:production:add
│   ├── 修改: base:production:edit
│   ├── 删除: base:production:remove
│   └── 导出: base:production:export
├── 施工企业 (menu_id: 5000008)
│   路径: construction
│   组件: base/construction/index
│   权限: base:construction:list
│   ├── 查询: base:construction:query
│   ├── 新增: base:construction:add
│   ├── 修改: base:construction:edit
│   ├── 删除: base:construction:remove
│   └── 导出: base:construction:export
└── 代理商 (menu_id: 5000014)
    路径: agent
    组件: base/agent/index
    权限: base:agent:list
    ├── 查询: base:agent:query
    ├── 新增: base:agent:add
    ├── 修改: base:agent:edit
    ├── 删除: base:agent:remove
    └── 导出: base:agent:export
```

### 后端API设计

**通用API规范**

- 所有接口使用Sa-Token进行身份验证
- 统一返回格式：{ code, msg, data }
- 分页查询使用Page对象

**企业信息API**

- GET /api/base/companyinfo/list - 分页查询，权限：base:companyinfo:query
  - 参数：companyType（企业类型 1/2/3）, companyName（企业名称模糊查询）
- POST /api/base/companyinfo - 新增，权限：base:companyinfo:add
- PUT /api/base/companyinfo - 修改，权限：base:companyinfo:edit
- DELETE /api/base/companyinfo/{id} - 删除，权限：base:companyinfo:remove
- GET /api/base/companyinfo/export - 导出Excel，权限：base:companyinfo:export

**施工企业专用API**

- GET /api/base/companyinfo/construction/getByUserId - 根据用户ID获取施工企业信息
  - 如果查询不到记录，自动创建一条记录并返回

**生产企业专用API**

- GET /api/base/companyinfo/production/getByUserId - 根据用户ID获取生产企业信息
  - 如果查询不到记录，自动创建一条记录并返回

**代理商专用API**

- GET /api/base/companyinfo/agent/productions - 获取所有生产企业（用于下拉选择）

**省市区API**

- GET /api/base/region/level/1 - 获取所有省份
- GET /api/base/region/children/{parentCode} - 根据父级代码获取子级地区

### 前端设计

**页面结构**

- 使用Element Plus的Table组件展示数据列表
- 使用Dialog组件实现新增/修改弹窗
- 使用Form组件实现表单验证
- 使用Select组件实现省市区三级联动
- 使用ElMessage进行操作反馈

**施工企业页面**

**查询条件**
- 企业名称（模糊查询）

**列表展示字段**
- 企业名称、联系人、联系电话、省市区、详细地址、创建时间、操作（编辑、删除）

**新增/编辑页面字段**
- 企业名称（必填，最大长度200）
- 联系人（必填，最大长度100）
- 联系电话（必填，验证手机号或座机号格式）
- 省市区（三级联动选择）
- 详细地址（必填，最大长度500）

**生产企业页面** - 同上

**代理商页面** - 同上，增加：
- 所属生产企业（下拉选择）

**表单验证规则**

- 企业名称：必填，最大长度200
- 联系人：必填，最大长度100
- 联系电话：必填，使用正则验证
  - 手机号：/^1[3-9]\d{9}$/
  - 座机号：/^0\d{2,3}-?\d{7,8}$/
- 省市区：必填，三级联动
- 详细地址：必填，最大长度500

**路由设计**

```
/base/companyinfo
  /construction - 施工企业
  /production - 生产企业
  /agent - 代理商
/base/region - 省市区
```

### 数据验证策略

**电话号码验证**

- 前端：使用正则表达式验证
- 后端：使用相同的正则表达式进行二次验证

### 省市区数据管理方案

**数据来源**
- 使用国家统计局最新行政区划数据
- 初始化时导入省市区数据到base_region表

**数据加载策略**
- 前端采用懒加载方式
- 选择省份后加载该省的城市列表
- 选择城市后加载该市的区县列表

## Risks / Trade-offs

**风险1：省市区数据更新**
- 风险：行政区划可能调整，需要定期更新数据
- 缓解：提供省市区数据导入功能

**风险2：电话号码格式多样性**
- 风险：不同地区的电话号码格式可能存在差异
- 缓解：采用宽松的正则表达式

**风险3：数据导出性能**
- 风险：大量数据导出可能导致性能问题
- 缓解：限制单次导出数量（如最多10000条）

## Migration Plan

1. **数据迁移**
   - 将 base_production、base_construction、base_agent 表的数据迁移到 t_companyinfo
   - 根据原表设置对应的 company_type 值

2. **后端部署**
   - 部署新的Controller、Service、Mapper

3. **前端部署**
   - 部署新的页面组件
   - 配置路由和菜单

## Open Questions

1. 省市区数据是否需要支持多语言？
2. 代理商与生产企业的业务关系是否需要记录？
3. 是否需要数据导入功能？