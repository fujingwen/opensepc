## Context

当前项目是一个基于Spring Boot和Vue的后台管理系统，需要新增建材填报管理模块，实现备案产品的增删改查功能。根据需求，模块包含三个业务模块：工程项目、建材产品、备案产品，本次优先实现备案产品的管理功能。

## Goals / Non-Goals

**Goals:**

- 创建建材填报管理模块，包含三个业务模块：工程项目、建材产品、备案产品
- 实现备案产品的增删改查功能
- 设计备案产品的数据模型，包含生产企业名称、统一社会信用代码、备案产品名称、备案证号、备案证有效期、备案证状态等字段
- 实现前端页面和后端API接口
- 集成到现有的权限管理体系中

**Non-Goals:**

- 本次不实现工程项目和建材产品的管理功能
- 不修改现有系统的核心架构
- 不涉及第三方系统集成

## Decisions

1. **模块结构设计**
   - 后端：在hny-modules下新增hny-materials模块
   - 前端：在src/views下新增materials目录
   - 理由：遵循现有的模块划分规范，保持代码结构清晰

2. **数据模型设计**
   - 表名：mat_record
   - 字段：
     - id (主键)
     - enterprise_name (生产企业名称，必填)
     - social_credit_code (统一社会信用代码)
     - product_name (备案产品名称，必填)
     - certificate_number (备案证号)
     - start_validity (备案证有效期开始日期，必填，格式：xxxx-xx-xx)
     - end_validity (备案证有效期结束日期，必填，格式：xxxx-xx-xx)
     - certificate_status (备案证状态，字典，存储字典值)
     - del_flag (删除标志，逻辑删除)
     - create_by, create_time, update_by, update_time (审计字段，继承自TenantEntity)
   - 理由：根据业务需求设计字段，符合数据库设计规范

## 数据验证规则

### 前端验证

- **生产企业名称**：必填，非空验证
- **备案产品名称**：必填，非空验证
- **备案证有效期**：必填，日期范围格式验证（xxxx-xx-xx 至 xxxx-xx-xx）
- **统一社会信用代码**：18位数字和字母组合验证
- **备案证状态**：使用字典值验证

### 后端验证

- **生产企业名称**：`@NotNull` 注解验证
- **备案产品名称**：`@NotNull` 注解验证
- **备案证有效期**：`@NotNull` 注解验证开始日期和结束日期
- **统一社会信用代码**：正则表达式验证
- **备案证状态**：枚举值验证

## 权限设计

- 菜单：建材填报管理 -> 备案产品管理
- 权限：materials:record:list, materials:record:query, materials:record:add, materials:record:edit, materials:record:remove
- 理由：遵循现有的权限管理体系，细粒度控制操作权限

## 权限配置明细

### 菜单管理配置

在前端"系统管理-菜单管理"中配置以下菜单：

| 菜单名称 | 排序 | 权限标识 | 组件路径 | 状态 |
|---------|------|---------|---------|------|
| **建材填报管理** | 100 | 无 | 无 | 正常 |
| └─ **备案产品管理** | 1 | materials:record:list | materials/record/index | 正常 |
| ├─ 备案产品查询 | 1 | materials:record:query | 无 | 正常 |
| ├─ 备案产品新增 | 2 | materials:record:add | 无 | 正常 |
| ├─ 备案产品修改 | 3 | materials:record:edit | 无 | 正常 |
| └─ 备案产品删除 | 4 | materials:record:remove | 无 | 正常 |

### 权限字符串格式

- **格式**：模块:页面:操作（三级）
- **示例**：
  - 页面权限：materials:record:list
  - 查询按钮：materials:record:query
  - 新增按钮：materials:record:add
  - 修改按钮：materials:record:edit
  - 删除按钮：materials:record:remove

### 实现方式

**前端实现**：

- 菜单权限：根据后端返回动态确定，不需要在路由配置中设置 `meta.permissions`
- 按钮权限：使用 `v-hasPermi="['materials:record:add']"` 指令
- API 调用：在组件中通过 `@/api/materials/record.js` 调用接口

**后端实现**：

- Controller 方法上使用 `@SaCheckPermission("materials:record:list")` 注解
- Service 层实现业务逻辑
- Mapper 层实现数据访问

## 查询条件配置

### 备案产品管理页面查询条件

| 字段名称 | 查询方式 | 控件类型 | 备注 |
|---------|---------|---------|------|
| 生产企业名称 | 模糊查询 | 输入框 | - |
| 统一社会信用代码 | 精确查询 | 输入框 | - |
| 备案产品名称 | 模糊查询 | 输入框 | - |
| 备案证号 | 模糊查询 | 输入框 | - |
| 备案证状态 | 字典查询 | 下拉选择 | 使用certificate_status字典 |

## 技术实现

- 后端：使用Spring Boot + MyBatis-Plus + Sa-Token
- 前端：使用Vue 3 + Element Plus + Axios
- 理由：与现有技术栈保持一致，减少学习成本

## 后端代码实现规范

### Controller层

```java
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/materials/record")
public class MatRecordController extends BaseController {

    private final IMatRecordService matRecordService;

    @SaCheckPermission("materials:record:list")
    @GetMapping("/list")
    public TableDataInfo<MatRecord> list(MatRecord matRecord, PageQuery pageQuery) {
        return matRecordService.selectMatRecordPageList(matRecord, pageQuery);
    }

    @SaCheckPermission("materials:record:query")
    @PostMapping("/export")
    public void export(MatRecord matRecord, HttpServletResponse response) {
        List<MatRecord> list;
        if (matRecord.getIds() != null && !matRecord.getIds().isEmpty()) {
            list = matRecordService.selectMatRecordByIds(matRecord.getIds());
        } else {
            list = matRecordService.selectMatRecordList(matRecord);
        }
        List<MatRecordExcelVO> excelVOList = list.stream().map(record -> {
            MatRecordExcelVO vo = new MatRecordExcelVO();
            vo.setId(record.getId());
            vo.setEnterpriseName(record.getEnterpriseName());
            return vo;
        }).collect(java.util.stream.Collectors.toList());
        ExcelUtil.exportExcel(excelVOList, "备案产品数据", MatRecordExcelVO.class, response);
    }

    @SaCheckPermission("materials:record:query")
    @GetMapping(value = "/{id}")
    public R<MatRecord> getInfo(@PathVariable("id") Long id) {
        return R.ok(matRecordService.selectMatRecordById(id));
    }

    @SaCheckPermission("materials:record:add")
    @PostMapping
    public R<Void> add(@Validated(AddGroup.class) @RequestBody MatRecord matRecord) {
        return toAjax(matRecordService.insertMatRecord(matRecord));
    }

    @SaCheckPermission("materials:record:edit")
    @PutMapping
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody MatRecord matRecord) {
        return toAjax(matRecordService.updateMatRecord(matRecord));
    }

    @SaCheckPermission("materials:record:remove")
    @DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toAjax(matRecordService.deleteMatRecordByIds(Arrays.asList(ids)));
    }
}
```

### Service层

```java
@RequiredArgsConstructor
@Service
public class MatRecordServiceImpl implements IMatRecordService {

    private final MatRecordMapper baseMapper;

    @Override
    public TableDataInfo<MatRecord> selectMatRecordPageList(MatRecord matRecord, PageQuery pageQuery) {
        Page<MatRecord> page = baseMapper.selectPage(pageQuery.build(), buildQueryWrapper(matRecord));
        return TableDataInfo.build(page);
    }

    @Override
    public List<MatRecord> selectMatRecordList(MatRecord matRecord) {
        return baseMapper.selectMatRecordList(matRecord);
    }

    @Override
    public List<MatRecord> selectMatRecordByIds(List<Long> ids) {
        return baseMapper.selectBatchIds(ids);
    }

    private LambdaQueryWrapper<MatRecord> buildQueryWrapper(MatRecord matRecord) {
        LambdaQueryWrapper<MatRecord> lqw = new LambdaQueryWrapper<>();
        lqw.eq(MatRecord::getDelFlag, "0");
        if (matRecord.getTenantId() != null && !matRecord.getTenantId().isEmpty()) {
            lqw.eq(MatRecord::getTenantId, matRecord.getTenantId());
        }
        if (matRecord.getEnterpriseName() != null && !matRecord.getEnterpriseName().isEmpty()) {
            lqw.like(MatRecord::getEnterpriseName, matRecord.getEnterpriseName());
        }
        lqw.orderByDesc(MatRecord::getCreateTime);
        return lqw;
    }
}
```

### Entity层

```java
@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@TableName("mat_record")
public class MatRecord extends TenantEntity {

    @TableId(value = "id")
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

    @TableLogic
    private String delFlag;

    @TableField(exist = false)
    private List<Long> ids;
}
```

### Excel导出VO

```java
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
```

## 前端代码实现规范

### 页面结构

```vue
<template>
  <div class="app-container">
    <div v-show="showSearch" class="search-con">
      <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="140px">
        <el-form-item label="字段名称" prop="fieldName">
          <el-input v-model="queryParams.fieldName" placeholder="请输入字段名称" clearable style="width: 240px" @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="main-con" v-autoHeight="showSearch">
      <div class="operate-btn-con">
        <div class="handler">
          <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['materials:record:add']">新增</el-button>
          <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['materials:record:remove']">删除</el-button>
          <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['materials:record:query']">导出</el-button>
        </div>
        <right-toolbar :showSearch="showSearch" @update:showSearch="showSearch = $event" @queryTable="getList" :columns="columns"></right-toolbar>
      </div>
      <div class="content-con">
        <el-table v-loading="loading" :data="recordList" @selection-change="handleSelectionChange" height="calc(100% - 0.52rem)">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="字段名称" align="center" key="fieldName" prop="fieldName" v-if="columns[0].visible" />
          <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
            <template #default="scope">
              <el-tooltip content="修改" placement="top">
                <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['materials:record:edit']"></el-button>
              </el-tooltip>
              <el-tooltip content="删除" placement="top">
                <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['materials:record:remove']"></el-button>
              </el-tooltip>
            </template>
          </el-table-column>
        </el-table>
        <pagination
          v-show="total > 0"
          :total="total"
          :page="queryParams.pageNum"
          :limit="queryParams.pageSize"
          @update:page="queryParams.pageNum = $event"
          @update:limit="queryParams.pageSize = $event"
          @pagination="getList"
        />
      </div>
    </div>

    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="recordRef" :model="form" :rules="rules" label-width="140px">
        <el-form-item label="字段名称" prop="fieldName">
          <el-input v-model="form.fieldName" placeholder="请输入字段名称" maxlength="255" clearable />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { listRecord, getRecord, delRecord, addRecord, updateRecord, exportRecord } from '@/api/materials/record'

const { proxy } = getCurrentInstance()
const { certificate_status } = proxy.useDict('certificate_status')

const recordList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const multiple = ref(true)
const total = ref(0)
const title = ref('')

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    fieldName: undefined
  },
  rules: {
    fieldName: [{ required: true, message: '字段名称不能为空', trigger: 'change' }]
  },
  columns: [
    { key: 0, label: '字段名称', visible: true }
  ]
})

const { queryParams, form, rules, columns } = toRefs(data)

function getList() {
  loading.value = true
  listRecord(queryParams.value).then((response) => {
    recordList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map((item) => item.id)
  multiple.value = !selection.length
}

function handleAdd() {
  reset()
  open.value = true
  title.value = '添加备案产品'
}

function handleUpdate(row) {
  reset()
  const id = row.id
  getRecord(id).then((response) => {
    form.value = response.data
    open.value = true
    title.value = '修改备案产品'
  })
}

function submitForm() {
  proxy.$refs.recordRef.validate((valid) => {
    if (valid) {
      if (form.value.id !== undefined) {
        updateRecord(form.value).then(() => {
          proxy.$modal.msgSuccess('修改成功')
          open.value = false
          getList()
        })
      } else {
        addRecord(form.value).then(() => {
          proxy.$modal.msgSuccess('新增成功')
          open.value = false
          getList()
        })
      }
    }
  })
}

function handleDelete(row) {
  const recordIds = row.id || ids.value
  proxy.$modal
    .confirm('是否确认删除备案产品编号为"' + recordIds + '"的数据项？')
    .then(() => {
      return delRecord(recordIds)
    })
    .then(() => {
      getList()
      proxy.$modal.msgSuccess('删除成功')
    })
    .catch(() => {})
}

const handleExport = () => {
  proxy.download('materials/record/export', { ...queryParams.value, ids: ids.value }, `record_${new Date().getTime()}.xlsx`)
}

function cancel() {
  open.value = false
  reset()
}

function reset() {
  form.value = {
    id: undefined,
    fieldName: undefined
  }
  proxy.resetForm('recordRef')
}

getList()
</script>
```

### 前端实现要点

1. **字典使用**：使用 `proxy.useDict('certificate_status')` 调用字典
2. **文件下载**：使用 `proxy.download('materials/record/export', { ...queryParams.value, ids: ids.value }, filename)` 下载文件
3. **表单 label-width**：根据最长文本计算（字数*20，最小120px）
4. **输入框**：所有输入框都添加 `clearable` 属性
5. **批量操作**：只保留批量删除，不保留批量修改
6. **导出功能**：传递 `ids` 参数，支持选择部分数据导出
7. **日期范围选择器**：使用 `el-date-picker type="daterange"`

## 字典配置

### 备案证状态字典配置

**字典类型配置**（在系统管理-字典管理中配置）：

| 字段名 | 字段值 | 说明 |
|-------|-------|------|
| dict_name | 备案证状态 | 字典名称 |
| dict_type | certificate_status | 字典类型编码 |

**字典数据配置**（在系统管理-字典管理中配置）：

| 字典标签 | 字典值 | 样式类 | 是否默认 | 排序 |
|---------|-------|--------|---------|------|
| 未过期 | 0 | success | Y | 1 |
| 已过期 | 1 | danger | N | 2 |

## Risks / Trade-offs

1. **Risk**: 数据验证规则可能不够完善
   - Mitigation: 前端和后端双重验证，确保数据合法性

2. **Risk**: 前端页面样式与现有系统不一致
   - Mitigation: 使用标准前端页面模板（templates/frontend-page-template.md）生成代码，确保样式和功能与现有系统保持一致

3. **Risk**: 后端代码风格与现有系统不一致
   - Mitigation: 使用标准后端代码模板（templates/backend-code-template.md）生成代码，确保代码风格和架构与现有系统保持一致
