## 实施过程中遇到的问题与解决方案

### 问题1：前端字典导入错误

**错误信息**：

```
[Vue Router warn]: Unexpected error when starting the router: SyntaxError: The requested module '/src/utils/dict.js' does not provide an export named 'default'
```

**问题原因**：
在 Vue 组件中使用了错误的字典导入方式：

```javascript
// ❌ 错误方式
import useDict from '@/utils/dict'
const { certificate_status } = useDict('certificate_status')
```

`@/utils/dict.js` 文件只导出了命名函数 `useDict`，没有默认导出。

**解决方案**：
使用正确的字典导入方式，通过 `proxy` 调用：

```javascript
// ✅ 正确方式
const { proxy } = getCurrentInstance()
const { certificate_status } = proxy.useDict('certificate_status')
```

**影响范围**：

- [record copy/index.vue](file:///e:\construction-material\construction-material-web\src\views\materials\record copy\index.vue)

**相关文档更新**：

- 更新了 [frontend-architecture.md](file:///e:\construction-material\specs\frontend-architecture.md)，添加了字典使用规范说明

---

### 问题2：数据库插入 dict_id 为空错误

**错误信息**：

```
null value in column "dict_id" of relation "sys_dict_type" violates not-null constraint
```

**问题原因**：

1. 数据库表结构中 `dict_id` 字段定义为 `NOT NULL`，但没有设置自增
2. MyBatis-Plus 的 `@TableId(value = "dict_id")` 默认使用 `IdType.ASSIGN_ID`（雪花算法生成 ID）
3. 直接使用 SQL 插入时，没有提供 `dict_id` 值，导致违反非空约束

**解决方案**：

**方式1：通过 Java 代码插入（推荐）**

```java
SysDictType dictType = new SysDictType();
dictType.setDictName("备案证状态");
dictType.setDictType("certificate_status");
// 其他字段设置...
sysDictTypeMapper.insert(dictType);  // dictId 会自动生成
```

**方式2：手动指定 dict_id 值**

```sql
INSERT INTO "master"."sys_dict_type" (
    "dict_id", 
    "dict_name", 
    -- 其他字段...
) VALUES ( 
    (SELECT COALESCE(MAX(dict_id), 0) + 1 FROM "master"."sys_dict_type"),
    '备案证状态',
    -- 其他值...
);
```

**相关文档**：

- [dict-sql.md](file:///e:\construction-material\openspec\changes\building-materials-record-crud-2026-03-03\dict-sql.md) 已改为配置信息格式，不再提供 SQL 语句

---

### 问题3：后端接口 404 错误

**错误信息**：

```
No mapping for GET /materials/record/list
请求地址'/materials/record/list'不存在
```

**问题原因**：
`hny-materials` 模块没有被引入到主应用 `hny-admin` 中，导致 Controller 无法被加载。

**解决方案**：
在 [hny-admin/pom.xml](file:///e:\construction-material\construction-material-backend\hny-admin\pom.xml) 中添加 `hny-materials` 模块依赖：

```xml
<dependency>
    <groupId>com.hny</groupId>
    <artifactId>hny-materials</artifactId>
</dependency>
```

**验证步骤**：

1. 重新编译项目：`mvn clean install`
2. 重启后端服务
3. 访问接口验证：`GET /materials/record/list`

---

### 问题4：Maven 编译版本号错误

**错误信息**：

```
'dependencies.dependency.version' for com.hny:hny-materials:jar is missing.
```

**问题原因**：
在主 pom.xml 的 `dependencyManagement` 中没有定义 `hny-materials` 的版本号，导致 Maven 无法解析依赖版本。

**解决方案**：
在 [主 pom.xml](file:///e:\construction-material\construction-material-backend\pom.xml) 的 `dependencyManagement` 部分添加版本定义：

```xml
<dependency>
    <groupId>com.hny</groupId>
    <artifactId>hny-materials</artifactId>
    <version>${revision}</version>
</dependency>
```

**验证步骤**：

1. 执行 Maven clean：`mvn clean`
2. 确认编译成功

---

### 问题5：TenantEntity 包路径错误

**错误信息**：

```
程序包com.hny.common.tenant.core不存在
```

**问题原因**：
[MatRecord.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\domain\MatRecord.java#L4) 实体类继承了 `TenantEntity`，但 `hny-materials/pom.xml` 中缺少 `hny-common-tenant` 依赖，导致编译时无法找到该类。

**解决方案**：
在 [hny-materials/pom.xml](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\pom.xml) 中添加 `hny-common-tenant` 依赖：

```xml
<dependency>
    <groupId>com.hny</groupId>
    <artifactId>hny-common-tenant</artifactId>
</dependency>
```

**验证步骤**：

1. 重新编译项目：`mvn clean install`
2. 确认编译成功

---

### 问题6：ExcelUtil 包路径错误

**错误信息**：

```
程序包com.hny.common.excel.utils不存在
```

**问题原因**：
[MatRecordController.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\controller\MatRecordController.java#L9) 中导入了 `ExcelUtil` 用于导出功能，但 `hny-materials/pom.xml` 中缺少 `hny-common-excel` 依赖，导致编译时无法找到该类。

**解决方案**：
在 [hny-materials/pom.xml](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\pom.xml) 中添加 `hny-common-excel` 依赖：

```xml
<dependency>
    <groupId>com.hny</groupId>
    <artifactId>hny-common-excel</artifactId>
</dependency>
```

**验证步骤**：

1. 重新编译项目：`mvn clean install`
2. 确认编译成功

---

### 问题7：编译错误 - 缺少 delFlag 字段

**错误信息**：

```
找不到符号: 方法 getDelFlag()
位置: 类 com.hny.materials.domain.MatRecord
```

**问题原因**：
[MatRecordServiceImpl.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\service\impl\MatRecordServiceImpl.java#L47) 中使用了 `MatRecord::getDelFlag`，但 `MatRecord` 实体类中没有定义 `delFlag` 字段。根据项目规范，需要添加 `delFlag` 字段用于逻辑删除。

**解决方案**：
在 [MatRecord.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\domain\MatRecord.java) 中添加 `delFlag` 字段：

```java
/**
 * 删除标志（0代表存在 2代表删除）
 */
@TableLogic
private String delFlag;
```

---

### 问题8：编译错误 - buildQueryWrapper 返回类型错误

**错误信息**：

```
不兼容的类型: java.lang.Object无法转换为com.baomidou.mybatisplus.core.conditions.Wrapper<com.hny.materials.domain.MatRecord>
```

**问题原因**：
[MatRecordServiceImpl.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\service\impl\MatRecordServiceImpl.java#L63) 中 `buildQueryWrapper` 方法的返回类型声明为 `Object`，但实际返回的是 `LambdaQueryWrapper<MatRecord>`。

**解决方案**：
修改 `buildQueryWrapper` 方法的返回类型：

```java
// 修改前
private Object buildQueryWrapper(MatRecord matRecord) {

// 修改后
private com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<MatRecord> buildQueryWrapper(MatRecord matRecord) {
```

---

### 问题9：编译错误 - ExcelUtil.exportExcel 方法参数不匹配

**错误信息**：

```
对于exportExcel(List<MatRecord>, String, Class<MatRecord>), 找不到合适的方法
方法 com.hny.common.excel.utils.ExcelUtil.exportExcel(List, String, Class)不适用
(实际参数列表和形式参数列表长度不同)
```

**问题原因**：
[MatRecordController.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\controller\MatRecordController.java#L49) 中调用 `ExcelUtil.exportExcel` 时缺少 `HttpServletResponse` 参数，且没有导入该类。

**解决方案**：

1. 添加 `HttpServletResponse` 导入：

```java
import jakarta.servlet.http.HttpServletResponse;
```

1. 修改 `export` 方法签名和调用：

```java
// 修改前
public void export(MatRecord matRecord) {
    List<MatRecord> list = matRecordService.selectMatRecordList(matRecord);
    ExcelUtil.exportExcel(list, "备案产品数据", MatRecord.class);
}

// 修改后
public void export(MatRecord matRecord, HttpServletResponse response) {
    List<MatRecord> list = matRecordService.selectMatRecordList(matRecord);
    ExcelUtil.exportExcel(list, "备案产品数据", MatRecord.class, response);
}
```

---

### 问题10：权限验证失败 - 权限标识不匹配

**错误信息**：

```
权限码校验失败'无此权限：materials:record'
```

**问题原因**：
[MatRecordController.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\controller\MatRecordController.java) 中使用的权限标识与菜单配置不匹配：

- **Controller 使用**：`materials:record`、`materials:add`、`materials:edit`、`materials:remove`
- **菜单配置**：`building:materials:record`、`building:materials:add`、`building:materials:edit`、`building:materials:remove`

权限标识格式不一致导致权限验证失败。

**解决方案**：
统一使用 `building:materials:*` 格式的权限标识，修改 [MatRecordController.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\controller\MatRecordController.java) 中的所有权限注解：

```java
// 修改前
@SaCheckPermission("materials:record")
@SaCheckPermission("materials:add")
@SaCheckPermission("materials:edit")
@SaCheckPermission("materials:remove")

// 修改后
@SaCheckPermission("building:materials:record")
@SaCheckPermission("building:materials:add")
@SaCheckPermission("building:materials:edit")
@SaCheckPermission("building:materials:remove")
```

**注意事项**：

- 权限标识必须与系统管理 → 菜单管理中配置的权限标识完全一致
- 格式为：`模块:页面:操作`（如 `building:materials:record`）
- 页面权限：`building:materials:record`
- 按钮权限：`building:materials:query`、`building:materials:add`、`building:materials:edit`、`building:materials:remove`

---

### 问题11：权限标识更新 - 统一权限格式

**错误信息**：
权限标识格式不一致，需要统一为 `materials:record:*` 格式。

**问题原因**：
权限标识格式不统一，之前使用了不同的格式：

- **旧格式**：`building:materials:record`、`building:materials:add`、`building:materials:edit`、`building:materials:remove`
- **新格式**：`materials:record:list`、`materials:record:query`、`materials:record:add`、`materials:record:edit`、`materials:record:remove`

**解决方案**：

1. **更新菜单配置**：在 [menu-sql.md](file:///e:\construction-material\openspec\changes\building-materials-record-crud-2026-03-03\menu-sql.md) 中更新权限标识
2. **更新后端 Controller**：在 [MatRecordController.java](file:///e:\construction-material\construction-material-backend\hny-modules\hny-materials\src\main\java\com\hny\materials\controller\MatRecordController.java) 中更新权限注解
3. **更新前端代码**：在 [index.vue](file:///e:\construction-material\construction-material-web\src\views\materials\record\index.vue) 中更新 `v-hasPermi` 指令

**新的权限标识列表**：

- 页面权限：`materials:record:list`
- 查询权限：`materials:record:query`（用于导出和详情查看）
- 新增权限：`materials:record:add`
- 修改权限：`materials:record:edit`
- 删除权限：`materials:record:remove`

**注意事项**：

- 权限标识必须与系统管理 → 菜单管理中配置的权限标识完全一致
- 前端和后端的权限标识必须保持一致
- 格式为：`模块:页面:操作`（如 `materials:record:list`）

---

## 总结与建议

### 关键要点

1. **模块依赖管理**：新增模块后，必须在主 pom.xml 的 `dependencyManagement` 中添加版本定义，并在 hny-admin 的 pom.xml 中引入依赖

2. **字典使用规范**：在 Vue 3 Composition API 中，必须通过 `proxy.useDict()` 调用字典函数，不能直接导入使用

3. **数据库主键策略**：MyBatis-Plus 默认使用雪花算法生成 ID，直接 SQL 插入需要手动指定主键值

4. **配置信息格式**：菜单和字典配置改为关键字信息格式，便于在系统管理页面中手动配置，避免 SQL 语句的复杂性

### 后续优化建议

1. **代码生成模板**：更新后端代码生成模板，确保新生成的模块自动包含在主 pom.xml 中

2. **前端规范文档**：将字典使用规范纳入前端开发规范，避免类似问题重复出现

3. **开发流程文档**：建立新增模块的标准开发流程文档，明确各步骤的依赖关系

4. **自动化检查**：考虑添加 CI/CD 检查，确保新增模块的依赖配置正确

---

### 问题12：前端表格列索引错误

**错误信息**：

```
Cannot read properties of undefined (reading 'visible')
```

**问题原因**：

将两个日期列（有效期开始日期和有效期结束日期）合并为一个列（备案证有效期）后，columns 数组从9个元素减少到8个元素，但表格中其他列的索引没有相应调整，导致引用了不存在的索引。

**解决方案**：

同步调整 columns 数组索引：

- 将 `columns[7]`（备案证状态）改为 `columns[6]`
- 将 `columns[8]`（创建时间）改为 `columns[7]`

**相关文档更新**：

- 更新了 [frontend-architecture.md](file:///e:\construction-material\specs\frontend-architecture.md)，添加了表格列配置规范

---

### 问题13：日期选择器验证失败

**错误信息**：

```
备案证有效期不能为空
```

**问题原因**：

表单验证规则检查的是 `validityRange`，但 `validityRange` 是独立的响应式变量，不是 `form` 的一部分。当用户选择日期后，`validityRange` 有值，但 `form.startValidity` 和 `form.endValidity` 并没有被更新，导致表单验证失败。

**解决方案**：

1. 修改验证规则，让它检查 `form.startValidity` 和 `form.endValidity` 而不是 `validityRange`
2. 添加 `@change="handleValidityChange"` 事件处理器
3. 实现 `handleValidityChange` 方法，将范围选择器的值同步到 form 中

**相关文档更新**：

- 更新了 [frontend-architecture.md](file:///e:\construction-material\specs\frontend-architecture.md)，添加了日期范围选择器规范

---

### 问题14：后端导出接口500错误

**错误信息**：

```json
{
  "timestamp": "2026-03-05 10:06:13",
  "status": 500,
  "error": "Internal Server Error",
  "path": "/materials/record/export"
}
```

**问题原因**：

MatRecord 实体类缺少 Excel 相关的注解，导致 ExcelUtil.exportExcel 方法无法正确识别字段并导出数据。

**解决方案**：

为 MatRecord 实体类的所有字段添加 `@ExcelProperty` 注解，并为备案证状态字段添加字典转换注解：

1. 添加必要的导入：

   ```java
   import com.alibaba.excel.annotation.ExcelProperty;
   import com.hny.common.excel.annotation.ExcelDictFormat;
   import com.hny.common.excel.convert.ExcelDictConvert;
   ```

2. 为所有字段添加 `@ExcelProperty` 注解：

   ```java
   @ExcelProperty(value = "字段显示名称")
   private String fieldName;
   ```

3. 为字典类型字段添加字典转换注解：

   ```java
   @ExcelProperty(value = "备案证状态", converter = ExcelDictConvert.class)
   @ExcelDictFormat(dictType = "certificate_status")
   private String certificateStatus;
   ```

**相关文档更新**：

- 更新了 [design.md](file:///e:\construction-material\openspec\changes\building-materials-record-crud-2026-03-03\design.md)，添加了 Excel导出规范

---

### 问题17：Excel导出实现

**问题描述**：

需要实现Excel导出功能，导出备案产品数据。

**解决方案**：

创建专门的 Excel 导出 DTO 类 `MatRecordExcelVO`，避免处理实体类继承的复杂字段：

1. **创建 MatRecordExcelVO 类**，只包含需要导出的字段
2. **修改 MatRecordController.export 方法**，将 MatRecord 转换为 MatRecordExcelVO
3. **使用 MatRecordExcelVO 进行导出**，避免处理父类的 params 字段

**相关代码**：

```java
// MatRecordExcelVO.java
package com.hny.materials.domain.vo;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

import java.time.LocalDate;

@Data
public class MatRecordExcelVO {
    @ExcelProperty(value = "主键ID")
    private Long id;

    @ExcelProperty(value = "生产企业名称")
    private String enterpriseName;

    @ExcelProperty(value = "统一社会信用代码")
    private String socialCreditCode;

    @ExcelProperty(value = "备案产品名称")
    private String productName;

    @ExcelProperty(value = "备案证号")
    private String certificateNumber;

    @ExcelProperty(value = "有效期开始日期")
    private LocalDate startValidity;

    @ExcelProperty(value = "有效期结束日期")
    private LocalDate endValidity;

    @ExcelProperty(value = "备案证状态")
    private String certificateStatus;

    @ExcelProperty(value = "租户编号")
    private String tenantId;
}

// MatRecordController.java
@SaCheckPermission("materials:record:query")
@PostMapping("/export")
public void export(MatRecord matRecord, HttpServletResponse response) {
    List<MatRecord> list = matRecordService.selectMatRecordList(matRecord);
    // 转换为 Excel 导出对象
    List<MatRecordExcelVO> excelVOList = list.stream().map(record -> {
        MatRecordExcelVO vo = new MatRecordExcelVO();
        vo.setId(record.getId());
        vo.setEnterpriseName(record.getEnterpriseName());
        vo.setSocialCreditCode(record.getSocialCreditCode());
        vo.setProductName(record.getProductName());
        vo.setCertificateNumber(record.getCertificateNumber());
        vo.setStartValidity(record.getStartValidity());
        vo.setEndValidity(record.getEndValidity());
        vo.setCertificateStatus(record.getCertificateStatus());
        vo.setTenantId(record.getTenantId());
        return vo;
    }).collect(java.util.stream.Collectors.toList());
    ExcelUtil.exportExcel(excelVOList, "备案产品数据", MatRecordExcelVO.class, response);
}
```

**注意事项**：

- 使用专门的 Excel 导出 DTO 类可以避免处理父类的复杂字段（如 params、searchValue 等）
- 这种方式更加灵活，可以根据需要调整导出字段
- 避免了 `@ExcelIgnore` 注解的使用限制
- 字典类型字段暂时直接导出字典值，不进行字典转换
- Excel 导出 DTO 类应放在 `com.hny.{module}.domain.vo` 包下
- 类名应为 `{Entity}ExcelVO` 格式

**文档更新时间**：2026-03-05
**问题记录人**：开发团队

---

### 问题19：导出功能参数绑定错误

**错误信息**：

```json
{
  "code": 500,
  "msg": "Invalid property 'ids[0]' of bean class [com.hny.materials.domain.MatRecord]: Property referenced in indexed property path 'ids[0]' is neither an array nor a List nor a Map; returned value was [[]]",
  "data": null
}
```

**问题原因**：

Spring Boot 在绑定 URL 编码的数组参数时，需要使用 `List<Long>` 而不是 `Collection<Long>`。`Collection<Long>` 是一个接口，Spring Boot 无法确定具体的实现类来绑定数组参数。

**解决方案**：

将所有使用 `Collection<Long>` 的地方改为 `List<Long>`：

1. **MatRecord 实体类**：

   ```java
   // 修改前
   @TableField(exist = false)
   private Collection<Long> ids;
   
   // 修改后
   @TableField(exist = false)
   private List<Long> ids;
   ```

2. **IMatRecordService 接口**：

   ```java
   // 修改前
   List<MatRecord> selectMatRecordByIds(Collection<Long> ids);
   
   // 修改后
   List<MatRecord> selectMatRecordByIds(List<Long> ids);
   ```

3. **MatRecordServiceImpl 实现**：

   ```java
   // 修改前
   @Override
   public List<MatRecord> selectMatRecordByIds(Collection<Long> ids) {
       return baseMapper.selectBatchIds(ids);
   }
   
   // 修改后
   @Override
   public List<MatRecord> selectMatRecordByIds(List<Long> ids) {
       return baseMapper.selectBatchIds(ids);
   }
   ```

**注意事项**：

- Spring Boot 在绑定 URL 编码的数组参数时，需要使用具体的 List 类型
- `Collection<Long>` 是一个接口，Spring Boot 无法确定具体的实现类
- 使用 `List<Long>` 可以让 Spring Boot 正确绑定数组参数
- MyBatis-Plus 的 `selectBatchIds` 方法接受 `Collection` 参数，所以传入 `List` 没有问题

**文档更新时间**：2026-03-05
**问题记录人**：开发团队

---

### 问题18：导出功能支持选择部分数据

**需求描述**：

导出功能需要支持前端选择部分数据导出，而不是总是导出全部数据。前端选择几个数据，后端就导出几个数据，就像批量删除功能一样。

**解决方案**：

1. **前端修改**：
   - 在导出方法中检查是否有选中的数据（ids.value）
   - 如果有选中的数据，将 ids 传递给后端
   - 如果没有选中的数据，导出查询条件下的所有数据

2. **后端修改**：
   - 在 MatRecord 实体类中添加 ids 字段（@TableField(exist = false)）
   - 在 IMatRecordService 接口中添加 selectMatRecordByIds 方法
   - 在 MatRecordServiceImpl 中实现 selectMatRecordByIds 方法
   - 在 MatRecordController.export 方法中判断 ids 是否为空
   - 如果 ids 不为空，调用 selectMatRecordByIds 方法
   - 如果 ids 为空，调用 selectMatRecordList 方法

**相关代码**：

```javascript
// 前端 index.vue
const handleExport = () => {
  proxy.download('materials/record/export', { ...queryParams.value, ids: ids.value }, `record_${new Date().getTime()}.xlsx`)
}
```

```java
// 后端 MatRecord.java
@TableField(exist = false)
private List<Long> ids;

// 后端 IMatRecordService.java
List<MatRecord> selectMatRecordByIds(List<Long> ids);

// 后端 MatRecordServiceImpl.java
@Override
public List<MatRecord> selectMatRecordByIds(List<Long> ids) {
    return baseMapper.selectBatchIds(ids);
}

// 后端 MatRecordController.java
@PostMapping("/export")
public void export(MatRecord matRecord, HttpServletResponse response) {
    List<MatRecord> list;
    if (matRecord.getIds() != null && !matRecord.getIds().isEmpty()) {
        // 如果传入了ids，导出选中的数据
        list = matRecordService.selectMatRecordByIds(matRecord.getIds());
    } else {
        // 否则导出查询条件下的所有数据
        list = matRecordService.selectMatRecordList(matRecord);
    }
    // 转换为 Excel 导出对象并导出
}
```

**注意事项**：

- ids 字段使用 @TableField(exist = false) 注解，表示这不是数据库字段
- 前端使用 proxy.download 方法，它会将参数转换为 URL 编码格式
- 后端使用 @PostMapping 接收参数，Spring Boot 会自动解析 URL 编码的参数
- 与批量删除功能保持一致的用户体验

**文档更新时间**：2026-03-05
**问题记录人**：开发团队
