# 问题记录

## 审查范围

- OpenSpec 文档：`proposal.md`、`design.md`、`specs/system_product/spec.md`
- 后端实现：`SysProductController`、`SysProductServiceImpl`、`SysProduct`、`SysProductBo`
- 前端实现：`src/views/system/product/index.vue`、`src/api/system/product.js`
- 数据库核对：`master.sys_product`、`master.sys_menu`、`master.sys_dict_data`

## 发现

### 1. 删除语义与提案不一致，当前代码会写出 `del_flag = 1`

- 提案和设计约定 `del_flag = 0` 表示正常，`del_flag = 2` 表示删除。
- 但实体 [SysProduct.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/SysProduct.java#L102) 只写了默认 `@TableLogic`，没有显式配置 `delval = "2"`。
- 服务删除 [SysProductServiceImpl.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/SysProductServiceImpl.java#L157) 直接调用 `baseMapper.deleteById(id)`。
- MyBatis-Plus 默认逻辑删除值是 `1`，这会和提案、实表现状冲突。我核对实库后，`master.sys_product` 当前删除数据都是 `del_flag = '2'`，没有 `1`。

### 2. 右侧“按名称和状态查询”没有完整落地，前端缺少状态筛选

- 规格明确要求右侧列表支持按名称和状态查询。
- 后端查询确实支持 `enabledMark`，见 [SysProductServiceImpl.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/SysProductServiceImpl.java#L59) 到 [SysProductServiceImpl.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/SysProductServiceImpl.java#L65)。
- 但前端搜索区只有名称输入框，没有状态选择控件，见 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L35) 到 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L44)。
- `queryParams` 虽然保留了 `enabledMark`，见 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L161)，但页面没有入口让用户设置它，所以提案能力并未真正交付。

### 3. 编码 `enCode` 没有按规格做必填校验

- 规格要求名称、编码都是必填。
- 后端 BO [SysProductBo.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/bo/SysProductBo.java#L57) 到 [SysProductBo.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/domain/bo/SysProductBo.java#L60) 只有长度限制，没有 `@NotBlank`。
- 前端表单规则也只校验了 `fullName` 和 `sortCode`，见 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L250) 到 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L254)。
- 这意味着当前可以新增或修改出空编码数据，不符合 spec。

### 4. 多级分类新增逻辑会把 `category_id` 继承错，后续查询范围会跑偏

- 左侧允许新增子分类，控制器 [SysProductController.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/SysProductController.java#L69) 到 [SysProductController.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/SysProductController.java#L75) 会直接把带 `parentId` 的分类传入服务。
- 服务新增时，只要 `parentId != 0`，就无条件把 `categoryId` 设为父节点的 `categoryId`，见 [SysProductServiceImpl.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/SysProductServiceImpl.java#L122) 到 [SysProductServiceImpl.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/SysProductServiceImpl.java#L128)。
- 右侧列表又是按 `category_id = 当前点击分类ID` 查，见 [SysProductServiceImpl.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/SysProductServiceImpl.java#L53) 到 [SysProductServiceImpl.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/SysProductServiceImpl.java#L58)。
- 这会导致“新建出来的子分类”右侧查不到自己名下数据，或者查到的是上层分类整棵树。实库现在已经有多级分类数据，新增如果继续走这套逻辑，风险是现实存在的。

### 5. 前端权限控制没有按提案完整加上

- 提案设计了 `system:product:list/query/add/edit/remove` 权限模型，后端控制器也都加了 `@SaCheckPermission`。
- 但前端页面上的新增、删除、编辑等按钮没有使用 `v-hasPermi`，见 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L7)、[index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L24)、[index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L50) 到 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L53)、[index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L81) 到 [index.vue](/e:/construction-material/construction-material-web/src/views/system/product/index.vue#L83)。
- 结果是无权限用户前端仍会看到操作入口，只是在点击后被后端拒绝，交互上不符合提案的权限体验。

### 6. 文档本身存在口径分叉，影响后续验收

- `design.md` 中部仍写了分类编辑/删除走独立 `/system/product/category` 接口，也写过组件路径 `system/product/index1`。
- 但当前控制器实际是分类与产品共用 `PUT /system/product` 和 `DELETE /system/product/{id}`，见 [SysProductController.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/SysProductController.java#L93) 到 [SysProductController.java](/e:/construction-material/construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/SysProductController.java#L109)。
- OpenSpec 菜单 SQL [sys_product_menu.sql](/e:/construction-material/openspec/changes/system-product/sql/menu/sys_product_menu.sql#L8) 和实库 `master.sys_menu` 里的组件路径也是 `system/product/index`，不是 `index1`。
- 这类文档分叉不会立刻导致功能报错，但会让“按文档验收”出现歧义。

## 数据库核对摘要

- `master.sys_product` 当前共有 38476 条，其中 `category/product/spec` 分别为 `27/7/38442`。
- 删除标志分布为：`del_flag='0'` 38470 条，`del_flag='2'` 6 条。
- 顶级分类（`node_type='category' and parent_id='0'`）当前只有 6 条，说明大量分类是多级结构，新增逻辑中的 `category_id` 处理是否正确非常关键。
- `master.sys_menu` 当前产品菜单组件路径是 `system/product/index`。
- `master.sys_dict_data` 中同时存在 `sys_region_status` 和 `sys_normal_disable`，当前实现选用 `sys_region_status` 能工作，但这也说明状态字典选择应在文档中固定，否则后续容易再次分叉。

## 建议优先级

1. 先修正 `del_flag` 逻辑删除值，统一到 `0/2`。
2. 修正多级分类新增时的 `category_id` 赋值规则。
3. 补齐状态筛选和 `enCode` 必填校验。
4. 再收口前端权限展示和文档口径。
