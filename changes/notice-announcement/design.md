## Context

通知公告模块与消息中心同属“消息通知”大类，但运行时数据模型独立：

- 通知公告使用 `master.msg_notice_publish`
- 消息中心使用消息主表和收件箱模型

因此通知公告应以独立提案维护，避免和消息中心迁移设计耦合。

## Goals

- 将通知公告从混合提案中拆分出来，形成独立 OpenSpec 变更
- 保持现有数据模型、菜单结构、字典设计不变

## Non-Goals

- 本次不调整通知公告的业务流程
- 本次不修改通知公告的数据表结构
- 本次不改动前后端实现

## Data Model

### `master.msg_notice_publish`

用途：

- 存储系统公告
- 存储库存信息发布
- 存储采购信息发布

核心字段：

- `id`
- `notice_type`
- `title`
- `content`
- `publisher_user_id`
- `publisher_name`
- `company_id`
- `company_name`
- `publish_status`
- `publish_time`
- `create_dept/create_by/create_time/update_by/update_time`
- `del_flag`

## Menu and Dict

- 菜单保留：
  - `通知公告`
  - `系统公告`
  - `库存信息发布`
  - `采购信息发布`
- 字典保留：
  - `msg_notice_type`
  - `msg_publish_status`

## Risks

1. 若后续继续将通知公告和消息中心放在同一变更维护，容易再次出现边界混淆
2. 菜单和字典 SQL 若不拆分，后续执行时容易误带入消息中心部分
