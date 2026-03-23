# 前端左右结构页面模板

## 左右结构增删改查页面模板

基于Vue 3 + Element Plus的左右结构页面模板，适用于左侧为分类/部门树，右侧为数据列表的场景。

## 文件结构

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

```vue
<template>
  <div class="app-container">
    <div class="container-flex">
      <!-- 左侧树 -->
      <div class="container-left">
        <el-input v-model="leftName" placeholder="请输入名称" clearable prefix-icon="Search" style="margin-bottom: 20px" />
        <div class="left-tree">
          <el-tree
            ref="leftTreeRef"
            :data="leftList"
            :props="{ label: 'fullName', children: 'children' }"
            :expand-on-click-node="false"
            :filter-node-method="filterNode"
            node-key="id"
            highlight-current
            default-expand-all
            @node-click="handleNodeClick"
          />
        </div>
      </div>

      <!-- 右侧列表 -->
      <div class="container-right">
        <div v-show="showSearch" class="search-con">
          <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="68px">
            <el-form-item label="名称" prop="fullName">
              <el-input v-model="queryParams.fullName" placeholder="请输入名称" clearable @keyup.enter="handleQuery" />
            </el-form-item>
            <el-form-item label="状态" prop="enabledMark">
              <el-select v-model="queryParams.enabledMark" placeholder="请选择状态" clearable>
                <el-option label="正常" :value="1" />
                <el-option label="停用" :value="0" />
              </el-select>
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
              <el-button type="primary" plain icon="Plus" @click="handleAdd">新增</el-button>
              <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete">删除</el-button>
            </div>
            <right-toolbar :showSearch="showSearch" @update:showSearch="showSearch = $event" @queryTable="getList" :columns="columns"></right-toolbar>
          </div>

          <div class="content-con">
            <el-table
              v-loading="loading"
              :data="rightList"
              row-key="id"
              :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
              @selection-change="handleSelectionChange"
              height="calc(100% - 0.52rem)"
            >
              <el-table-column type="selection" width="50" align="center" />
              <el-table-column type="index" label="序号" align="center" width="60" />
              <el-table-column label="名称" align="left" key="fullName" prop="fullName" :show-overflow-tooltip="true" />
              <el-table-column label="编码" align="center" key="enCode" prop="enCode" :show-overflow-tooltip="true" />
              <el-table-column label="排序" align="center" key="sortCode" prop="sortCode" width="100" />
              <el-table-column label="状态" align="center" key="enabledMark" width="100">
                <template #default="scope">
                  <el-tag :type="scope.row.enabledMark === 1 ? 'success' : 'danger'">
                    {{ scope.row.enabledMark === 1 ? '正常' : '停用' }}
                  </el-tag>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </div>
      </div>
    </div>

    <!-- 添加或修改对话框 -->
    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="140px">
        <el-form-item label="上级" prop="parentId">
          <el-input v-model="form.parentName" disabled />
        </el-form-item>
        <el-form-item label="名称" prop="fullName">
          <el-input v-model="form.fullName" placeholder="请输入名称" maxlength="200" clearable />
        </el-form-item>
        <el-form-item label="编码" prop="enCode">
          <el-input v-model="form.enCode" placeholder="请输入编码" maxlength="100" clearable />
        </el-form-item>
        <el-form-item label="排序" prop="sortCode">
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
import { listLeft, listRight, getResource, delResource, addResource, updateResource } from '@/api/module/resource'

const { proxy } = getCurrentInstance()

const leftList = ref([])
const rightList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const leftName = ref('')
const selectedLeftId = ref(null)
const selectedLeft = ref(null)
const ids = ref([])
const multiple = ref(true)
const title = ref('')
const open = ref(false)

const columns = ref([
  { key: 0, label: '名称', visible: true },
  { key: 1, label: '编码', visible: true },
  { key: 2, label: '排序', visible: true },
  { key: 3, label: '状态', visible: true }
])

const data = reactive({
  form: {},
  queryParams: {
    fullName: undefined,
    enabledMark: undefined
  },
  rules: {
    fullName: [{ required: true, message: '名称不能为空', trigger: 'change' }],
    sortCode: [{ required: true, message: '排序不能为空', trigger: 'change' }]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 通过条件过滤节点 */
const filterNode = (value, data) => {
  if (!value) return true
  return data.fullName.indexOf(value) !== -1
}

/** 根据名称筛选左侧树 */
watch(leftName, (val) => {
  proxy.$refs['leftTreeRef'].filter(val)
})

/** 查询左侧树 */
function getLeftList() {
  loading.value = true
  listLeft().then((response) => {
    leftList.value = response.data || []
    loading.value = false
  })
}

/** 查询右侧列表 */
function getList() {
  if (!selectedLeftId.value) {
    rightList.value = []
    return
  }
  loading.value = true
  listRight(selectedLeftId.value, queryParams.value).then((response) => {
    rightList.value = response.data || []
    loading.value = false
  })
}

/** 节点单击事件 */
function handleNodeClick(data) {
  selectedLeftId.value = data.id
  selectedLeft.value = data
  handleQuery()
}

/** 搜索按钮操作 */
function handleQuery() {
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

/** 选择条数 */
function handleSelectionChange(selection) {
  ids.value = selection.map((item) => item.id)
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  if (selectedLeft.value) {
    form.value.parentId = selectedLeft.value.id
    form.value.parentName = selectedLeft.value.fullName
  } else {
    form.value.parentId = '0'
    form.value.parentName = '顶级'
  }
  open.value = true
  title.value = '添加'
}

/** 删除按钮操作 */
function handleDelete(row) {
  const resourceIds = row.id || ids.value
  proxy.$modal
    .confirm('是否确认删除选中的数据项？')
    .then(() => {
      return delResource(resourceIds)
    })
    .then(() => {
      proxy.$modal.msgSuccess('删除成功')
      getList()
    })
    .catch(() => {})
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs.formRef.validate((valid) => {
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

/** 取消按钮 */
function cancel() {
  open.value = false
  reset()
}

/** 重置表单 */
function reset() {
  form.value = {
    id: undefined,
    parentId: '0',
    parentName: undefined,
    fullName: undefined,
    enCode: undefined,
    sortCode: 0,
    enabledMark: 1
  }
  proxy.resetForm('formRef')
}

getLeftList()
</script>

<style scoped>
.container-flex {
  display: flex;
  height: 100%;
}

.container-left {
  width: 280px;
  border-right: 1px solid #e5e5e5;
  padding: 10px;
}

.left-tree {
  height: calc(100% - 60px);
  overflow: auto;
}

.container-right {
  flex: 1;
  display: flex;
  flex-direction: column;
}
</style>
```

## 2. API接口模板 (resource.js)

```javascript
import request from '@/utils/request'

/**
 * 查询左侧树
 */
export function listLeft() {
  return request({
    url: '/module/resource/left/list',
    method: 'get'
  })
}

/**
 * 查询右侧列表
 */
export function listRight(leftId, query) {
  return request({
    url: '/module/resource/right/list/' + leftId,
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
```

## 模板规范

### 1. 布局结构

- **外层容器**：使用 `container-flex` 类实现左右flex布局
- **左侧容器**：`container-left`，固定宽度（如280px），有右边框
- **右侧容器**：`container-right`，flex: 1自适应宽度

```css
.container-flex {
  display: flex;
  height: 100%;
}

.container-left {
  width: 280px;
  border-right: 1px solid #e5e5e5;
  padding: 10px;
}

.left-tree {
  height: calc(100% - 60px);
  overflow: auto;
}

.container-right {
  flex: 1;
  display: flex;
  flex-direction: column;
}
```

### 2. 左侧树配置

- **搜索框**：`el-input` 带 `prefix-icon="Search"`，距底部20px
- **树组件**：`el-tree`，配置 `highlight-current` 高亮当前节点
- **过滤方法**：`filter-node-method`

### 3. 右侧表格配置

- **树形表格**：使用 `row-key` 和 `tree-props`
- **操作按钮**：新增、删除按钮
- **搜索区域**：可折叠，使用 `v-autoHeight`

### 4. 交互逻辑

- **左侧节点点击**：`handleNodeClick`，设置 `selectedLeftId`，调用 `getList`
- **右侧列表查询**：传递 `selectedLeftId` 作为参数
- **新增时**：自动带入左侧选中的节点作为父级

### 5. API设计规范

| 接口 | 说明 |
|------|------|
| `GET /module/resource/left/list` | 查询左侧树数据 |
| `GET /module/resource/right/list/{leftId}` | 根据左侧节点ID查询右侧列表 |

### 6. 响应式数据

```javascript
const leftList = ref([])      // 左侧树数据
const rightList = ref([])     // 右侧列表数据
const selectedLeftId = ref(null)   // 左侧选中的节点ID
const selectedLeft = ref(null)    // 左侧选中的节点数据
```

### 7. 标准方法

- `getLeftList()`：查询左侧树
- `getList()`：查询右侧列表
- `handleNodeClick()`：左侧节点点击事件
- `handleQuery()`：搜索
- `resetQuery()`：重置
- `handleAdd()`：新增
- `handleUpdate()`：修改
- `handleDelete()`：删除
- `submitForm()`：提交表单
- `cancel()`：取消
- `reset()`：表单重置

### 8. 与标准模板的区别

| 特性 | 标准模板 | 左右结构模板 |
|------|----------|--------------|
| 布局 | 单列表格 | 左侧树 + 右侧表格 |
| 左侧数据 | 无 | 独立接口获取 |
| 右侧关联 | 无 | 依赖左侧选中节点 |
| 搜索 | 全局搜索 | 右侧表格搜索 |
| 新增 | 无默认值 | 自动带入父级节点 |
