## Why

当前 `message-center-notice` 变更同时包含“消息中心”和“通知公告”两块能力，范围过大，不利于独立评审、实施和归档。

其中：

- 消息中心已经切换为基于 `test` 旧消息表迁移后的模型实现
- 通知公告仍然保持 `master.msg_notice_publish` 独立模型

这两部分在数据模型、菜单权限、字典和实现路径上都相互独立，继续放在同一个 OpenSpec 变更里会造成边界不清。

因此，本次调整将“通知公告”从原变更中拆分为独立提案，便于后续单独跟踪。

## What Changes

- 新建独立变更 `notice-announcement`
- 承接原 `message-center-notice` 中与通知公告相关的规格、SQL 和元数据
- 保持通知公告模块既有设计不变，仍使用：
  - `master.msg_notice_publish`
- 保持现有菜单结构：
  - `通知公告`
  - `系统公告`
  - `库存信息发布`
  - `采购信息发布`

## Capabilities

### Notice Announcement

- 系统公告
- 库存信息发布
- 采购信息发布

本次主要是提案拆分，不改变通知公告的业务范围。

## Manual Alignment

对照《青岛市建设工程材料信息管理平台操作手册》，当前实现与手册仍存在以下偏差，需作为本提案后续补齐事项：

- 企业侧“系统公告”在手册中为只读查看能力，当前实现仍开放新增、编辑、删除。
- “库存信息发布 / 采购信息发布”在手册中应先保存草稿，再执行发布；当前实现默认直接发布。
- 手册要求库存/采购发布基于当前登录角色直接发布，不需要手工选择所属企业；当前实现仍要求选择 `companyId/companyName`。
- 手册按角色区分可见与可操作范围，当前提案仅描述了统一菜单结构，尚未把角色边界固化为需求约束。

## Impact

- OpenSpec
  - `openspec/changes/notice-announcement/.openspec.yaml`
  - `openspec/changes/notice-announcement/proposal.md`
  - `openspec/changes/notice-announcement/design.md`
  - `openspec/changes/notice-announcement/tasks.md`
  - `openspec/changes/notice-announcement/specs/notice_announcement/spec.md`
- SQL
  - `openspec/changes/notice-announcement/sql/tables/base_msg_notice_publish.sql`
  - `openspec/changes/notice-announcement/sql/sequences/base_sequences.sql`
  - `openspec/changes/notice-announcement/sql/indexes/base_indexes.sql`
  - `openspec/changes/notice-announcement/sql/menu/base_menu.sql`
  - `openspec/changes/notice-announcement/sql/dict/base_dict.sql`
