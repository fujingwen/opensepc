# 通知公告变更落地说明

## 1. 变更目标

本次变更将通知公告模块的实现与最新业务口径对齐，重点解决以下问题：

- 采购公告、库存公告不再要求前端手工选择企业
- 后端不再强制要求 `companyId/companyName`
- 库存公告发布后应面向全部施工企业可见
- 采购公告发布后应面向全部生产企业可见
- 发布人本人仍应能继续查看和维护自己创建的草稿
- 超级管理员、租户管理员应可直接维护采购/库存公告
- 列表与详情页应展示发布人，便于识别公告来源

## 2. 前端落地

### 2.1 页面入口

- `src/views/notice/inventory/index.vue`
- `src/views/notice/purchase/index.vue`

处理方式：

- 不再向公共页面组件传入 `company-type`
- 页面不再要求展示企业选择项

### 2.2 公共页面行为

- `src/views/notice/components/NoticeManagePage.vue`

保留能力：

- 系统公告只读查看
- 采购/库存公告支持新建、草稿保存、发布、草稿编辑、草稿删除

业务口径：

- 新建采购/库存公告时仅要求填写标题、内容
- 企业过滤和跨企业查看范围不再由页面手工控制
- 公告列表与详情页补充展示 `publisherName`
- 当前实现口径：采购/库存公告的“发布”动作主要通过列表草稿行按钮触发，表单页主动作是保存草稿

## 3. 后端落地

### 3.1 核心实现

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/MsgNoticePublishServiceImpl.java`

处理内容：

- 去除 `purchase/inventory` 对 `companyId/companyName` 的强制校验
- 保留 `company_id/company_name` 字段以兼容历史结构
- 按公告类型与角色控制已发布公告的查看范围
- 允许发布人本人继续查看和维护自己创建的草稿
- 已发布公告不允许再次修改
- 超级管理员、租户管理员通过特权判断直接放行，不受企业角色限制
- 企业用户查看范围按真实角色与企业上下文识别，避免列表接口误判身份

### 3.2 消息通知

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/MsgMessageServiceImpl.java`
- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/mapper/MsgMessageUserMapper.java`
- `construction-material-backend/hny-modules/hny-system/src/main/resources/mapper/system/MsgMessageUserMapper.xml`

处理内容：

- 公告首次发布时，向对应受众异步发送站内消息
- 收件箱记录改为批量写入，减少逐条插入造成的接口超时风险

### 3.3 接口层

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/MsgNoticePublishController.java`

说明：

- 控制器接口路径和接口定义未调整
- 本次业务变化主要体现在服务层规则
- 本轮按当前实现同步了 `notice:systemNotice:*` 系统公告权限编码，并收紧了非目标角色对采购/库存列表的查询边界

## 4. OpenSpec 同步

已同步更新以下文档：

- `proposal.md`
- `design.md`
- `specs/notice_announcement/spec.md`
- `issues.md`
- `tasks.md`

同步后的统一口径：

- 系统公告只读
- 采购/库存公告支持草稿与发布
- 采购/库存公告不再要求选择企业
- 库存公告发布后全部施工企业可见
- 采购公告发布后全部生产企业可见
- 超级管理员、租户管理员不受企业角色限制
- 公告列表与详情页展示发布人
- 公告发布后的站内消息通知改为异步批量发送

## 5. 校验结果

### 5.1 OpenSpec 校验

- `openspec validate notice-announcement`
- 结果：通过

### 5.2 后端编译校验

- `mvn -pl hny-modules/hny-system -am compile -DskipTests`
- 结果：通过

### 5.3 数据验证

基于 2026-04-10 对开发库 `building_supplies_supervision` 的只读核查：

- `master.msg_notice_publish`
- `master.sys_dict_data`
- `master.sys_menu`
- `information_schema.columns`
- `information_schema.table_constraints`
- `pg_indexes`

结论：

- `master.msg_notice_publish` 当前已有 4 条有效公告数据，不再是空库状态
- 其中 1 条草稿公告已经带有 `publish_time`，说明开发库表结构仍沿用旧的“发布时间非空默认 now()”定义
- `msg_publish_status` 字典当前只有 `published/closed`，缺少 `draft`
- `msg_notice_publish` 当前未查询到主键/索引定义，和 change 中的 DDL、索引 SQL 不一致
- 系统公告权限编码已按当前实现同步为 `notice:systemNotice:*`，后端保留了对旧编码的兼容

## 6. 当前状态

本次 `notice-announcement` 变更已完成的部分：

- 提案对齐
- 设计对齐
- 规格对齐
- 代码实现主流程对齐
- OpenSpec 校验
- 后端编译校验
- 数据现状复核
- 后端权限边界补充修正

剩余事项主要是开发库数据库收口：

- 是否补齐 `msg_publish_status=draft` 字典
- 是否调整 `msg_notice_publish` 的默认值和可空约束
- `msg_notice_publish` 主键/索引落库
