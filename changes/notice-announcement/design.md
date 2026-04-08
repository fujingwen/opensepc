## Context

通知公告模块与消息中心同属“消息通知”大类，但运行时数据模型独立：

- 通知公告使用 `master.msg_notice_publish`
- 消息中心使用消息主表和收件箱模型

因此通知公告应以独立提案维护，避免和消息中心迁移设计耦合。

## Goals

- 将通知公告从混合提案中拆分出来，形成独立 OpenSpec 变更
- 将企业侧 `系统公告` 收口为只读查看
- 为 `库存信息发布`、`采购信息发布` 增加 `草稿 -> 发布` 流转
- 减少库存/采购发布时重复手工选择企业的操作

## Non-Goals

- 本次不调整 `msg_notice_publish` 主表归属
- 本次不重做菜单结构
- 本次不在后端实现完整的“按登录主体自动回填企业”强约束
- 本次不补真实业务数据初始化

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

## Business Rules

### 1. 公告类型

- `system`
  - 企业侧页面只允许查询和查看
  - 当前模块禁止新增、编辑、删除
- `inventory`
  - 允许保存草稿
  - 允许发布
- `purchase`
  - 允许保存草稿
  - 允许发布

### 2. 发布状态

- `draft`
  - 草稿
  - 用于库存/采购发布在正式发布前的暂存状态
- `published`
  - 已发布
- `closed`
  - 已关闭

### 3. 企业上下文

- 库存信息发布要求生产企业上下文
- 采购信息发布要求施工企业上下文
- 当前阶段前端根据 `userStore.deptName` 匹配企业列表并自动锁定
- 后端仍保留 `company_id/company_name` 入参校验，后续再补登录主体强约束

## Interaction

### 系统公告

- 列表页只提供查询、查看
- 详情页只读展示标题、状态、发布时间、正文

### 库存信息发布 / 采购信息发布

- 列表页提供查询、新增、编辑、删除
- 表单页提供两个动作：
  - `保存草稿`
  - `发布`
- 草稿数据可以继续编辑后再发布

## Menu and Dict

- 菜单保留：
  - `通知公告`
  - `系统公告`
  - `库存信息发布`
  - `采购信息发布`
- 字典保留：
  - `msg_notice_type`
  - `msg_publish_status`
- `msg_publish_status` 需补充 `draft` 状态值

## Risks

1. 后端尚未按登录主体自动回填企业，仍存在前端匹配失败时需要手工选择的场景。
2. 角色边界尚未完全固化：
   - 生产单位：查看系统公告、发布库存信息、查看采购信息
   - 施工单位：查看系统公告、查看库存信息、发布采购信息
   - 代理商：仅查看系统公告
3. 当前库中尚无真实公告发布数据，仍缺少运行数据验证。
