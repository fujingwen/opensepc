## Why

当前系统缺少通用的批量导入数据功能，用户需要逐条录入各种类型的数据（如备案产品、用户等），效率低下。系统已有用户导入功能作为参考，需要实现一个更完善的三步式通用批量导入弹窗组件，同时包含前端和后端实现，可在多个页面复用。

## What Changes

- 新增通用批量导入弹窗组件（BatchImportDialog）
- 组件分为三个步骤：上传文件、数据预览、导入数据
- 支持Excel文件（.xls/.xlsx）上传和解析
- 支持数据预览和编辑功能
- 支持下载导入模板
- 集成到备案产品管理页面（作为第一个使用场景）
- 后端新增通用批量导入框架（可复用的导入VO、监听器模板）
- 后端新增备案产品导入相关实现（基于通用框架）
- 提供备案产品导入模板（备案产品信息模板.xlsx）

## Capabilities

### New Capabilities

- `batch-import`: 三步式通用批量导入功能，包含前端组件、后端通用框架和备案产品导入实现

### Modified Capabilities

<!-- 无现有能力需要修改 -->

## Impact

- 前端：新增 `src/components/BatchImportDialog` 通用组件
- 前端：修改 `src/views/materials/record/index.vue` 集成导入功能
- 前端：修改 `src/api/materials/record.js` 新增导入相关API
- 后端：新增 `GenericImportVo.java` 通用导入VO基类
- 后端：新增 `GenericImportListener.java` 通用导入监听器基类
- 后端：新增 `MatRecordImportVo.java` 备案产品导入VO类（继承通用基类）
- 后端：新增 `MatRecordImportListener.java` 备案产品导入监听器（继承通用基类）
- 后端：修改 `MatRecordController.java` 新增导入接口
- 资源：新增 `备案产品信息模板.xlsx` 导入模板文件
- 依赖：使用项目现有的Element Plus组件和ExcelUtil工具类

## Resources

- `备案产品信息模板.xlsx`: 备案产品导入模板，包含以下字段：
  - 企业名称
  - 产品名称
  - 备案证号
  - 统一社会信用代码
  - 开始时间
  - 结束时间
  - 备案证状态
  - 联系人
  - 联系电话
