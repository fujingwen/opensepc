# 前端页面模板

## 标准增删改查页面模板

基于Vue 3 + Element Plus的标准增删改查页面模板，确保与现有系统保持一致的样式和功能。

## 文件结构

创建新页面时需要创建以下文件：

```
src/
├── views/
│   └── module/
│       └── resource/
│           └── index.vue          # 页面组件
└── api/
    └── module/
        └── resource.js           # API接口文件
```

## 1. 页面组件模板 (index.vue)

**重要提示**：搜索区域的查询条件必须严格按照设计文档实现，包括：

1. 查询条件字段必须与设计文档完全一致
2. 查询条件顺序必须与设计文档一致
3. 查询方式（input/select/date range）必须与设计文档一致
4. 字典查询必须使用对应的字典类型
5. 范围查询（如采购数量、时间范围）需要在前端转换为对应的 Min/Max 字段

```vue
<template>
  <div class="app-container">
    <!-- 搜索区域 -->
    <div v-show="showSearch" class="search-con">
      <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="120px">
        <el-form-item label="字段1" prop="field1">
          <el-input v-model="queryParams.field1" placeholder="请输入字段1" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="字段2" prop="field2">
          <el-input v-model="queryParams.field2" placeholder="请输入字段2" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
            <el-option v-for="dict in dict_type" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 主内容区域 -->
    <div class="main-con" v-autoHeight="showSearch">
      <!-- 操作按钮区域 -->
      <div class="operate-btn-con">
        <div class="handler">
          <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['module:resource:add']">新增</el-button>
          <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['module:resource:remove']">删除</el-button>
          <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['module:resource:query']">导出</el-button>
        </div>
        <right-toolbar :showSearch="showSearch" @update:showSearch="showSearch = $event" @queryTable="getList" :columns="columns"></right-toolbar>
      </div>

      <!-- 数据表格区域 -->
      <div class="content-con">
        <el-table v-loading="loading" :data="resourceList" @selection-change="handleSelectionChange" height="calc(100% - 0.52rem)">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="ID" align="center" key="id" prop="id" v-if="columns[0].visible" />
          <el-table-column label="字段1" align="center" key="field1" prop="field1" v-if="columns[1].visible" :show-overflow-tooltip="true" />
          <el-table-column label="字段2" align="center" key="field2" prop="field2" v-if="columns[2].visible" :show-overflow-tooltip="true" />
          <el-table-column label="状态" align="center" key="status" v-if="columns[3].visible" width="100">
            <template #default="scope">
              <dict-tag :options="dict_type" :value="scope.row.status" />
            </template>
          </el-table-column>
          <el-table-column label="创建时间" align="center" key="createTime" prop="createTime" v-if="columns[4].visible" width="160" />
          <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
            <template #default="scope">
              <el-tooltip content="修改" placement="top">
                <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['module:resource:edit']"></el-button>
              </el-tooltip>
              <el-tooltip content="删除" placement="top">
                <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['module:resource:remove']"></el-button>
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

    <!-- 添加或修改对话框 -->
    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="resourceRef" :model="form" :rules="rules" label-width="140px">
        <el-form-item label="字段1" prop="field1">
          <el-input v-model="form.field1" placeholder="请输入字段1" maxlength="255" clearable />
        </el-form-item>
        <el-form-item label="字段2" prop="field2">
          <el-input v-model="form.field2" placeholder="请输入字段2" maxlength="255" clearable />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio v-for="dict in dict_type" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
          </el-radio-group>
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
import { listResource, getResource, delResource, addResource, updateResource, exportResource } from '@/api/module/resource'

const { proxy } = getCurrentInstance()
const { dict_type } = proxy.useDict('dict_type')

const resourceList = ref([])
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
    field1: undefined,
    field2: undefined,
    status: undefined
  },
  rules: {
    field1: [{ required: true, message: '字段1不能为空', trigger: 'change' }],
    field2: [{ required: true, message: '字段2不能为空', trigger: 'change' }]
  },
  columns: [
    { key: 0, label: 'ID', visible: false },
    { key: 1, label: '字段1', visible: true },
    { key: 2, label: '字段2', visible: true },
    { key: 3, label: '状态', visible: true },
    { key: 4, label: '创建时间', visible: true }
  ]
})

const { queryParams, form, rules, columns } = toRefs(data)

function getList() {
  loading.value = true
  listResource(queryParams.value).then((response) => {
    resourceList.value = response.rows
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
  title.value = '添加资源'
}

function handleUpdate(row) {
  reset()
  const id = row.id
  getResource(id).then((response) => {
    form.value = response.data
    open.value = true
    title.value = '修改资源'
  })
}

function submitForm() {
  proxy.$refs.resourceRef.validate((valid) => {
    if (valid) {
      if (form.value.id !== undefined) {
        updateResource(form.value).then(() => {
          proxy.$modal.msgSuccess('修改成功')
          open.value = false
          getList()
        })
      } else {
        addResource(form.value).then(() => {
          proxy.$modal.msgSuccess('新增成功')
          open.value = false
          getList()
        })
      }
    }
  })
}

function handleDelete(row) {
  const resourceIds = row.id || ids.value
  proxy.$modal
    .confirm('是否确认删除资源编号为"' + resourceIds + '"的数据项？')
    .then(() => {
      return delResource(resourceIds)
    })
    .then(() => {
      getList()
      proxy.$modal.msgSuccess('删除成功')
    })
    .catch(() => {})
}

const handleExport = () => {
  proxy.download('module/resource/export', { ...queryParams.value, ids: ids.value }, `resource_${new Date().getTime()}.xlsx`)
}

function cancel() {
  open.value = false
  reset()
}

function reset() {
  form.value = {
    id: undefined,
    field1: undefined,
    field2: undefined,
    status: '0'
  }
  proxy.resetForm('resourceRef')
}

getList()
</script>
```

## 2. API接口模板 (resource.js)

```javascript
import request from '@/utils/request'

export function listResource(query) {
  return request({
    url: '/module/resource/list',
    method: 'get',
    params: query
  })
}

export function getResource(id) {
  return request({
    url: '/module/resource/' + id,
    method: 'get'
  })
}

export function addResource(data) {
  return request({
    url: '/module/resource',
    method: 'post',
    data: data
  })
}

export function updateResource(data) {
  return request({
    url: '/module/resource',
    method: 'put',
    data: data
  })
}

export function delResource(ids) {
  return request({
    url: '/module/resource/' + ids,
    method: 'delete'
  })
}

export function exportResource(query) {
  return request({
    url: '/module/resource/export',
    method: 'post',
    data: query
  })
}
```

## 模板规范

### 1. 组件使用规范

- **表单组件**：`el-form`、`el-form-item`
- **输入组件**：`el-input`、`el-select`、`el-radio-group`
- **表格组件**：`el-table`、`el-table-column`
- **按钮组件**：`el-button`（使用icon属性添加图标）
- **对话框组件**：`el-dialog`
- **分页组件**：`Pagination`（全局组件）
- **字典标签**：`dict-tag`（全局组件）
- **工具栏**：`right-toolbar`（全局组件）

### 2. 样式规范

- **外层容器**：`class="app-container"`
- **搜索区域**：`class="search-con"`
- **主内容区域**：`class="main-con"`，使用`v-autoHeight`指令
- **操作按钮区域**：`class="operate-btn-con"`
- **内容区域**：`class="content-con"`

### 2.1 查询条件规范

- **严格按照提案设计的查询条件生成代码**
- **查询条件顺序**：必须按照提案中列出的顺序排列，不得随意调整
- **查询条件类型**：
  - 模糊查询：使用 `el-input` 组件，添加 `clearable` 和 `@keyup.enter="handleQuery"` 属性
  - 下拉选择（字典）：使用 `el-select` 组件，添加 `clearable` 属性，使用 `dict-tag` 显示选项
  - 下拉选择（非字典）：使用 `el-select` 组件，添加 `clearable` 属性，数据来源需确认
- **查询条件示例**：

  ```vue
  <!-- 模糊查询 -->
  <el-form-item label="工程名称" prop="projectName">
    <el-input v-model="queryParams.projectName" placeholder="请输入工程名称" clearable @keyup.enter="handleQuery" />
  </el-form-item>

  <!-- 下拉选择（字典） -->
  <el-form-item label="工程进度" prop="projectProgress">
    <el-select v-model="queryParams.projectProgress" placeholder="请选择工程进度" clearable>
      <el-option v-for="dict in project_progress" :key="dict.value" :label="dict.label" :value="dict.value" />
    </el-select>
  </el-form-item>

  <!-- 下拉选择（非字典） -->
  <el-form-item label="质量监督机构" prop="qualitySupervisionAgency">
    <el-select v-model="queryParams.qualitySupervisionAgency" placeholder="请选择质量监督机构" clearable>
      <el-option v-for="dict in quality_supervision_agency" :key="dict.value" :label="dict.label" :value="dict.value" />
    </el-select>
  </el-form-item>
  ```

- **字典数据加载**：必须在 `useDict` 中添加所有使用的字典类型

  ```javascript
  const { project_progress, project_nature, has_report, is_integrated, quality_supervision_agency } = proxy.useDict(
    'project_progress',
    'project_nature',
    'has_report',
    'is_integrated',
    'quality_supervision_agency'
  )
  ```

### 2.2 列表展示字段规范

- **严格按照提案设计的列表展示字段生成代码**
- **字段顺序**：必须按照提案中列出的顺序排列，不得随意调整
- **字段标签**：必须使用提案中指定的字段标签名称，不得随意修改
- **列表展示字段示例**：

  ```vue
  <el-table v-loading="loading" :data="resourceList" @selection-change="handleSelectionChange" height="calc(100% - 0.52rem)">
    <el-table-column type="selection" width="50" align="center" />
    <el-table-column type="index" label="序号" align="center" width="60" />
    <el-table-column label="工程名称" align="center" key="projectName" prop="projectName" :show-overflow-tooltip="true" />
    <el-table-column label="施工许可证" align="center" key="constructionPermit" prop="constructionPermit" :show-overflow-tooltip="true" />
    <el-table-column label="工程进度" align="center" key="projectProgress">
      <template #default="scope">
        <dict-tag :options="project_progress" :value="scope.row.projectProgress" />
      </template>
    </el-table-column>
    <el-table-column label="施工单位" align="center" key="constructionUnit" prop="constructionUnit" :show-overflow-tooltip="true" />
    <el-table-column label="有无填报" align="center" key="hasReport">
      <template #default="scope">
        <dict-tag :options="has_report" :value="scope.row.hasReport" />
      </template>
    </el-table-column>
    <el-table-column label="对接一体化平台编码" align="center" key="isIntegrated">
      <template #default="scope">
        <dict-tag :options="is_integrated" :value="scope.row.isIntegrated" />
      </template>
    </el-table-column>
    <el-table-column label="创建时间" align="center" key="createTime" prop="createTime" width="160" />
    <el-table-column label="操作" align="center" width="180" fixed="right" class-name="small-padding fixed-width">
      <template #default="scope">
        <el-tooltip content="查看" placement="top">
          <el-button link type="primary" icon="View" @click="handleView(scope.row)" v-hasPermi="['module:resource:query']"></el-button>
        </el-tooltip>
        <el-tooltip content="修改" placement="top">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['module:resource:edit']"></el-button>
        </el-tooltip>
        <el-tooltip content="删除" placement="top">
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['module:resource:remove']"></el-button>
        </el-tooltip>
      </template>
    </el-table-column>
  </el-table>
  ```

### 3. 表单 label-width 规范

- **计算规则**：根据最长文本计算（字数*20，最小120px）
- **示例**：
  - 最长文本为"统一社会信用代码"（7个字）→ label-width = 7*20 = 140px
  - 最长文本为"状态"（2个字）→ label-width = 120px（最小值）

### 4. 输入框规范

- **所有输入框都添加 `clearable` 属性**
- **输入框宽度**：搜索区域输入框固定宽度为 240px，对话框输入框默认宽度

### 5. 权限控制

- **按钮权限**：使用`v-hasPermi`指令，例如：`v-hasPermi="['module:resource:add']"`
- **权限标识格式**：`模块:页面:操作`
- **权限标识示例**：
  - 页面权限：`module:resource:list`
  - 查询权限：`module:resource:query`
  - 新增权限：`module:resource:add`
  - 修改权限：`module:resource:edit`
  - 删除权限：`module:resource:remove`

### 6. 字典使用

- **字典调用**：`const { dict_type } = proxy.useDict('dict_type')`
- **字典标签**：`<dict-tag :options="dict_type" :value="scope.row.status" />`
- **字典选择**：`<el-select v-model="queryParams.status" placeholder="请选择状态" clearable>`

  ```vue
  <el-option v-for="dict in dict_type" :key="dict.value" :label="dict.label" :value="dict.value" />
  ```

### 7. 批量操作规范

- **只保留批量删除**，不保留批量修改
- **批量删除按钮**：`<el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete">删除</el-button>`
- **多选框**：`<el-table-column type="selection" width="50" align="center" />`
- **多选事件**：`@selection-change="handleSelectionChange"`

### 8. 导出功能规范

- **导出按钮**：`<el-button type="warning" plain icon="Download" @click="handleExport">导出</el-button>`
- **导出方法**：

  ```javascript
  const handleExport = () => {
    proxy.download('module/resource/export', { ...queryParams.value, ids: ids.value }, `resource_${new Date().getTime()}.xlsx`)
  }
  ```

- **支持选择部分数据导出**：传递 `ids` 参数

### 9. 日期范围选择器规范

- **使用 `el-date-picker` 的 `daterange` 类型**
- **示例**：

  ```vue
  <el-form-item label="有效期" prop="validityRange">
    <el-date-picker
      v-model="validityRange"
      type="daterange"
      range-separator="至"
      start-placeholder="开始日期"
      end-placeholder="结束日期"
      value-format="YYYY-MM-DD"
      style="width: 100%"
      @change="handleValidityChange"
    />
  </el-form-item>
  ```

- **数据处理**：

  ```javascript
  const data = reactive({
    form: {},
    validityRange: []
  })
  
  function handleValidityChange(val) {
    if (val && val.length === 2) {
      form.value.startValidity = val[0]
      form.value.endValidity = val[1]
    } else {
      form.value.startValidity = undefined
      form.value.endValidity = undefined
    }
  }
  ```

### 10. API调用

```javascript
import { listResource, getResource, delResource, addResource, updateResource, exportResource } from '@/api/module/resource'
```

### 11. 响应式数据

```javascript
const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    field1: undefined,
    field2: undefined,
    status: undefined
  },
  rules: {
    field1: [{ required: true, message: '字段1不能为空', trigger: 'change' }],
    field2: [{ required: true, message: '字段2不能为空', trigger: 'change' }]
  },
  columns: [
    { key: 0, label: 'ID', visible: false },
    { key: 1, label: '字段1', visible: true },
    { key: 2, label: '字段2', visible: true },
    { key: 3, label: '状态', visible: true },
    { key: 4, label: '创建时间', visible: true }
  ]
})

const { queryParams, form, rules, columns } = toRefs(data)
```

### 12. 标准方法

- `getList()`：查询列表
- `handleQuery()`：搜索
- `resetQuery()`：重置
- `handleAdd()`：新增
- `handleUpdate()`：修改
- `handleDelete()`：删除
- `submitForm()`：提交表单
- `cancel()`：取消
- `reset()`：表单重置
- `handleSelectionChange()`：多选框选中数据
- `handleExport()`：导出

### 13. 图标使用

- 搜索：`Search`
- 重置：`Refresh`
- 新增：`Plus`
- 修改：`Edit`
- 删除：`Delete`
- 导出：`Download`

### 14. 消息提示

- **成功提示**：`proxy.$modal.msgSuccess('操作成功')`
- **确认提示**：`proxy.$modal.confirm('是否确认删除？')`

### 15. 表格列配置

- **使用 `columns` 数组控制列的显示/隐藏**
- **每列配置**：

  ```javascript
  { key: 0, label: 'ID', visible: false }
  ```

- **表格列使用**：

  ```vue
  <el-table-column label="字段1" align="center" key="field1" prop="field1" v-if="columns[1].visible" :show-overflow-tooltip="true" />
  ```

### 16. 表格操作列

- **使用 `el-tooltip` 包裹按钮，显示提示文字**
- **示例**：

  ```vue
  <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
    <template #default="scope">
      <el-tooltip content="修改" placement="top">
        <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"></el-button>
      </el-tooltip>
      <el-tooltip content="删除" placement="top">
        <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"></el-button>
      </el-tooltip>
    </template>
  </el-table-column>
  ```

### 17. 分页组件

- **使用全局组件 `Pagination`**
- **示例**：

  ```vue
  <pagination
    v-show="total > 0"
    :total="total"
    :page="queryParams.pageNum"
    :limit="queryParams.pageSize"
    @update:page="queryParams.pageNum = $event"
    @update:limit="queryParams.pageSize = $event"
    @pagination="getList"
  />
  ```

### 18. 对话框组件

- **使用 `el-dialog` 组件**
- **示例**：

  ```vue
  <el-dialog :title="title" v-model="open" width="600px" append-to-body>
    <el-form ref="resourceRef" :model="form" :rules="rules" label-width="140px">
      <!-- 表单项 -->
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </template>
  </el-dialog>
  ```

### 19. 工具栏组件

- **使用全局组件 `right-toolbar`**
- **示例**：

  ```vue
  <right-toolbar :showSearch="showSearch" @update:showSearch="showSearch = $event" @queryTable="getList" :columns="columns"></right-toolbar>
  ```

- **注意**：使用 `@update:showSearch` 事件，而不是 `v-model:showSearch`

### 20. 按钮规范

- **只保留批量删除**，不保留批量修改
- **导出按钮权限**：使用 `query` 权限标识

### 21. API接口规范

- **不使用 `parseStrEmpty` 工具函数**
- **不导出 `default` 对象**
- **导出方法使用 `data` 参数**

### 22. 代码规范

- **使用 `function` 关键字定义方法**，不使用箭头函数
- **使用 `reactive` 和 `toRefs` 管理响应式数据**
- **使用 `undefined` 而不是 `null`**
- **移除 `onMounted` 生命周期钩子中的字典加载**
- **移除 `single` 变量**（批量修改按钮已移除）
