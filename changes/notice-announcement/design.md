## Context

通知公告模块与消息中心同属“消息通知”大类，但运行时数据模型独立：

- 通知公告使用 `master.msg_notice_publish`
- 消息中心使用消息主表和收件箱模型

当前通知公告能力已经继续演进，尤其是采购公告、库存公告的企业选择与查看范围已经从“按企业定向”调整为“按角色类型发布后统一可见”，因此需要把设计文档同步到最新业务口径。

## Goals

- 保持通知公告作为独立 OpenSpec 变更维护
- 明确系统公告在当前模块内只读查看
- 明确采购/库存公告支持“草稿 -> 发布”
- 明确采购/库存公告不再要求手工选择企业
- 明确采购/库存公告发布后的跨企业查看范围

## Non-Goals

- 本次不调整 `msg_notice_publish` 主表归属
- 本次不调整现有菜单树结构
- 本次不新增独立的公告受众关系表
- 本次不重构消息通知中心整体方案

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

说明：

- `company_id/company_name` 字段继续保留，用于兼容历史数据以及后续扩展
- 采购/库存公告在当前方案下允许为空，不再作为保存必填项

## Business Rules

### 1. 公告类型

- `system`
  - 当前模块只允许查询和查看
  - 不允许新增、编辑、删除
- `inventory`
  - 允许保存草稿
  - 允许发布
  - 由生产企业侧角色维护
  - 发布后所有施工企业可查看
- `purchase`
  - 允许保存草稿
  - 允许发布
  - 由施工企业侧角色维护
  - 发布后所有生产企业可查看

### 2. 发布状态

- `draft`
  - 草稿
  - 用于采购/库存公告正式发布前的暂存状态
- `published`
  - 已发布
- `closed`
  - 已关闭

### 3. 企业字段

- 采购公告和库存公告保存时不再要求前端选择企业
- 后端不再强制校验 `company_id/company_name`
- 发布人仍记录在 `publisher_user_id/publisher_name`
- 发布人本人可继续查看和维护自己创建的草稿，避免“保存后自己不可见”

### 4. 查看范围

- 系统公告
  - 有系统公告权限的用户可查询、查看
- 库存公告
  - 生产企业侧：可维护自己创建的草稿
  - 施工企业侧：可查看所有已发布库存公告
- 采购公告
  - 施工企业侧：可维护自己创建的草稿
  - 生产企业侧：可查看所有已发布采购公告

### 5. 编辑限制

- 系统公告在当前模块中不允许新增、编辑、删除
- 采购/库存公告在 `draft` 状态允许编辑、删除、发布
- 采购/库存公告在 `published` 状态不允许再次修改

## Interaction

### 系统公告

- 列表页只提供查询、查看
- 详情页只读展示标题、正文、发布时间、发布状态

### 库存信息发布 / 采购信息发布

- 列表页提供查询、新建、编辑草稿、删除草稿、查看详情
- 表单页提供两个动作：
  - `保存草稿`
  - `发布`
- 新建或编辑时只要求填写：
  - 标题
  - 内容
- 不再展示企业下拉选择项

## API Contract

### `POST /notice/publish`

- 用于新增公告
- `noticeType=inventory/purchase` 时：
  - `title` 必填
  - `content` 必填
  - `publishStatus` 允许为 `draft` 或 `published`
  - `companyId/companyName` 允许为空

### `PUT /notice/publish`

- 用于更新草稿公告或执行发布
- 已发布公告不允许再次修改

### `GET /notice/publish/list`

- 系统按 `noticeType` 和当前角色控制可见范围
- 已发布采购/库存公告按业务类型对对应受众角色开放

## Menu and Dict

- 菜单保留：
  - `通知公告`
  - `系统公告`
  - `库存信息发布`
  - `采购信息发布`
- 字典保留：
  - `msg_notice_type`
  - `msg_publish_status`
- `msg_publish_status` 包含 `draft`

## Risks

1. `company_id/company_name` 仍保留在表结构中，但当前业务已不再强依赖，需要避免后续代码重新引入“必填企业”的旧假设。
2. 采购/库存公告的可见范围依赖角色和发布状态组合判断，后续如果新增角色或菜单权限，需要同步评估权限边界。
3. 当前设计允许发布人查看自己草稿，但并未引入更细粒度的协同编辑机制，仍按“发布人本人维护草稿”处理。
