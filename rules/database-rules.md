# 数据库设计规则

## 字段命名规则

- 不要 F_ 前缀
- 字段名为小写，中间用下划线分隔
- 示例：F_RecordProductName → record_product_name

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

从旧系统迁移时，字段映射关系：

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
| F_Type | company_type | 企业类型：1-施工企业，2-生产企业，3-代理商 |

## 数据迁移注意事项

1. **del_flag 字段**：迁移时必须将 NULL 转换为 0，使用 `COALESCE("F_DeleteMark", 0) AS del_flag`
2. **tenant_id 字段**：迁移时设置默认值 '000000'
3. **create_dept 字段**：迁移时设置默认值 '103'
4. **迁移后验证**：执行查询验证 del_flag 分布，确保无 NULL 值

## 表结构要求

1. 主键使用 VARCHAR(50) 类型
2. 必须包含逻辑删除字段 (del_flag)
3. 必须包含租户隔离字段 (tenant_id)
4. 建议添加外键关联企业表 (master.t_companyinfo)

## SQL 文件结构

每个提案的 sql 目录应包含：

```
sql\
├── master_t_xxx.sql          # 建表SQL
├── sequences\                # 序列
│   └── seq_xxx.sql
├── indexes\                  # 索引
│   └── idx_xxx.sql
├── migrate\                  # 数据迁移
│   └── migrate_xxx.sql
├── menu\                     # 菜单配置
│   └── menu_xxx.sql
└── dict\                     # 字典配置
    └── dict_xxx.sql
```
