# 问题记录

1. ~~生产企业页面中，前端没有分页组件，无法切换到下一页；table列表的接口返回值，联系人和联系电话都是空，应该取到master.t_companyinfo表的contact_user和contact_phone字段返回；table列表的省市区直接反悔了area字段的值，比如["37","3702","370214"]，这是不正确的，应该去base_province表中根据每个id查询之后返回，比如山东省/青岛市/城阳区~~ **已解决**：实现了地区名称解析功能，通过关联base_province表返回完整的省市区信息，并实现了企业名称和联系人字段的正确回填
2. ~~master.t_companyinfo表的create_by字段的值不应该是admin，而是1~~ **已解决**：修改了企业创建逻辑，create_by字段现在使用当前登录用户的实际ID，而不是"admin"
3. ~~生产企业的新增、查看、删除、导出按钮都没显示，看一下权限设计，应该是权限标识不正确；施工企业和代理商的权限标识也需要检查一下，确保和数据库中的权限标识一致~~ **已解决**：修正了权限标识，现在与数据库中的实际权限标识保持一致
4. ~~master.t_companyinfo表的update_by如果是admin的，也需要从admin改为1~~ **已解决**：修改了企业更新逻辑，update_by字段现在使用当前登录用户的实际ID，而不是"admin"
5. ~~在代理商页面，新增代理商时，所属生产企业字段应该是下拉选择，而不是手动输入，数据来源是生产企页面的列表，并且是全部数据，不分页的~~ **已解决**：修改了 `EnterpriseSelect` 组件，默认使用 `getProductions` 接口获取全部生产企业数据（不分页），支持本地过滤搜索
6. ~~补充第五条，getProductions接口返回的列表，只需要enterpriseName和id字段~~ **已解决**：优化了getProductions接口，现在只返回enterpriseName和id字段，符合前端组件需求
7. ~~新增企业时自动创建用户并分配角色，这个功能中，默认密码为 `Hny@2022`，但是存储在数据库中时，应该是加密后的密码，而不是明文密码，现在是明文密码，参考系统管理-用户管理处新增用户密码如何转换的~~ **已解决**：在 `BaseCompanyInfoUserCreateListener` 中添加了 `BCrypt.hashpw()` 加密，与系统管理用户管理保持一致
8. ~~在代理商页面，新增代理商时，为什么调用base/companyinfo/production/getByUserId/1.接口？~~ **已解决**：优化了代理商页面逻辑，不再调用该接口，直接使用getProductions接口获取生产企业列表
