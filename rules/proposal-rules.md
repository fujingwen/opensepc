# 提案与设计规范

## 字典生成准则

- 生成字典 SQL 时，必须询问用户指定 `dict_id` 和 `dict_code` 的起始值。
- `dict_id`（字典类型 ID）必须在 `sys_dict_type` 表中保持唯一，建议使用 100-999 范围。
- `dict_code`（字典数据编码）必须在 `sys_dict_data` 表中保持唯一，建议使用 1-999 范围。
- 确保所有的字典类型中 `dict_code` 的值全局唯一。

## 命名规范规则

- 必须遵循 `common/common_architecture/spec.md` 中的模块命名、包结构和文件命名规范。
- Spec（规范）所在的多层路径和文件命名**必须一律使用下划线蛇形命名法 (snake_case)**（例如：`base_agent`, `materials_record`）。
- 创建新功能模块时，命名格式建议为：`前端模块名_页面名称`。
- 对现有规范进行扩展时，需使用 `_extend` 后缀（例如：`materials_record_extend`）。
- 公共规范必须使用 `common_` 前缀（例如：`common_architecture`, `common_backend_development`）。

## 数据库与表结构设计

- 所有的业务数据表**必须包含** `tenant_id` 字段以支持多租户数据隔离机制。
- `tenant_id` 的字段规范定死为：`varchar(20) NOT NULL DEFAULT '000000'`。
- 在设计阶段必须为该字段加上索引项：`idx_{table_name}_tenant_id`。
- 必须为该字段配置注释："租户编号"。
- 在建立和生成基础建表语句 (base table SQL) 时，必须自动将 `tenant_id` 列放到紧贴着主键 `id` 之后的**第二个列位**。
- 其他数据库表和字段规范（包含审计类型的字段）需严格遵循 `common/common_architecture/spec.md`。

## 提案文档要求

- 生成文档在框架与排版上必须完全遵循 `common/common_architecture/spec.md` 给出的格式标准。
- 完整的提案（Proposal）必须全方位包含前端视角的界面呈现要求以及后端业务驱动实现的技术细节。
- 提案文档内容中**不要**杂糅进去路由配置（Route configuration）的信息。

## 提案 Impact 部分要求

- **必须**在 Impact 部分列出生成的所有文件清单，包括：
  - SQL 文件（建表、序列、索引、字典、菜单等）
  - 后端文件（Entity、Bo、Vo、Mapper、Service、Controller 等）
  - 前端文件（API、页面组件等）
- 文件路径应相对于项目根目录

## 数据库类型规范

- PostgreSQL 不支持 `tinyint` 类型，应使用 `smallint` 代替
- 建表 SQL 中应避免使用 MySQL 特有类型
