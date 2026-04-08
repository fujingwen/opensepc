## Why

当前 `message-center-notice` 变更同时包含“消息中心”和“通知公告”两块能力，范围过大，不利于独立评审、实施和归档。

其中：

- 消息中心已经切换为基于 `test` 旧消息表迁移后的模型实现
- 通知公告仍然保持 `master.msg_notice_publish` 独立模型

这两部分在数据模型、菜单权限、字典和实现路径上都相互独立，继续放在同一个 OpenSpec 变更里会造成边界不清。

因此，本次调整将“通知公告”从原变更中拆分为独立提案，并按操作手册继续收口企业侧公告发布流程。

## What Changes

- 新建独立变更 `notice-announcement`
- 承接原 `message-center-notice` 中与通知公告相关的规格、SQL 和元数据
- 保持通知公告模块使用 `master.msg_notice_publish`
- 企业侧 `系统公告` 页面改为只读查看，不再提供新增、编辑、删除
- `库存信息发布`、`采购信息发布` 支持 `草稿 -> 发布` 流转
- 当前阶段前端根据登录用户 `deptName` 自动匹配并锁定所属企业，减少手工选择
- 保持现有菜单结构：
  - `通知公告`
  - `系统公告`
  - `库存信息发布`
  - `采购信息发布`

## Capabilities

### Notice Announcement

- 系统公告
  - 仅查看
- 库存信息发布
  - 新建、编辑、删除
  - 保存草稿
  - 发布
- 采购信息发布
  - 新建、编辑、删除
  - 保存草稿
  - 发布

## Manual Alignment

对照《青岛市建设工程材料信息管理平台操作手册》，本提案本轮已完成以下收口：

- 企业侧“系统公告”改为只读查看。
- “库存信息发布 / 采购信息发布”支持先保存草稿，再执行发布。
- 页面尝试基于当前登录角色的企业名称自动带出并锁定所属企业。

当前仍有以下后续事项：

- 后端尚未按登录主体自动回填并强校验 `companyId/companyName`，当前企业上下文仍以页面自动锁定为主。
- 手册按角色区分可见与可操作范围，当前提案尚未把角色边界固化为验收约束。
- 当前库中 `master.msg_notice_publish = 0`，仍缺少真实业务数据验证结论。

## Impact

- OpenSpec
  - `openspec/changes/notice-announcement/.openspec.yaml`
  - `openspec/changes/notice-announcement/proposal.md`
  - `openspec/changes/notice-announcement/design.md`
  - `openspec/changes/notice-announcement/tasks.md`
  - `openspec/changes/notice-announcement/issues.md`
  - `openspec/changes/notice-announcement/specs/notice_announcement/spec.md`
- SQL
  - `openspec/changes/notice-announcement/sql/tables/base_msg_notice_publish.sql`
  - `openspec/changes/notice-announcement/sql/sequences/base_sequences.sql`
  - `openspec/changes/notice-announcement/sql/indexes/base_indexes.sql`
  - `openspec/changes/notice-announcement/sql/menu/base_menu.sql`
  - `openspec/changes/notice-announcement/sql/dict/base_dict.sql`
- Backend
  - `construction-material-backend/hny-modules/hny-system/**/MsgNoticePublish*`
- Frontend
  - `construction-material-web/src/views/notice/**`
  - `construction-material-web/src/components/Notice/index.vue`
