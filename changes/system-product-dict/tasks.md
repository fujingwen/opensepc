# 产品管理 - 任务清单

## 数据库

- [x] 1. 使用现有字典表（base_dictionarytype、base_dictionarydata）

## 后端

- [x] 2. 复用 BaseDictionaryMapper 接口
- [x] 3. 扩展 BaseDictionaryMapper.xml（新增 CRUD SQL）
- [x] 4. 扩展 IBaseDictionaryService 接口（新增方法）
- [x] 5. 扩展 BaseDictionaryServiceImpl 实现
- [x] 6. 扩展 BaseDictionaryController 控制器

## 前端

- [x] 7. 扩展 dictionary.js API 接口（新增 CRUD 方法）
- [x] 8. 创建 product/index.vue 页面组件（左右分栏布局）

## 菜单与权限

- [x] 9. 菜单路径改为 system/sysProduct（组件路径仍为 system/product/index）

## 测试

- [x] 10. 测试后端 API
- [x] 11. 测试前端页面

## 部署

- [x] 12. 部署后端服务
- [x] 13. 部署前端服务

## 代码清理（2026-03-23）

- [x] 14. 删除未使用的 sys_product 表 SQL 文件
- [x] 15. 删除 hny-system 模块中的 SysProduct 相关代码
- [x] 16. 删除未使用的前端 API 文件 api/system/product.js
- [x] 17. 确认实现与提案一致（使用字典表）
