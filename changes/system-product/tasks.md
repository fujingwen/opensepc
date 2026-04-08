# 产品管理（字典替换）- 任务清单

## 数据库

- [x] 1. sys_product 表已存在，无需创建
- [x] 2. 序列已存在（seq_sys_product）
- [x] 3. 索引已存在

## 后端

- [x] 4. 创建 SysProduct 实体类
- [x] 5. 创建 SysProductBo 业务对象
- [x] 6. 创建 SysProductVo 视图对象
- [x] 7. 创建 SysProductMapper 接口
- [x] 8. 创建 SysProductMapper.xml
- [x] 9. 创建 ISysProductService 接口
- [x] 10. 创建 SysProductServiceImpl 实现
- [x] 11. 创建 SysProductController 控制器

## 前端

- [x] 12. 创建 api/system/product.js API 接口
- [x] 13. 创建 views/system/product/index.vue 页面组件（左右分栏布局）

## 菜单与权限

- [x] 14. 使用现有菜单
- [x] 15. 使用现有权限标识

## 测试

- [x] 16. 测试后端 API
- [x] 17. 测试前端页面

## 部署

- [x] 18. 部署后端服务
- [x] 19. 部署前端服务

## 扩展功能（超出原提案）

- [x] 20. 左侧类别树支持编辑和删除操作
- [x] 21. 左侧新增类别时上级分类为树形选择器（显示当前选中类别及其子项）
- [x] 22. 编辑类别时上级分类不可修改
- [x] 23. 合并编辑/删除类别和产品接口（共用 /system/product）
- [x] 24. 建材产品级联查询兼容历史 `sys_product` 数据，按 `tree_path + category_id` 双通道加载产品名称
- [x] 25. 已核对旧库与新库 `master.sys_product` 数据规模一致，确认无需整表同步
