# 行政区划管理 - 任务清单

## 1. 数据与表结构

- [x] 1.1 核对 `master.base_province` 实表字段
- [x] 1.2 统一删除标记为 `del_flag`
- [x] 1.3 补充重复数据清理脚本
- [x] 1.4 补充主键、唯一索引和树查询索引脚本

## 2. 后端

- [x] 2.1 `BaseProvince` 改为 `del_flag` 逻辑删除
- [x] 2.2 `type` 按字符串建模
- [x] 2.3 `en_code` 严格唯一校验
- [x] 2.4 页面接口权限口径统一为 `list/query`
- [x] 2.5 地区名称填充能力下沉并接入业务
- [ ] 2.6 搜索语义优化（保留标记）
- [ ] 2.7 `treeselect` 接口（按需再做）

## 3. 前端

- [x] 3.1 行政区划页面表单校验与表结构对齐
- [x] 3.2 `RegionDialog` 编辑回显补齐
- [ ] 3.3 `RegionSelect` 交互升级为 `common_region_picker` 完整形态（保留标记）

## 4. 验证

- [x] 4.1 `openspec validate system-region`
- [x] 4.2 后端编译验证
- [x] 4.3 前端构建验证
