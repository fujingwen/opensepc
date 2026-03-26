## 1. 后端：创建通用导入框架

- [x] 1.1 创建 `GenericImportVo.java` 通用导入VO基类
- [x] 1.2 创建 `GenericImportListener.java` 通用导入监听器基类
- [x] 1.3 封装通用导入逻辑（数据验证、统计等）
- [x] 1.4 确保基类可被继承和扩展

## 2. 后端：创建备案产品导入VO类

- [x] 2.1 创建 `MatRecordImportVo.java` 类
- [x] 2.2 添加Excel注解，定义导入字段（备案产品名称、生产企业名称、备案证号、统一社会信用代码、开始时间、结束时间、备案证状态等）
- [x] 2.3 使用 `@ExcelProperty` 注解映射Excel列名

## 3. 后端：创建备案产品导入监听器

- [x] 3.1 创建 `MatRecordImportListener.java` 类
- [x] 3.2 实现 `AnalysisEventListener<MatRecordImportVo>` 接口
- [x] 3.3 实现数据验证逻辑（必填字段、格式验证）
- [x] 3.4 实现数据保存逻辑（新增或更新）
- [x] 3.5 统计导入成功和失败数量，生成导入结果信息

## 4. 后端：在控制器中添加入口

- [x] 4.1 在 `MatRecordController.java` 中添加 `importData` 接口（POST /materials/record/importData）
- [x] 4.2 在 `MatRecordController.java` 中添加 `importTemplate` 接口（POST /materials/record/importTemplate）
- [x] 4.3 添加权限注解 `@SaCheckPermission("materials:record:import")`
- [x] 4.4 使用 `ExcelUtil.importExcel` 工具类解析Excel文件

## 5. 前端：创建通用批量导入弹窗组件基础结构

- [x] 5.1 在 `src/components/` 目录下创建 `BatchImportDialog` 文件夹和 `index.vue` 文件
- [x] 5.2 实现弹窗基础布局，包含 el-dialog 和三步式 el-steps 组件
- [x] 5.3 实现弹窗打开/关闭功能和状态重置逻辑
- [x] 5.4 设计组件API，确保可在多个页面复用

## 6. 前端：实现第一步 - 上传文件

- [x] 6.1 集成 el-upload 组件，支持 .xls 和 .xlsx 文件上传
- [x] 6.2 实现文件格式校验（仅允许 .xls/.xlsx）
- [x] 6.3 实现文件大小校验（不超过 500KB）
- [x] 6.4 实现下载模板功能（调用后端 importTemplate 接口）
- [x] 6.5 实现上传成功后自动进入第二步

## 7. 前端：实现第二步 - 数据预览

- [x] 7.1 创建数据表格组件，展示解析后的数据
- [x] 7.2 实现表格列配置（序号、企业名称、产品名称、备案证号、有效期限、联系人、联系电话、操作）
- [x] 7.3 实现行内编辑功能
- [x] 7.4 实现删除数据行功能
- [x] 7.5 实现上一步/下一步导航按钮

## 8. 前端：实现第三步 - 导入数据

- [x] 8.1 显示导入进度条
- [x] 8.2 实现调用后端批量导入接口（importData）
- [x] 8.3 实现导入成功页面（绿色对勾图标、成功提示）
- [x] 8.4 实现导入失败处理和错误提示
- [x] 8.5 实现关闭按钮和成功后刷新父页面数据

## 9. 前端：API层更新

- [x] 9.1 在 `src/api/materials/record.js` 中添加 `importData` API方法
- [x] 9.2 在 `src/api/materials/record.js` 中添加 `importTemplate` API方法

## 10. 前端：集成到备案产品管理页面

- [x] 10.1 在 `src/views/materials/record/index.vue` 中添加"批量导入"按钮
- [x] 10.2 引入并使用 BatchImportDialog 组件
- [x] 10.3 实现导入成功后刷新列表数据

## 11. 前端：组件复用性优化

- [x] 11.1 确保组件可在其他页面复用
- [ ] 11.2 编写组件使用文档（可选）

## 12. 测试和优化

- [ ] 12.1 测试完整的导入流程（前后端联调）
- [ ] 12.2 测试各种边界情况（大文件、无效格式、空数据等）
- [ ] 12.3 优化用户体验和错误提示