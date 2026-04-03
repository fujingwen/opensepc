# 数据库设计规则

## 字段命名规则

- 不要使用 `F_` 前缀。
- 字段名统一使用小写，下划线分隔。
- 示例：`F_RecordProductName` -> `record_product_name`

## 默认字段

所有业务表必须包含以下审计字段：

| 字段名 | 说明 | 数据类型 | 默认值 |
|--------|------|---------|--------|
| create_by | 创建人 | VARCHAR(50) | - |
| create_time | 创建时间 | TIMESTAMP | - |
| update_by | 更新人 | VARCHAR(50) | - |
| update_time | 更新时间 | TIMESTAMP | - |
| del_flag | 删除标记 | INTEGER | 0 |
| tenant_id | 租户ID | VARCHAR(50) | 000000 |
| create_dept | 创建部门 | VARCHAR(50) | 103 |

## 字段映射规则

从旧系统迁移时，字段映射关系如下：

| 旧字段 | 新字段 | 说明 |
|--------|--------|------|
| creator_time | create_time | 创建时间 |
| creator_user_id | create_by | 创建人 |
| last_modify_time | update_time | 更新时间 |
| last_modify_user_id | update_by | 更新人 |
| delete_time | delete_time | 删除时间 |
| delete_user_id | delete_by | 删除人 |

## 特殊字段映射

| 旧字段 | 新字段 | 说明 |
|--------|--------|------|
| F_Type | company_type | 企业类型 |

## 数据迁移注意事项

1. `del_flag` 迁移时必须将 `NULL` 转换为 `0`。
2. `tenant_id` 迁移时设置默认值 `'000000'`。
3. `create_dept` 迁移时设置默认值 `'103'`。
4. 迁移后必须执行校验查询，确认 `del_flag` 无空值。

## 表结构要求

1. 主键使用 `VARCHAR(50)` 类型。
2. 必须包含逻辑删除字段 `del_flag`。
3. 必须包含租户隔离字段 `tenant_id`。
4. 建议通过外键或业务关联接入企业表 `master.t_companyinfo`。

## SQL 文件结构

每个提案的 `sql` 目录应包含：

```text
sql/
├── tables/
├── sequences/
├── indexes/
├── migrate/
├── menu/
└── dict/
```

## 审查补充规则

1. 涉及字段语义判断时，必须先核对真实数据库存量数据，再决定该字段应存 `ID`、`编码`、`名称` 还是展示文本。
2. 若当前前后端写入、联表查询、导出逻辑都以 ID 为准，迁移 SQL 不得再把该字段批量改写为名称；名称应通过关联查询补出。
3. 字典值必须以数据库中的 `sys_dict_type` 和 `sys_dict_data` 为唯一口径；提案、SQL、后端常量、前端枚举不得混用两套状态值。
4. 历史数据未完全标准化时，前端应优先采用兼容方案，允许字典值与历史自由值并存，不能在没有迁移方案时强制纯字典化。

## PostgreSQL 出参规则

1. SQL 若直接返回 `Map<String, Object>` 给前端使用，且接口契约要求驼峰字段名，别名必须使用双引号，例如 `gc_code as "gcCode"`。
2. PostgreSQL 中未加双引号的别名会自动折叠为小写，不能假设 `projectName`、`constructionUnit` 会按驼峰返回。
3. 修改查询时要分别说明“返回字段结构是否变化”和“结果集范围是否变化”，避免把过滤条件调整误判成接口字段变更。
