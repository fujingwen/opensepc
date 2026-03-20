# Issues - 建材产品功能

## 已知问题

### 1. 产品规格字段缺失

**状态**: 已修复
**描述**: 在初始设计中，mat_product 表缺少 product_spec（产品规格）字段
**解决方案**: 已在数据库表、实体类、业务对象、视图对象和前端页面中添加 product_spec 字段

### 2. 分页查询实现方式

**状态**: 已实现
**描述**: MatProductServiceImpl 中的分页查询采用了内存分页方式，先查询所有数据再进行分页
**解决方案**: 当前实现方式对于数据量较小的情况是可接受的。如果数据量增大，建议改为数据库层面的分页查询

### 3. 文件上传功能

**状态**: 已实现
**描述**: 前端使用了 file-upload 和 image-upload 组件，需要确保后端已配置文件上传服务
**解决方案**: 前端已集成文件上传组件，需要确认后端文件上传配置正确

### 4. 导出功能编译错误

**状态**: 已修复
**描述**: MatProductController 中的导出方法调用错误，使用了不存在的 exportExcel 方法
**原因**:

- 缺少 ExcelUtil 类的导入
- exportExcel 方法需要 4 个参数（列表、文件名、数据类型、响应对象），但只传了 3 个参数
**解决方案**:
- 添加导入语句：`import com.hny.common.excel.utils.ExcelUtil;`
- 修改方法调用：`ExcelUtil.exportExcel(list, "建材产品数据", MatProductVo.class, response);`
**重要提示**: 后端代码模板 [backend-code-template.md](../templates/backend-code-template.md) 中已经包含正确的导出方法实现模板，后续开发时请严格按照模板实现，避免类似错误

### 5. MatRecordVo MapStruct 转换错误

**状态**: 已修复
**描述**: 访问 /materials/record/list 时报错：`cannot find converter from MatRecord to MatRecordVo`
**原因**:

- MatRecord 实体类继承自 TenantEntity，包含 createTime、updateTime、createBy、updateBy 等字段
- MatRecordVo 中缺少这些字段，导致 MapStruct 无法正确生成转换器
**解决方案**:
- 在 MatRecordVo 中添加以下字段：

  ```java
  private Date createTime;
  private Date updateTime;
  private String createBy;
  private String updateBy;
  ```

**重要提示**: 所有 VO 类都应该包含对应实体类从 TenantEntity 继承的所有字段，包括 createTime、updateTime、createBy、updateBy、tenantId

### 6. MatProductMapper MyBatis 查询条件字段错误

**状态**: 已修复
**描述**: 访问 /materials/product/list 时报错：`NoSuchPropertyException: com.hny.materials.domain.MatProduct.purchaseQuantityMin`
**原因**:

- MatProductMapper.xml 的 parameterType 使用的是 MatProduct
- 查询条件中使用了 purchaseQuantityMin、purchaseQuantityMax、entryTimeStart、entryTimeEnd、createTimeStart、createTimeEnd 等字段
- 这些字段只在 MatProductBo 中存在，MatProduct 实体类中没有
**解决方案**:
- 在 MatProduct 实体类中添加查询条件字段，并使用 @TableField(exist = false) 标注：

  ```java
  @TableField(exist = false)
  private BigDecimal purchaseQuantityMin;
  
  @TableField(exist = false)
  private BigDecimal purchaseQuantityMax;
  
  @TableField(exist = false)
  private LocalDate entryTimeStart;
  
  @TableField(exist = false)
  private LocalDate entryTimeEnd;
  
  @TableField(exist = false)
  private LocalDate createTimeStart;
  
  @TableField(exist = false)
  private LocalDate createTimeEnd;
  ```

**重要提示**: 当 MyBatis XML 的 parameterType 使用实体类时，查询条件字段必须在该实体类中存在，否则需要使用 @TableField(exist = false) 标注

### 7. 前端查询条件与设计文档不一致

**状态**: 已修复
**描述**: 前端页面展示的查询条件与设计文档定义的不相同（字段和顺序都不同）
**原因**:

- 前端实现时未严格按照设计文档 [design.md#L253-271](design.md#L253-271) 的定义
- 前端缺少"工程名称"、"产品规格"、"采购数量"等查询条件
- 前端多出了"工程进度"、"供应商名称"等设计文档中未定义的查询条件
- 查询条件顺序与设计文档不一致
**解决方案**:
- 前端查询条件严格按照设计文档实现，顺序如下：
  1. 施工单位名称（input，模糊查询）
  2. 工程名称（input，模糊查询）
  3. 产品类别（input，模糊查询）
  4. 产品名称（input，模糊查询）
  5. 产品规格（input，模糊查询）
  6. 生产单位名称（input，模糊查询）
  7. 采购数量（input range，范围查询，格式：最小值~最大值）
  8. 进场时间（date range，范围查询）
  9. 填报时间（date range，范围查询）
  10. 信息确认状态（select，字典查询）
  11. 信息确认超时（select，字典查询）
  12. 信息确认不通过类别（select，字典查询）
  13. 信息确认单位（input，模糊查询）
  14. 质量监督机构（input，模糊查询）
  15. 有无备案证号（select，字典查询）
- 在 MatProduct 和 MatProductBo 中添加 projectName 字段
- 在 MatProductMapper.xml 中添加工程名称的查询条件（关联 mat_project 表）
- 前端处理采购数量范围查询，将"最小值~最大值"格式转换为 purchaseQuantityMin 和 purchaseQuantityMax
**重要提示**: 前端实现必须严格按照设计文档进行，包括字段类型、查询方式和顺序，确保与设计文档一致

### 8. 代码与设计文档不一致的根本问题

**状态**: 已解决
**描述**: 设计文档正确，但在实现时没有按照设计文档编写代码
**根本原因**:

1. **手动编写代码**：开发人员手动编写前端和后端代码，容易遗漏或错误
2. **缺少对照检查**：没有强制要求对照设计文档进行验证
3. **模板不够智能**：现有模板只是示例，不能自动引用设计文档
4. **缺少自动化工具**：没有工具自动检查代码与设计文档的一致性
5. **开发流程不规范**：没有明确的开发流程和质量控制点
**系统性解决方案**:
6. **创建代码生成工具**：[generate-code-from-design.py](../../tools/generate-code-from-design.py)
   - 自动从设计文档解析查询条件、列表字段、表单字段
   - 自动生成前端查询条件代码（严格按照设计文档的顺序和类型）
   - 自动生成前端查询参数定义
   - 自动生成后端 Mapper XML 查询条件
   - 自动生成后端实体类查询条件字段
7. **创建一致性检查工具**：[check-code-consistency.py](../../tools/check-code-consistency.py)
   - 自动检查前端查询条件是否与设计文档一致
   - 自动检查后端 Mapper XML 是否与设计文档一致
   - 自动检查实体类字段是否与设计文档一致
   - 输出详细的错误和警告信息
8. **创建开发规范文档**：[development-guidelines.md](../../development-guidelines.md)
   - 明确核心原则：代码必须严格按照设计文档实现
   - 定义完整的开发流程（设计、代码生成、审查、测试）
   - 提供代码规范（前端、后端）
   - 列出常见错误及解决方案
   - 提供代码审查清单
9. **优化代码生成模板**：
   - 在前端模板中添加重要提示，强调查询条件必须严格按照设计文档
   - 在后端模板中添加重要提示，强调查询条件字段必须完整
10. **建立强制检查机制**：

- 代码提交前必须运行一致性检查工具
- 代码审查必须对照设计文档逐项检查
- 所有错误必须修复才能合并代码
**使用方法**:

```bash
# 从设计文档生成代码
python openspec/tools/generate-code-from-design.py

# 检查代码与设计文档的一致性
python openspec/tools/check-code-consistency.py
```

**重要提示**:

- 强烈推荐使用自动化工具生成代码，避免手动编写导致的遗漏和错误
- 代码提交前必须运行一致性检查工具，确保代码与设计文档一致
- 代码审查必须对照设计文档逐项检查，确保没有遗漏或错误
- 开发过程中必须遵循 [development-guidelines.md](../../development-guidelines.md) 中定义的开发规范

### 9. mat_product 表缺少 tenant_id 字段

**状态**: 已修复
**描述**: 访问 /materials/product/list 时报错：`ERROR: column mp.tenant_id does not exist`
**原因**:

- mat_product 表缺少 tenant_id 字段
- MatProduct 实体类继承自 TenantEntity，包含 tenantId 字段
- Mapper XML 中使用了 mp.tenant_id 进行查询
- 但数据库表中没有 tenant_id 列
**解决方案**:
1. **更新数据库设计**：
   - 在 base_mat_product.sql 中添加 tenant_id 字段
   - 字段定义：`"tenant_id" varchar(20) NOT NULL DEFAULT '000000'`
   - 添加索引：`idx_product_tenant_id`
   - 添加注释：`COMMENT ON COLUMN "master"."mat_product"."tenant_id" IS '租户编号'`
2. **创建迁移脚本**：[add_tenant_id_to_mat_product.sql](add_tenant_id_to_mat_product.sql)
   - 为现有表添加 tenant_id 字段
   - 添加索引和注释
3. **更新设计文档**：
   - 在 design.md 的数据库设计部分添加 tenant_id 字段
   - 确保所有表都有 tenant_id 字段
**重要提示**:
- **所有表都必须包含 tenant_id 字段**，以支持多租户功能
- tenant_id 字段类型为 varchar(20)，默认值为 '000000'
- 必须为 tenant_id 创建索引以提高查询性能
- 实体类必须继承 TenantEntity，自动包含 tenantId 字段
- Mapper XML 必须包含 tenant_id 的查询条件

### 10. 前端实现与设计文档不一致

**状态**: 已修复
**描述**: 前端列表展示字段、新增页面字段与设计文档 [design.md#L276-324](design.md#L276-324) 不一致
**原因**:

- 前端实现时未严格按照设计文档的定义
- 列表展示字段顺序和内容与设计文档不一致
- 新增页面字段顺序与设计文档不一致
- 文件上传限制与设计文档不一致
**解决方案**:
1. **修复列表展示字段**：
   - 按照设计文档顺序调整字段：序号、施工单位名称、工程名称、产品类别、质量监督机构、产品名称、产品规格、工程进度、采购数量、采购单价、进场时间、填报时间、生产单位名称、代理商名称、供应商名称、最后更新时间、监理申请、有无备案证号、备案证号、信息确认状态、操作
   - 移除设计文档中未定义的字段：单位、生产批号、生产日期、信息确认超时、信息确认单位
   - 添加设计文档中定义但缺少的字段：工程名称、填报时间、代理商名称、最后更新时间、监理申请、备案证号
2. **修复新增页面字段**：
   - 按照设计文档顺序调整字段：工程名称、施工单位名称、工程进度、产品类别、产品名称、单位、生产单位名称、生产单位省市区、生产单位详细地址、供应商名称、生产批号、生产日期、采购数量、采购单价、产品合格证、出厂检验报告、性能检验报告、实物照片
   - 移除设计文档中未定义的字段：进场时间、代理商名称、有无备案证号、备案证号、监理申请
3. **修复文件上传限制**：
   - 产品合格证：最多1张 ✓
   - 出厂检验报告：最多2张（原为1张）
   - 性能检验报告：最多8张（原为1张）
   - 实物照片：最多1张（原为5张）
**重要提示**:
- 前端实现必须严格按照设计文档进行，包括字段类型、查询方式、顺序和限制
- 代码审查时必须对照设计文档逐项检查
- 使用一致性检查工具可以自动发现此类问题

## 待验证事项

### 1. 数据库索引优化

**状态**: 待验证
**描述**: 已创建以下索引，需要在实际运行中验证查询性能：

- idx_product_project_id (project_id)
- idx_product_construction_unit (construction_unit_name)
- idx_product_name (product_name)
- idx_product_entry_time (entry_time)
- idx_product_confirm_status (info_confirm_status)

### 2. 权限控制

**状态**: 待验证
**描述**: 需要验证以下权限控制是否生效：

- materials:product:list - 查询权限
- materials:product:query - 详情查询权限
- materials:product:add - 新增权限
- materials:product:edit - 编辑权限
- materials:product:remove - 删除权限
- materials:product:export - 导出权限
- materials:product:audit - 审核权限

### 3. 编辑删除操作限制

**状态**: 待验证
**描述**: 需要验证仅信息确认状态为"待信息确认"时可编辑删除的限制是否正确实现

### 4. 字典数据

**状态**: 待验证
**描述**: 需要验证以下字典数据是否正确配置：

- info_confirm_status (信息确认状态)
- info_confirm_timeout (信息确认超时)
- info_confirm_fail_type (信息确认不通过类别)
- has_certificate_number (有无备案证号)
- project_progress (工程进度)

## 潜在改进

### 1. 数据库分页优化

**优先级**: 中
**描述**: 当前 MatProductServiceImpl 采用内存分页，建议改为 MyBatis-Plus 的数据库分页
**建议**: 使用 Page<MatProduct> 和 baseMapper.selectPage() 方法

### 2. 审核功能实现

**优先级**: 低
**描述**: 当前审核功能仅预留接口，未实现具体逻辑
**建议**: 根据业务需求实现完整的审核流程

### 3. 数据校验增强

**优先级**: 中
**描述**: 可以增加更多的数据校验规则，如：

- 生产日期不能晚于进场时间
- 采购数量和采购单价必须大于0
- 备案证号格式校验

### 4. 批量操作优化

**优先级**: 低
**描述**: 可以增加批量导入功能，提高数据录入效率

## 部署注意事项

### 1. 数据库脚本执行顺序

必须按照以下顺序执行 SQL 脚本：

1. base_sequences.sql - 创建序列
2. base_mat_product.sql - 创建表和索引
3. base_dict.sql - 插入字典数据
4. base_menu.sql - 插入菜单和权限数据

### 2. 后端编译

确保后端代码编译无错误：

```bash
cd construction-material-backend
mvn clean compile -DskipTests
```

### 3. 前端构建

确保前端代码可以正常构建：

```bash
cd construction-material-web
npm run build:prod
```

### 4. 文件上传配置

确保后端文件上传配置正确，包括：

- 文件上传路径
- 文件大小限制
- 文件类型限制

## 测试建议

### 1. 功能测试

- 测试建材产品的增删改查功能
- 测试多条件组合查询
- 测试分页功能
- 测试文件上传功能
- 测试导出功能

### 2. 权限测试

- 测试不同角色的权限控制
- 测试编辑删除操作限制

### 3. 性能测试

- 测试大数据量下的查询性能
- 测试并发操作下的系统稳定性

### 4. 兼容性测试

- 测试不同浏览器的兼容性
- 测试移动端适配
