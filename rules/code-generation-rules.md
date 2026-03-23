# 代码生成规则

## 代码模板引用

## 扁平表格（带分页）

适用于：普通列表页面，带分页功能

- Backend code must follow template at: templates/backend-code-template.md
- Frontend code must follow template at: templates/frontend-page-template.md

## 树形表格（不带分页）

适用于：行政区划、组织架构等需要层级关系的树形数据

- Backend code must follow template at: templates/backend-tree-template.md
- Frontend code must follow template at: templates/frontend-tree-template.md

### 树形表格特征判断

满足以下任一条件时，应使用树形表格模板：

1. 数据具有层级关系（如：上级/下级、父子关系）
2. 需要树形展示（如：行政区划树、组织架构树）
3. 不需要分页（数据量较小或需要一次性加载完整树）
4. 使用 `el-table` 的 `row-key` 和 `tree-props` 配置
5. 使用 `el-tree-select` 作为树形选择器

## SQL 执行规则

- 在执行提案生成代码时，必须同步执行提案目录下的 SQL 脚本
- SQL 执行顺序：
  1. 序列脚本（sequences/*.sql）
  2. 建表脚本（tables/*.sql）
  3. 索引脚本（indexes/*.sql）
  4. 字典脚本（dict/*.sql）
  5. 菜单脚本（menu/*.sql）
  6. 迁移脚本（migrate/*.sql）
  7. 初始化数据（data/*.sql）
- 如果 SQL 执行失败，应停止代码生成并提示用户

## 代码编译规则

- 代码生成完成后，必须编译后端项目检查是否有报错
- 编译前端项目检查是否有报错
- 如果有报错，需要修改代码直至编译通过
- 编译过程中发现的问题需要记录到 issues.md 文件中
