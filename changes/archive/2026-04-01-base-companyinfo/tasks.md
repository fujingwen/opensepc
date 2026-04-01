# 任务清单

## 数据库

- [x] 1. 确认 `t_companyinfo` 表结构满足统一存储三类企业信息
- [x] 2. 确认 `base_province` 表可用于地区名称反查
- [x] 3. 确认企业管理菜单与权限 SQL 已部署

## 后端

- [x] 4. 创建 `BaseCompanyInfo` 实体、Mapper、Service、Controller
- [x] 5. 实现施工企业、生产企业、代理商分页查询接口
- [x] 6. 实现新增、编辑、删除、导出接口
- [x] 7. 新增企业时自动创建用户并分配角色（默认密码 `Hny@2022`，配置项 `sys.user.initPassword`）
- [x] 8. 修正企业信息查询返回字段，确保 `enterpriseName`、`contactPerson` 正确回填
- [x] 9. 解析 `area` 中的地区 ID，并关联 `base_province.full_name` 组装 `region`
- [x] 10. 为接口补充 `provinceCode/provinceName/cityCode/cityName/districtCode/districtName`
- [x] 11. 为代理商查询补充 `productionId`、所属生产企业名称和 `agentName`
- [x] 12. 支持代理商按 `agentName` 查询
- [x] 13. 修正create_by字段值使用实际用户ID而非"admin"
- [x] 14. 修正update_by字段值使用实际用户ID而非"admin"

## 前端

- [x] 15. 复用施工企业页面 `views/base/construction/index.vue`
- [x] 16. 复用生产企业页面 `views/base/production/index.vue`
- [x] 17. 复用代理商页面 `views/base/agent/index.vue`
- [x] 18. 统一企业管理 API 文件 `api/base/companyinfo.js`
- [x] 19. 页面按统一返回字段消费企业名称、联系人和地区信息
- [x] 20. 代理商页面使用 `enterpriseName`、`agentName`、`productionId` 完成列表和回显
- [x] 21. 修正权限标识，确保与数据库中实际权限标识一致
- [x] 22. 优化 `EnterpriseSelect` 组件，支持生产企业下拉选择（不分页）
- [x] 23. 优化 `getProductions` 接口，只返回enterpriseName和id字段

## 验证

- [x] 24. 验证施工企业列表与详情返回企业名称、联系人、地区中文名
- [x] 25. 验证生产企业列表与详情返回企业名称、联系人、地区中文名
- [x] 26. 验证代理商列表与详情返回所属生产企业、代理商名称、地区中文名
- [x] 27. 验证代理商编辑页可回显所属生产企业与省市区
- [x] 28. 验证用户创建时密码已正确加密（BCrypt.hashpw）
- [x] 29. 验证create_by和update_by字段使用实际用户ID