# 问题知识库

本文档记录项目中遇到的所有问题和解决方案，便于快速查找和避免重复错误。

## 前端问题

### 字典导入错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：在 Vue 组件中使用了错误的字典导入方式
**解决方案**：使用 `proxy.useDict()` 而不是 `import useDict`
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题1

### 表格列索引错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：表格列数量变化后，其他列的索引没有相应调整
**解决方案**：同步调整 columns 数组索引
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题12

### 日期选择器验证失败

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：表单验证规则检查的是独立变量，不是 form 的一部分
**解决方案**：修改验证规则，添加 @change 事件处理器
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题13

### 前端查询条件与设计文档不一致

**变更**：2026-03-13-add-construction-material-product
**问题描述**：前端页面展示的查询条件与设计文档定义的不相同（字段和顺序都不同）
**解决方案**：前端查询条件严格按照设计文档实现，包括字段类型、查询方式和顺序
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题7

### 前端实现与设计文档不一致

**变更**：2026-03-13-add-construction-material-product
**问题描述**：前端列表展示字段、新增页面字段与设计文档不一致
**解决方案**：严格按照设计文档调整字段顺序、内容和文件上传限制
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题10

### 文件上传功能

**变更**：2026-03-13-add-construction-material-product
**问题描述**：前端使用了 file-upload 和 image-upload 组件，需要确保后端已配置文件上传服务
**解决方案**：前端已集成文件上传组件，需要确认后端文件上传配置正确
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题3

## 后端问题

### 模块依赖管理

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：新增模块后，没有在主 pom.xml 的 dependencyManagement 中添加版本定义
**解决方案**：在主 pom.xml 的 dependencyManagement 部分添加版本定义，并在 hny-admin 的 pom.xml 中引入依赖
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题3

### 权限验证失败

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：Controller 使用的权限标识与菜单配置不匹配
**解决方案**：统一使用 `materials:record:*` 格式的权限标识
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题10

### Excel 导出实现

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：实体类缺少 Excel 相关注解，导致无法正确导出数据
**解决方案**：创建专门的 Excel 导出 DTO 类，避免处理实体类继承的复杂字段
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题17

### 导出功能参数绑定错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：Spring Boot 无法绑定 Collection<Long> 类型的数组参数
**解决方案**：将 Collection<Long> 改为 List<Long>
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题19

### 分页查询实现方式

**变更**：2026-03-13-add-construction-material-product
**问题描述**：分页查询采用了内存分页方式，先查询所有数据再进行分页
**解决方案**：当前实现方式对于数据量较小的情况是可接受的。如果数据量增大，建议改为数据库层面的分页查询
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题2

### MatProductMapper MyBatis 查询条件字段错误

**变更**：2026-03-13-add-construction-material-product
**问题描述**：MyBatis XML 的 parameterType 使用实体类，但查询条件字段在该实体类中不存在
**解决方案**：在实体类中添加查询条件字段，并使用 @TableField(exist = false) 标注
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题6

## 数据库问题

### 数据库插入 dict_id 为空错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：直接使用 SQL 插入时，没有提供 dict_id 值
**解决方案**：通过 Java 代码插入（推荐）或手动指定 dict_id 值
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题2

### 产品规格字段缺失

**变更**：2026-03-13-add-construction-material-product
**问题描述**：在初始设计中，mat_product 表缺少 product_spec（产品规格）字段
**解决方案**：已在数据库表、实体类、业务对象、视图对象和前端页面中添加 product_spec 字段
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题1

### mat_product 表缺少 tenant_id 字段

**变更**：2026-03-13-add-construction-material-product
**问题描述**：mat_product 表缺少 tenant_id 字段，导致查询报错
**解决方案**：在表中添加 tenant_id 字段，创建索引，并更新设计文档
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题9

## 编译问题

### Maven 编译版本号错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：在主 pom.xml 的 dependencyManagement 中没有定义模块版本号
**解决方案**：在主 pom.xml 的 dependencyManagement 部分添加版本定义
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题4

### TenantEntity 包路径错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：缺少 hny-common-tenant 依赖，导致无法找到 TenantEntity 类
**解决方案**：在模块 pom.xml 中添加 hny-common-tenant 依赖
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题5

### ExcelUtil 包路径错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：缺少 hny-common-excel 依赖，导致无法找到 ExcelUtil 类
**解决方案**：在模块 pom.xml 中添加 hny-common-excel 依赖
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题6

### 编译错误 - 缺少 delFlag 字段

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：实体类中没有定义 delFlag 字段
**解决方案**：在实体类中添加 delFlag 字段，使用 @TableLogic 注解
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题7

### 编译错误 - buildQueryWrapper 返回类型错误

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：方法返回类型声明为 Object，但实际返回的是 LambdaQueryWrapper
**解决方案**：修改方法的返回类型为正确的泛型类型
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题8

### 编译错误 - ExcelUtil.exportExcel 方法参数不匹配

**变更**：2026-03-12-building-materials-record-crud
**问题描述**：调用 ExcelUtil.exportExcel 时缺少 HttpServletResponse 参数
**解决方案**：添加 HttpServletResponse 导入，修改方法签名和调用
**参考**：archive/2026-03-12-building-materials-record-crud/issues.md#问题9

### 导出功能编译错误

**变更**：2026-03-13-add-construction-material-product
**问题描述**：MatProductController 中的导出方法调用错误，使用了不存在的 exportExcel 方法
**解决方案**：添加 ExcelUtil 类的导入，修改方法调用为 `ExcelUtil.exportExcel(list, "建材产品数据", MatProductVo.class, response);`
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题4

### MatRecordVo MapStruct 转换错误

**变更**：2026-03-13-add-construction-material-product
**问题描述**：MatRecordVo 中缺少从 TenantEntity 继承的字段，导致 MapStruct 无法正确生成转换器
**解决方案**：在 MatRecordVo 中添加 createTime、updateTime、createBy、updateBy 字段
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题5

## 开发流程问题

### 代码与设计文档不一致的根本问题

**变更**：2026-03-13-add-construction-material-product
**问题描述**：设计文档正确，但在实现时没有按照设计文档编写代码
**解决方案**：创建代码生成工具、一致性检查工具、开发规范文档，建立强制检查机制
**参考**：archive/2026-03-13-add-construction-material-product/issues.md#问题8

---

## 使用说明

### 如何添加新问题

1. 在变更目录下创建 `issues.md` 文件
2. 按照 `specs/common_architecture/spec.md` 中定义的格式记录问题
3. 将问题添加到本知识库的相应分类下
4. 包含参考链接，指向变更目录中的 issues.md

### 如何查找问题

1. 按类别浏览（前端、后端、数据库、编译、开发流程）
2. 使用关键词搜索
3. 点击参考链接查看详细的问题描述和解决方案

### 维护建议

1. 定期从各个变更的 issues.md 中提取问题
2. 按类别组织，便于快速查找
3. 保留参考链接，便于追溯详细信息
4. 归档变更时，务必同步 issues 到知识库
