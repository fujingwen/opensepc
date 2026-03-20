## 菜单和权限配置

### 模块菜单

| 字段 | 值 |
|------|-----|
| 菜单名称 | 建材填报管理 |
| 菜单类型 | M（模块） |
| 路由路径 | building-materials |
| 图标 | system |
| 排序 | 100 |

### 页面菜单

| 字段 | 值 |
|------|-----|
| 菜单名称 | 备案产品管理 |
| 菜单类型 | C（页面） |
| 路由路径 | record |
| 组件路径 | building-materials/record/index |
| 权限标识 | materials:record:list |
| 排序 | 1 |
| 父级菜单 | 建材填报管理 |

### 按钮权限

| 按钮名称 | 权限标识 | 排序 | 类型 |
|---------|---------|------|------|
| 备案产品查询 | materials:record:query | 1 | F（按钮） |
| 备案产品新增 | materials:record:add | 2 | F（按钮） |
| 备案产品修改 | materials:record:edit | 3 | F（按钮） |
| 备案产品删除 | materials:record:remove | 4 | F（按钮） |

### 前端使用

```vue
<el-button v-hasPermi="['materials:record:add']">新增</el-button>
<el-button v-hasPermi="['materials:record:edit']">修改</el-button>
<el-button v-hasPermi="['materials:record:remove']">删除</el-button>
```

### 后端使用

```java
@SaCheckPermission("materials:record:list")
@GetMapping("/list")
public TableDataInfo list() {}

@SaCheckPermission("materials:record:add")
@PostMapping
public R<Void> add() {}

@SaCheckPermission("materials:record:edit")
@PutMapping
public R<Void> edit() {}

@SaCheckPermission("materials:record:remove")
@DeleteMapping("/{ids}")
public R<Void> remove() {}
```
