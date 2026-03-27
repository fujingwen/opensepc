# 任务清单

## 数据库

- [ ] 1. 创建省市区表 base_region（如尚未存在）
- [ ] 2. 导入省市区初始化数据 base_region_data.sql
- [ ] 3. 确保 t_companyinfo 表已存在（如尚未存在则创建）
- [ ] 4. 创建企业信息管理菜单 SQL (base_companyinfo_menu.sql)
- [ ] 5. 创建企业类型字典 SQL (base_companyinfo_dict.sql)

## 后端

- [x] 6. 创建 BaseCompanyInfo 实体类
- [x] 7. 创建 BaseCompanyInfoVo 视图对象
- [x] 8. 创建 BaseCompanyInfoMapper 接口
- [x] 9. 创建 IBaseCompanyInfoService 接口
- [x] 10. 创建 BaseCompanyInfoServiceImpl 实现类
- [x] 11. 创建 BaseCompanyInfoController 控制器
- [x] 12. 实现分页查询接口
- [x] 13. 实现新增接口
- [x] 14. 实现修改接口
- [x] 15. 实现删除接口
- [x] 16. 实现导出接口

## 前端（复用现有页面，统一 API 文件）

- [x] 17. 复用现有页面 views/base/production/index.vue（生产企业）
- [x] 18. 复用现有页面 views/base/construction/index.vue（施工企业）
- [x] 19. 复用现有页面 views/base/agent/index.vue（代理商）
- [x] 20. 创建统一 API 文件 api/base/companyinfo.js，删除旧的 production.js, construction.js, agent.js
- [x] 21. 更新前端页面导入路径为 @/api/base/companyinfo

## 数据迁移

- [x] 23. 删除 base_production、base_construction、base_agent 表（如存在）
- [x] 24. 确保只使用 t_companyinfo 表存储企业数据