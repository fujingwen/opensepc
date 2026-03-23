# 前端树形页面模板

## 树形结构增删改查页面模板

基于Vue 3 + Element Plus的树形结构增删改查页面模板，适用于行政区划、组织架构等需要层级关系的场景。

## 文件结构

```
src/
├── views/
│   └── module/
│       └── region/
│           └── index.vue          # 页面组件
└── api/
    └── module/
        └── region.js           # API接口文件
```

## 1. 页面组件模板 (index.vue)

```vue
<template>
  <div class="app-container">
    <!-- 搜索区域 -->
    <div v-show="showSearch" class="search-con">
      <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="120px">
        <el-form-item label="行政区划名称" prop="fullName">
          <el-input v-model="queryParams.fullName" placeholder="请输入行政区划名称" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="行政区划编码" prop="enCode">
          <el-input v-model="queryParams.enCode" placeholder="请输入行政区划编码" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="状态" prop="enabledMark">
          <el-select v-model="queryParams.enabledMark" placeholder="请选择状态" clearable>
            <el-option v-for="dict in sys_region_status" :key="dict.value" :label="dict.label" :value="dict.value" />
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
          <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['module:region:add']">新增</el-button>
          <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['module:region:remove']">删除</el-button>
        </div>
        <right-toolbar :showSearch="showSearch" @update:showSearch="showSearch = $event" @queryTable="getList" :columns="columns"></right-toolbar>
      </div>

      <!-- 数据表格区域 -->
      <div class="content-con">
        <el-table
          v-loading="loading"
          :data="regionList"
          row-key="id"
          :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
          lazy
          :load="loadChildren"
          @selection-change="handleSelectionChange"
          height="calc(100% - 0.52rem)"
        >
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column type="index" label="序号" align="center" width="60" />
          <el-table-column label="行政区划名称" align="left" key="fullName" prop="fullName" v-if="columns[1].visible" :show-overflow-tooltip="true" />
          <el-table-column label="行政区划编码" align="center" key="enCode" prop="enCode" v-if="columns[0].visible" :show-overflow-tooltip="true" />
          <el-table-column label="排序" align="center" key="sortCode" prop="sortCode" v-if="columns[3].visible" width="100" />
          <el-table-column label="状态" align="center" key="enabledMark" v-if="columns[4].visible" width="100">
            <template #default="scope">
              <dict-tag :options="sys_region_status" :value="scope.row.enabledMark" />
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
            <template #default="scope">
              <el-tooltip content="修改" placement="top">
                <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['module:region:edit']"></el-button>
              </el-tooltip>
              <el-tooltip content="删除" placement="top">
                <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['module:region:remove']"></el-button>
              </el-tooltip>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>

    <!-- 添加或修改对话框 -->
    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="regionRef" :model="form" :rules="rules" label-width="140px">
        <el-form-item label="上级区划" prop="parentId">
          <el-tree-select
            v-model="form.parentId"
            :data="regionOptions"
            :props="{ value: 'id', label: 'fullName', children: 'children', lazy: true, hasChildren: 'hasChildren' }"
            value-key="id"
            placeholder="选择上级区划"
            check-strictly
            lazy
            :load="loadRegionOptions"
          >
            <template #default="{ node, data }">
              <span v-if="data.id === '-1'" style="color: #409eff">顶级节点</span>
              <span v-else>{{ data.fullName }}</span>
            </template>
          </el-tree-select>
        </el-form-item>
        <el-form-item label="行政区划编码" prop="enCode">
          <el-input v-model="form.enCode" placeholder="请输入行政区划编码" maxlength="50" clearable />
        </el-form-item>
        <el-form-item label="行政区划名称" prop="fullName">
          <el-input v-model="form.fullName" placeholder="请输入行政区划名称" maxlength="100" clearable />
        </el-form-item>
        <el-form-item label="显示排序" prop="sortCode">
          <el-input-number v-model="form.sortCode" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="enabledMark">
          <el-switch v-model="form.enabledMark" :active-value="1" :inactive-value="0" />
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
import { listRegion, getRegion, delRegion, addRegion, updateRegion } from '@/api/module/region'

const { proxy } = getCurrentInstance()
const { sys_region_status } = proxy.useDict('sys_region_status')

const regionList = ref([])
const regionOptions = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const multiple = ref(true)
const title = ref('')

const data = reactive({
  form: {},
  queryParams: {
    fullName: undefined,
    enCode: undefined,
    enabledMark: undefined
  },
  rules: {
    enCode: [{ required: true, message: '行政区划编码不能为空', trigger: 'change' }],
    fullName: [{ required: true, message: '行政区划名称不能为空', trigger: 'change' }],
    sortCode: [{ required: true, message: '排序码不能为空', trigger: 'change' }]
  },
  columns: [
    { key: 0, label: '行政区划编码', visible: true },
    { key: 1, label: '行政区划名称', visible: true },
    { key: 2, label: '上级区划', visible: false },
    { key: 3, label: '排序', visible: true },
    { key: 4, label: '状态', visible: true },
    { key: 5, label: '创建时间', visible: false }
  ]
})

const { queryParams, form, rules, columns } = toRefs(data)

function getList() {
  loading.value = true
  listRegion(queryParams.value).then((response) => {
    regionList.value = response.data
    loading.value = false
  })
}

/**
 * 懒加载子节点
 */
function loadChildren(row, treeNode, resolve) {
  listRegion({ parentId: row.id }).then((response) => {
    resolve(response.data)
  })
}

function handleQuery() {
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
  getRegionOptions()
  open.value = true
  title.value = '添加行政区划'
}

function handleUpdate(row) {
  reset()
  const id = row.id
  getRegion(id).then((response) => {
    form.value = response.data
    getRegionOptions()
    open.value = true
    title.value = '修改行政区划'
  })
}

function submitForm() {
  proxy.$refs.regionRef.validate((valid) => {
    if (valid) {
      if (form.value.id !== undefined) {
        updateRegion(form.value).then(() => {
          proxy.$modal.msgSuccess('修改成功')
          open.value = false
          getList()
        })
      } else {
        addRegion(form.value).then(() => {
          proxy.$modal.msgSuccess('新增成功')
          open.value = false
          getList()
        })
      }
    }
  })
}

function handleDelete(row) {
  const regionIds = row.id || ids.value
  proxy.$modal
    .confirm('是否确认删除行政区划编号为"' + regionIds + '"的数据项？')
    .then(() => {
      return delRegion(regionIds)
    })
    .then(() => {
      getList()
      proxy.$modal.msgSuccess('删除成功')
    })
    .catch(() => {})
}

function cancel() {
  open.value = false
  reset()
}

function reset() {
  form.value = {
    id: undefined,
    parentId: '-1',
    enCode: undefined,
    fullName: undefined,
    sortCode: 0,
    enabledMark: 1
  }
  proxy.resetForm('regionRef')
}

/**
 * 获取树形选择器数据
 */
function getRegionOptions() {
  listRegion().then((response) => {
    const topNode = {
      id: '-1',
      fullName: '顶级节点',
      children: response.data
    }
    regionOptions.value = [topNode]
  })
}

/**
 * 懒加载树形选择器子节点
 */
function loadRegionOptions(node, resolve) {
  if (node.data.id === '-1') {
    resolve(node.data.children)
  } else {
    listRegion({ parentId: node.data.id }).then((response) => {
      resolve(response.data)
    })
  }
}

getList()
</script>
```

## 2. API接口模板 (region.js)

```javascript
import request from '@/utils/request'

export function listRegion(query) {
  return request({
    url: '/module/region/list',
    method: 'get',
    params: query
  })
}

export function getRegion(id) {
  return request({
    url: '/module/region/' + id,
    method: 'get'
  })
}

export function addRegion(data) {
  return request({
    url: '/module/region',
    method: 'post',
    data: data
  })
}

export function updateRegion(data) {
  return request({
    url: '/module/region',
    method: 'put',
    data: data
  })
}

export function delRegion(ids) {
  return request({
    url: '/module/region/' + ids,
    method: 'delete'
  })
}
```

## 模板规范

### 1. 树形表格配置

- **行key**：`row-key="id"`
- **树形属性**：

  ```vue
  :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
  ```

- **懒加载**：

  ```vue
  lazy
  :load="loadChildren"
  ```

### 2. 懒加载方法

```javascript
function loadChildren(row, treeNode, resolve) {
  listRegion({ parentId: row.id }).then((response) => {
    resolve(response.data)
  })
}
```

### 3. 树形选择器配置

```vue
<el-tree-select
  v-model="form.parentId"
  :data="regionOptions"
  :props="{ value: 'id', label: 'fullName', children: 'children', lazy: true, hasChildren: 'hasChildren' }"
  value-key="id"
  placeholder="选择上级区划"
  check-strictly
  lazy
  :load="loadRegionOptions"
>
```

### 4. 树形选择器数据处理

```javascript
function getRegionOptions() {
  listRegion().then((response) => {
    const topNode = {
      id: '-1',
      fullName: '顶级节点',
      children: response.data
    }
    regionOptions.value = [topNode]
  })
}

function loadRegionOptions(node, resolve) {
  if (node.data.id === '-1') {
    resolve(node.data.children)
  } else {
    listRegion({ parentId: node.data.id }).then((response) => {
      resolve(response.data)
    })
  }
}
```

### 5. 表单默认值

```javascript
function reset() {
  form.value = {
    id: undefined,
    parentId: '-1',  // 默认为顶级节点
    enCode: undefined,
    fullName: undefined,
    sortCode: 0,
    enabledMark: 1
  }
  proxy.resetForm('regionRef')
}
```

### 6. 响应式数据

```javascript
const data = reactive({
  form: {},
  queryParams: {
    fullName: undefined,
    enCode: undefined,
    enabledMark: undefined
    // 注意：树形查询不需要分页参数
  },
  rules: {
    enCode: [{ required: true, message: '行政区划编码不能为空', trigger: 'change' }],
    fullName: [{ required: true, message: '行政区划名称不能为空', trigger: 'change' }],
    sortCode: [{ required: true, message: '排序码不能为空', trigger: 'change' }]
  },
  columns: [
    { key: 0, label: '行政区划编码', visible: true },
    { key: 1, label: '行政区划名称', visible: true },
    { key: 2, label: '上级区划', visible: false },
    { key: 3, label: '排序', visible: true },
    { key: 4, label: '状态', visible: true },
    { key: 5, label: '创建时间', visible: false }
  ]
})
```

### 7. API返回数据处理

```javascript
function getList() {
  loading.value = true
  listRegion(queryParams.value).then((response) => {
    regionList.value = response.data  // 树形结构直接使用 response.data
    loading.value = false
  })
}
```

### 8. 与扁平表格的主要区别

| 特性 | 扁平表格 | 树形表格 |
|------|----------|----------|
| 分页 | 有（PageQuery） | 无 |
| 表格行 | 普通行 | 使用 `row-key` 和 `tree-props` |
| 懒加载 | 无 | 使用 `lazy` + `:load` |
| 选择器 | `el-select` | `el-tree-select` |
| 数据返回 | `response.rows`, `response.total` | `response.data`（树形结构） |
| 查询参数 | `pageNum`, `pageSize` | 仅业务字段 |

### 9. 删除校验

在删除前需要检查是否存在子节点：

```javascript
function handleDelete(row) {
  const regionIds = row.id || ids.value
  proxy.$modal
    .confirm('是否确认删除行政区划编号为"' + regionIds + '"的数据项？')
    .then(() => {
      return delRegion(regionIds)
    })
    .then(() => {
      getList()
      proxy.$modal.msgSuccess('删除成功')
    })
    .catch(() => {})
}
```

后端会校验是否存在子节点，如果存在则抛出异常。

### 10. 权限控制

- **按钮权限**：使用 `v-hasPermi` 指令
- **权限标识格式**：`模块:页面:操作`

```vue
<el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['module:region:add']">新增</el-button>
<el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['module:region:remove']">删除</el-button>
```

### 11. 组件使用规范

- **表单组件**：`el-form`、`el-form-item`
- **输入组件**：`el-input`、`el-tree-select`、`el-input-number`
- **开关组件**：`el-switch`
- **表格组件**：`el-table`、`el-table-column`（带树形配置）
- **按钮组件**：`el-button`（使用icon属性添加图标）
- **对话框组件**：`el-dialog`
- **字典标签**：`dict-tag`（全局组件）
- **工具栏**：`right-toolbar`（全局组件）

### 12. 样式规范

- **外层容器**：`class="app-container"`
- **搜索区域**：`class="search-con"`
- **主内容区域**：`class="main-con"`，使用`v-autoHeight`指令
- **操作按钮区域**：`class="operate-btn-con"`
- **内容区域**：`class="content-con"`
