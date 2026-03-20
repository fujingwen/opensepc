# Frontend Development Specification

## ADDED Requirements

### Requirement: API调用封装

系统 SHALL 应使用统一的API调用封装。

#### Scenario: 使用request.js封装

- **WHEN** 调用后端API
- **THEN** 应使用 `src/utils/request.js` 封装的请求方法
- **THEN** 禁止直接使用 axios

#### Scenario: 请求方法

- **WHEN** 调用API
- **THEN** 应使用以下方法：
  - `request.get(url, params)`: GET请求
  - `request.post(url, data)`: POST请求
  - `request.put(url, data)`: PUT请求
  - `request.del(url)`: DELETE请求

### Requirement: API文件规范

系统 SHALL API文件应遵循特定规范。

#### Scenario: API文件位置

- **WHEN** 创建API文件
- **THEN** 应放置在 `src/api/{module}/{feature}.js` 路径
- **THEN** 文件扩展名应为 `.js`，不是 `.ts`

#### Scenario: API函数命名

- **WHEN** 定义API函数
- **THEN** 应使用 camelCase 命名，如 `listProject`, `getProject`, `addProject`

#### Scenario: API路径规范

- **WHEN** 定义API路径
- **THEN** 应使用 kebab-case 命名，如 `/materials/project/list`

### Requirement: 字典使用规范

系统 SHALL 应正确使用字典数据。

#### Scenario: 通过proxy调用useDict

- **WHEN** 在Composition API中使用字典
- **THEN** 应通过 `proxy.useDict('dict_type')` 调用

#### Scenario: 加载字典

- **WHEN** 需要使用字典
- **THEN** 应在 `useDict` 中加载所有需要的字典类型

#### Scenario: 字典显示

- **WHEN** 显示字典值
- **THEN** 应使用 `dict-tag` 组件显示

### Requirement: 全局组件使用

系统 SHALL 应使用全局注册的组件。

#### Scenario: 使用right-toolbar组件

- **WHEN** 需要工具栏
- **THEN** 应使用 `<right-toolbar>` 组件

#### Scenario: 使用Pagination组件

- **WHEN** 需要分页
- **THEN** 应使用 `<Pagination>` 组件

#### Scenario: 使用dict-tag组件

- **WHEN** 显示字典标签
- **THEN** 应使用 `<dict-tag>` 组件

### Requirement: 权限控制规范

系统 SHALL 应正确控制权限。

#### Scenario: 使用v-hasPermi指令

- **WHEN** 控制按钮权限
- **THEN** 应使用 `v-hasPermi="['module:page:action']"` 指令

#### Scenario: 使用v-hasRole指令

- **WHEN** 控制角色权限
- **THEN** 应使用 `v-hasRole="['admin']"` 指令

#### Scenario: 权限标识格式

- **WHEN** 定义权限标识
- **THEN** 应使用 `模块:页面:操作` 格式，如 `materials:project:add`

### Requirement: 环境配置规范

系统 SHALL 应正确配置环境变量。

#### Scenario: 环境变量配置

- **WHEN** 配置环境变量
- **THEN** 应包含以下变量：
  - `VITE_APP_TITLE`: 页面标题
  - `VITE_APP_ENV`: 环境标识（development/production/staging）
  - `VITE_APP_BASE_API`: API基础路径
  - `VITE_APP_ENCRYPT`: 接口加密开关（true/false）
  - `VITE_APP_RSA_PUBLIC_KEY`: RSA公钥（加密用）
  - `VITE_APP_RSA_PRIVATE_KEY`: RSA私钥（解密用）
  - `VITE_APP_CLIENT_ID`: 客户端ID
  - `VITE_APP_WEBSOCKET`: WebSocket开关
  - `VITE_APP_KEY_GL`: 统一平台Key-GL
  - `VITE_APP_KEY_QY`: 统一平台Key-QY
  - `VITE_APP_REDIRECT_URL`: 重定向URL

### Requirement: 全局工具函数规范

系统 SHALL 应使用全局挂载的工具函数。

#### Scenario: 通过proxy调用工具函数

- **WHEN** 在Composition API中使用工具函数
- **THEN** 应通过 `proxy` 调用

#### Scenario: 常用工具函数

- **WHEN** 需要使用工具函数
- **THEN** 应使用以下常用函数：
  - `proxy.useDict()`: 获取字典数据
  - `proxy.download()`: 下载文件
  - `proxy.parseTime()`: 格式化时间
  - `proxy.resetForm()`: 重置表单
  - `proxy.handleTree()`: 处理树形数据
  - `proxy.addDateRange()`: 添加日期范围
  - `proxy.selectDictLabel()`: 选择字典标签
  - `proxy.selectDictLabels()`: 选择多个字典标签

### Requirement: 自定义指令规范

系统 SHALL 应正确使用自定义指令。

#### Scenario: 使用v-hasPermi指令

- **WHEN** 需要控制按钮权限
- **THEN** 应使用 `v-hasPermi="['system:user:add']"` 指令

#### Scenario: 使用v-hasRole指令

- **WHEN** 需要控制角色权限
- **THEN** 应使用 `v-hasRole="['admin']"` 指令

#### Scenario: 使用v-autoHeight指令

- **WHEN** 需要自动计算高度
- **THEN** 应使用 `v-autoHeight` 指令

#### Scenario: 使用v-copyText指令

- **WHEN** 需要复制文本
- **THEN** 应使用 `v-copyText` 指令

### Requirement: 组件开发规范

系统 SHALL 组件开发应遵循特定规范。

#### Scenario: 使用Composition API

- **WHEN** 创建组件
- **THEN** 应使用 Composition API 和 `<script setup>` 语法

#### Scenario: 使用Element Plus组件

- **WHEN** 使用UI组件
- **THEN** 应使用 Element Plus 组件
- **THEN** 禁止混用其他UI库

#### Scenario: 使用Pinia状态管理

- **WHEN** 需要状态管理
- **THEN** 应使用 Pinia
- **THEN** 禁止使用 Vuex

### Requirement: 表单开发规范

系统 SHALL 表单开发应遵循特定规范。

#### Scenario: 表单label-width计算

- **WHEN** 设置表单标签宽度
- **THEN** 应按 `字符数 * 20` 计算，最小 120px

#### Scenario: 输入框clearable属性

- **WHEN** 使用输入框
- **THEN** 应添加 `clearable` 属性

#### Scenario: 搜索区域输入框固定宽度

- **WHEN** 搜索区域的输入框
- **THEN** 应设置固定宽度 240px

### Requirement: 表格开发规范

系统 SHALL 表格开发应遵循特定规范。

#### Scenario: 操作列固定

- **WHEN** 表格有操作列
- **THEN** 应设置 `fixed="right"` 固定在右侧

#### Scenario: 使用columns数组控制显示

- **WHEN** 需要控制列显示/隐藏
- **THEN** 应使用 `columns` 数组

#### Scenario: 使用el-tooltip包装按钮

- **WHEN** 表格操作按钮
- **THEN** 应使用 `el-tooltip` 包装按钮显示提示

### Requirement: 批量操作规范

系统 SHALL 批量操作应遵循特定规范。

#### Scenario: 只保留批量删除

- **WHEN** 设计批量操作
- **THEN** 应只保留批量删除
- **THEN** 应移除批量修改

### Requirement: 导出功能规范

系统 SHALL 导出功能应支持导出选中数据。

#### Scenario: 传递ids参数

- **WHEN** 导出数据
- **THEN** 应支持传递 `ids` 参数导出选中数据

### Requirement: 日期范围选择器规范

系统 SHALL 应使用正确的日期范围选择器。

#### Scenario: 使用el-date-picker

- **WHEN** 需要日期范围选择
- **THEN** 应使用 `el-date-picker` 组件
- **THEN** 应设置 `type="daterange"`

### Requirement: 图标使用规范

系统 SHALL 应使用正确的图标。

#### Scenario: 常用图标

- **WHEN** 需要图标
- **THEN** 应使用以下常用图标：
  - `Search`: 搜索
  - `Refresh`: 刷新
  - `Plus`: 新增
  - `Edit`: 编辑
  - `Delete`: 删除
  - `Download`: 下载

### Requirement: 消息提示规范

系统 SHALL 应使用正确的消息提示方法。

#### Scenario: 成功提示

- **WHEN** 操作成功
- **THEN** 应使用 `proxy.$modal.msgSuccess()`

#### Scenario: 确认提示

- **WHEN** 需要用户确认
- **THEN** 应使用 `proxy.$modal.confirm()`
