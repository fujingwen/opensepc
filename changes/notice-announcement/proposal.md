## Why

当前通知公告能力已经从原始提案继续演进，尤其是“库存信息发布”和“采购信息发布”的企业选择与可见范围发生了明确调整：

- 前端不再要求在发布采购/库存公告时手工选择企业
- 后端不再强制校验 `companyId/companyName`
- 已发布公告的受众范围改为按业务类型和角色统一分发，而不是按单企业定向查看

如果不把这些变化补充回提案，后续设计、验收和联调会继续沿用旧理解，导致提案、代码和测试口径不一致。

## What Changes

- 保持独立变更 `notice-announcement`，继续承接通知公告相关实现
- 明确系统公告在当前模块内仍为只读查看
- 明确库存公告由生产企业发布，发布后所有施工企业可见
- 明确采购公告由施工企业发布，发布后所有生产企业可见
- 取消采购/库存公告“前端必须选择企业”的交互要求
- 取消采购/库存公告“后端必须传入企业 ID/企业名称”的入参强校验
- 保留采购/库存公告的“草稿 -> 发布”流转
- 保留现有菜单、接口路径、表结构主模型不变

## Frontend Changes

### 公告发布页面

- `库存信息发布` 页面不再传入企业选择配置，表单中不再展示“生产企业”选择项
- `采购信息发布` 页面不再传入企业选择配置，表单中不再展示“施工企业”选择项
- 系统公告页面仍然只允许查询和查看
- 采购/库存公告页面仍保留：
  - 新建
  - 编辑草稿
  - 删除草稿
  - 保存草稿
  - 发布

### 交互口径

- 新建采购/库存公告时，只需要填写标题和内容即可提交
- 页面不再依赖“根据登录人自动匹配并锁定所属企业”的交互前提
- 已发布公告的跨企业查看范围由后端统一控制，前端不再承担企业过滤职责

## Backend Changes

### 入参与保存

- `/notice/publish` 的新增、编辑接口保持不变
- `purchase` 和 `inventory` 类型公告不再强制要求 `companyId/companyName`
- `msg_notice_publish` 表中的 `company_id/company_name` 字段保留，用于兼容历史数据和后续扩展

### 可见范围

- `inventory`
  - 生产企业负责发布和维护自己的草稿
  - 公告发布后，所有施工企业都可以查看
- `purchase`
  - 施工企业负责发布和维护自己的草稿
  - 公告发布后，所有生产企业都可以查看
- 发布人本人仍可查看自己创建的草稿或记录，避免“保存后自己不可见”

### 管理边界

- 系统公告在该模块中不支持新增、编辑、删除
- 采购/库存公告已发布后仍不允许再次修改
- 草稿数据允许继续编辑、删除或发布

## Capabilities

### Notice Announcement

- 系统公告
  - 查询
  - 查看
- 库存信息发布
  - 新建
  - 编辑草稿
  - 删除草稿
  - 保存草稿
  - 发布后面向全部施工企业可见
- 采购信息发布
  - 新建
  - 编辑草稿
  - 删除草稿
  - 保存草稿
  - 发布后面向全部生产企业可见

## Manual Alignment

本次补充后，提案与当前实现的主要对齐点如下：

- 企业侧系统公告保持只读
- 采购/库存公告支持草稿保存后再发布
- 采购/库存公告不再要求页面手工选择企业
- 采购/库存公告不再要求后端必须接收企业字段
- 公告发布后的查看范围改为按业务类型面向对应角色企业统一开放：
  - 库存公告 -> 全部施工企业
  - 采购公告 -> 全部生产企业

## Impact

- OpenSpec
  - `openspec/changes/notice-announcement/proposal.md`
- Backend
  - `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/service/impl/MsgNoticePublishServiceImpl.java`
  - `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/controller/system/MsgNoticePublishController.java`
- Frontend
  - `construction-material-web/src/views/notice/components/NoticeManagePage.vue`
  - `construction-material-web/src/views/notice/inventory/index.vue`
  - `construction-material-web/src/views/notice/purchase/index.vue`
