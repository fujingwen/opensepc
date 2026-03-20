## 1. 数据库准备

- [x] 1.1 创建建材产品表 mat_product
- [x] 1.2 创建序列 seq_mat_product
- [x] 1.3 创建索引（idx_product_project_id, idx_product_construction_unit, idx_product_name, idx_product_entry_time, idx_product_confirm_status）
- [x] 1.4 添加表和字段注释

## 2. 字典数据配置

- [x] 2.1 创建信息确认状态字典（info_confirm_status）
- [x] 2.2 创建信息确认超时字典（info_confirm_timeout）
- [x] 2.3 创建信息确认不通过类别字典（info_confirm_fail_type）
- [x] 2.4 创建有无备案证号字典（has_certificate_number）
- [x] 2.5 创建建材产品工程进度字典（product_project_progress）

## 3. 菜单和权限配置

- [x] 3.1 创建建材产品菜单（menu_id: 5000200）
- [x] 3.2 创建查询权限（materials:product:query）
- [x] 3.3 创建新增权限（materials:product:add）
- [x] 3.4 创建修改权限（materials:product:edit）
- [x] 3.5 创建删除权限（materials:product:remove）
- [x] 3.6 创建详情权限（materials:product:detail）
- [x] 3.7 创建导出权限（materials:product:export）
- [x] 3.8 创建审核权限（materials:product:audit）

## 4. 后端实体类

- [x] 4.1 创建 MatProduct 实体类
- [x] 4.2 创建 MatProductBo 业务对象
- [x] 4.3 创建 MatProductVo 视图对象
- [x] 4.4 创建 MatProductExcelVo 导出对象

## 5. 后端Mapper层

- [x] 5.1 创建 MatProductMapper 接口
- [x] 5.2 创建 MatProductMapper.xml 映射文件

## 6. 后端Service层

- [x] 6.1 创建 IMatProductService 接口
- [x] 6.2 创建 MatProductServiceImpl 实现类
- [x] 6.3 实现分页查询方法
- [x] 6.4 实现详情查询方法
- [x] 6.5 实现新增方法
- [x] 6.6 实现修改方法
- [x] 6.7 实现删除方法
- [x] 6.8 实现导出方法

## 7. 后端Controller层

- [x] 7.1 创建 MatProductController 控制器
- [x] 7.2 实现列表查询接口 GET /materials/product/list
- [x] 7.3 实现详情查询接口 GET /materials/product/{id}
- [x] 7.4 实现新增接口 POST /materials/product
- [x] 7.5 实现修改接口 PUT /materials/product
- [x] 7.6 实现删除接口 DELETE /materials/product/{ids}
- [x] 7.7 实现导出接口 POST /materials/product/export
- [x] 7.8 预留审核接口 PUT /materials/product/audit

## 8. 前端API接口

- [x] 8.1 创建 src/api/materials/product.js
- [x] 8.2 实现列表查询接口 listProduct
- [x] 8.3 实现详情查询接口 getProduct
- [x] 8.4 实现新增接口 addProduct
- [x] 8.5 实现修改接口 updateProduct
- [x] 8.6 实现删除接口 delProduct
- [x] 8.7 实现导出接口 exportProduct

## 9. 前端页面

- [x] 9.1 创建 src/views/materials/product/index.vue
- [x] 9.2 实现查询表单区域（15个查询条件）
- [x] 9.3 实现操作按钮区域（新增、删除、导出）
- [x] 9.4 实现数据表格区域（21个展示字段）
- [x] 9.5 实现分页组件
- [x] 9.6 实现新增对话框（17个表单字段）
- [x] 9.7 实现编辑对话框（复用新增对话框）
- [x] 9.8 实现详情对话框（只读展示）
- [x] 9.9 实现表单验证规则
- [x] 9.10 实现文件上传组件（产品合格证、出厂检验报告、性能检验报告、实物照片）
- [x] 9.11 实现操作按钮权限控制
- [x] 9.12 实现编辑删除操作限制（仅待信息确认状态可操作）

## 10. 测试验证

- [x] 10.1 验证数据库表和索引创建成功
- [x] 10.2 验证字典数据配置正确
- [x] 10.3 验证菜单权限配置正确
- [x] 10.4 验证后端接口功能正常
- [x] 10.5 验证前端页面功能正常
- [x] 10.6 验证文件上传功能正常
- [x] 10.7 验证导出功能正常
- [x] 10.8 验证权限控制正常
