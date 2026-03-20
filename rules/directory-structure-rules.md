# 提案目录结构规范

## 标准目录结构

每个提案目录应遵循以下结构：

```
proposal-name/
├── .openspec.yaml              # 提案元数据配置
├── proposal.md                 # 提案概述（What/Why/Capabilities/Impact）
├── design.md                   # 详细设计文档
├── tasks.md                    # 任务清单
├── issues.md                   # 问题记录（归档时必须包含）
├── README.md                   # 简要说明（可选）
├── specs/                      # 详细规格说明
│   └── {module_name}/
│       └── spec.md
├── sql/                        # SQL 脚本
│   ├── tables/                 # 建表脚本
│   │   └── base_xxx.sql
│   ├── menu/                  # 菜单脚本
│   │   └── base_menu.sql
│   ├── dict/                  # 字典脚本
│   │   └── base_dict.sql
│   ├── sequences/             # 序列脚本
│   │   └── base_sequences.sql
│   ├── indexes/               # 索引脚本
│   │   └── base_indexes.sql
│   ├── migrate/               # 迁移脚本
│   │   └── add_xxx.sql
│   └── data/                 # 初始化数据
│       └── base_region_data.sql
└── docs/                      # 其他文档（可选）
    └── ...
```

## 文件说明

| 文件 | 必需 | 说明 |
|------|------|------|
| `.openspec.yaml` | ✅ | 提案元数据 |
| `proposal.md` | ✅ | 提案概述，包含 Why、What Changes、Capabilities、Impact |
| `design.md` | ✅ | 详细设计文档 |
| `tasks.md` | ✅ | 任务清单 |
| `issues.md` | ✅ | 问题记录，无问题则填写"无" |
| `specs/` | ✅ | 详细规格说明（Gherkin 格式） |
| `sql/` | ✅ | SQL 脚本目录 |
| `README.md` | ❌ | 简要说明（可选） |
| `docs/` | ❌ | 其他文档（可选） |

## SQL 文件命名规范

- 建表脚本：`base_{表名}.sql`（如 `base_production.sql`）
- 菜单脚本：`base_menu.sql`
- 字典脚本：`base_dict.sql`
- 序列脚本：`base_sequences.sql`
- 索引脚本：`base_indexes.sql`
- 迁移脚本：`add_{描述}.sql`（如 `add_user_id_to_mat_project.sql`）
- 初始化数据：`base_{类型}_data.sql`（如 `base_region_data.sql`）

## Menu SQL 文件格式规范

菜单 SQL 文件（`sql/menu/` 目录下）必须遵循以下格式：

```sql
-- ----------------------------
-- Menu and Permission SQL for {Module Name} Module
-- ----------------------------

-- 二级菜单（{菜单名称}）
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  ({menu_id}, '{菜单名称}', {parent_id}, {order_num}, '{path}', '{component}', 1, 0, 'C', '0', '0', '{perms}', '{icon}', 103, 1, now(), NULL, NULL, '{备注}')
ON CONFLICT (menu_id) DO NOTHING;

-- 按钮权限
INSERT INTO "master"."sys_menu" (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  ({query_menu_id}, '查询', {parent_menu_id}, 1, '', '', 1, 0, 'F', '0', '0', '{perms}:query', '#', 103, 1, now(), NULL, NULL, ''),
  ({add_menu_id}, '新增', {parent_menu_id}, 2, '', '', 1, 0, 'F', '0', '0', '{perms}:add', '#', 103, 1, now(), NULL, NULL, ''),
  ({edit_menu_id}, '修改', {parent_menu_id}, 3, '', '', 1, 0, 'F', '0', '0', '{perms}:edit', '#', 103, 1, now(), NULL, NULL, ''),
  ({remove_menu_id}, '删除', {parent_menu_id}, 4, '', '', 1, 0, 'F', '0', '0', '{perms}:remove', '#', 103, 1, now(), NULL, NULL, '');
```

### Menu SQL 格式要求

| 要求 | 说明 |
|------|------|
| **使用 PostgreSQL 语法** | `INSERT INTO "master"."sys_menu"`（带 schema 和双引号） |
| **多行 VALUES 格式** | 使用 `VALUES` 后跟多行数据，而不是多个 `insert` 语句 |
| **时间函数** | 使用 `now()` 而不是 `sysdate()`（PostgreSQL 标准） |
| **冲突处理** | 添加 `ON CONFLICT (menu_id) DO NOTHING` |
| **不包含权限关联** | 不包含 `sys_role_menu` 表的权限关联数据 |
| **清晰的注释** | 添加分隔线和模块说明 |
| **按钮权限顺序** | 查询(1) → 新增(2) → 修改(3) → 删除(4) |

## 目录名命名规范

- 使用 **snake_case**（蛇形命名）
- 格式：`模块名-页面名称`（如 `materials-project`、`base-production`）
- 避免使用日期前缀（如 `2026-03-12-xxx`）
- 避免使用中文

## 状态流转

```
draft → in_review → approved → in_progress → completed
                                            ↘_ archived
```

- **draft**: 草稿状态
- **in_review**: 审核中
- **approved**: 已批准
- **in_progress**: 进行中
- **completed**: 已完成
- **archived**: 已归档
