# 行政区划管理 - 任务清单

## 1. 数据库确认

- [x] 1.1 确认 master.base_province 表已存在（已从test模式复制）
- [x] 1.2 确认表字段包含系统字段（tenant_id, create_dept, create_by, create_time, update_by, update_time, del_flag）

## 2. 后端开发

### 2.1 实体类与Mapper

- [ ] 2.1.1 创建 BaseProvinceEntity 实体类（对应master.base_province表）
- [ ] 2.1.2 创建 BaseProvinceMapper 接口
- [ ] 2.1.3 创建 BaseProvinceMapper.xml

### 2.2 Service层

- [ ] 2.2.1 创建 IBaseProvinceService 接口
- [ ] 2.2.2 创建 BaseProvinceServiceImpl 实现类
- [ ] 2.2.3 实现地区名称填充工具类 RegionNameFillUtil

### 2.3 Controller层

- [ ] 2.3.1 创建 BaseProvinceController（系统管理-行政区划）
- [ ] 2.3.2 实现分页查询接口
- [ ] 2.3.3 实现获取树形数据接口（treeselect）
- [ ] 2.3.4 实现获取子级地区列表接口
- [ ] 2.3.5 实现增删改接口

### 2.4 配置与权限

- [ ] 2.4.1 在菜单表中添加系统管理-行政区划菜单
- [ ] 2.4.2 配置API权限标识（system:region:*）

## 3. 前端开发

### 3.1 API层

- [ ] 3.1.1 创建行政区划API接口文件 api/system/region.ts
- [ ] 3.1.2 实现分页查询方法
- [ ] 3.1.3 实现树形数据获取方法
- [ ] 3.1.4 实现增删改方法

### 3.2 公共组件

#### 3.2.1 RegionSelect 组件（Popover形式）
- [x] 3.2.1.1 创建 RegionSelect 组件目录结构
- [x] 3.2.1.2 实现省市区三级联动选择器
- [x] 3.2.1.3 实现Props和Events接口
- [x] 3.2.1.4 实现数据懒加载逻辑
- [x] 3.2.1.5 实现编辑回显功能
- [x] 3.2.1.6 编写组件使用说明

#### 3.2.2 RegionDialog 组件（Dialog形式）
- [ ] 3.2.2.1 创建 RegionDialog 组件目录结构
- [ ] 3.2.2.2 实现省市区树形选择器
- [ ] 3.2.2.3 实现Props和Events接口
- [ ] 3.2.2.4 实现树形数据懒加载逻辑
- [ ] 3.2.2.5 实现编辑回显功能
- [ ] 3.2.2.6 编写组件使用说明

### 3.3 行政区划管理页面

- [ ] 3.3.1 创建页面目录 views/system/region
- [ ] 3.3.2 实现查询功能（行政区划名称/编码、状态筛选）
- [ ] 3.3.3 实现Table表格展示
- [ ] 3.3.4 实现新增弹窗
- [ ] 3.3.5 实现编辑弹窗
- [ ] 3.3.6 实现删除功能
- [ ] 3.3.7 配置路由

### 3.4 菜单配置

- [ ] 3.4.1 在菜单管理中添加系统管理-行政区划菜单
- [ ] 3.4.2 配置菜单图标和排序

## 4. 测试与部署

- [ ] 4.1 后端单元测试
- [ ] 4.2 前端组件测试
- [ ] 4.3 集成测试
- [ ] 4.4 编写接口文档
- [ ] 4.5 部署验证
