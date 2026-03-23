# 产品管理 - 问题记录

## 代码清理（2026-03-23）

### 问题1：未使用的代码

- **问题描述**：在实现过程中创建了 sys_product 表和相关的后端代码，但实际使用的是字典表（base_dictionarytype、base_dictionarydata）
- **根因**：实现过程中偏离了原始提案
- **解决方案**：删除所有未使用的代码
  - 删除 SQL 文件：sys_product.sql、sys_product_index_add.sql、sys_product_sequences.sql、sys_product_data.sql
  - 删除后端代码：SysProduct.java、SysProductVo.java、SysProductBo.java、SysProductMapper.java、SysProductMapper.xml、ISysProductService.java、SysProductServiceImpl.java、SysProductController.java
  - 删除前端 API：api/system/product.js
- **影响范围**：openspec/changes/system-product/sql/、hny-system 模块、construction-material-web/src/api/system/
- **修复状态**：已清理

### 历史问题（已解决）

以下问题在代码清理前已修复，但相关代码已被删除：

#### 问题1：tinyint 类型不存在

- **错误信息**：`ERROR: type "tinyint" does not exist`
- **根因**：PostgreSQL 不支持 tinyint 类型
- **解决方案**：将 `tinyint` 改为 `smallint`
- **影响范围**：`sql/tables/sys_product.sql`（已删除）
- **修复状态**：已修复（代码已清理）

#### 问题2：后端编译错误

- **错误信息**：`java.util.List<com.hny.system.domain.vo.SysProductVo> 无法转换为 java.util.List<com.hny.system.domain.SysProduct>`
- **根因**：ServiceImpl 中类型转换错误
- **解决方案**：移除多余的 Entity 转换步骤，直接使用 Mapper 返回的 Vo 列表
- **影响范围**：`SysProductServiceImpl.java`（已删除）
- **修复状态**：已修复（代码已清理）
