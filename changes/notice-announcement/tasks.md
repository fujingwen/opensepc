## 1. OpenSpec

- [x] 1.1 从混合提案中拆分通知公告能力
- [x] 1.2 新建独立 `notice-announcement` 提案
- [x] 1.3 迁移通知公告规格
- [x] 1.4 回写系统公告只读、草稿发布流转与当前业务边界
- [x] 1.5 同步“采购/库存不再选择企业、发布后按角色统一可见”的最新规则

## 2. SQL

- [x] 2.1 迁移 `msg_notice_publish` DDL
- [x] 2.2 迁移通知公告索引 SQL
- [x] 2.3 迁移通知公告菜单 SQL
- [x] 2.4 迁移通知公告字典 SQL
- [x] 2.5 迁移通知公告 sequence SQL
- [x] 2.6 补充 `msg_publish_status=draft` 字典初始化脚本

## 3. Backend

- [x] 3.1 在当前模块内禁止新增、编辑、删除 `system` 类型公告
- [x] 3.2 支持库存/采购公告保存草稿与发布
- [x] 3.3 取消 `purchase/inventory` 对 `companyId/companyName` 的强制校验
- [x] 3.4 按当前业务规则开放已发布公告查看范围
- [x] 3.5 允许发布人本人继续查看和维护自己创建的草稿
- [x] 3.6 放开超级管理员、租户管理员对采购/库存公告的维护限制
- [x] 3.7 将公告发布后的站内消息发送改为异步批量落库

## 4. Frontend

- [x] 4.1 系统公告页面改为只读查看
- [x] 4.2 库存/采购页面支持“保存草稿”与“发布”
- [x] 4.3 移除库存/采购页面的企业选择配置
- [x] 4.4 按当前规则保留列表、详情、草稿编辑交互
- [x] 4.5 在采购/库存公告列表与详情页展示发布人

## 5. Validation

- [x] 5.1 校验新提案仅包含通知公告内容
- [x] 5.2 校验提案、设计、规格与当前业务口径一致
- [x] 5.3 `openspec validate notice-announcement` 通过
- [x] 5.4 `hny-system` 模块编译通过
- [x] 5.5 补充真实公告发布数据验证结论
  结论：基于 `backups/kingbase_building_supplies_supervision_master_20260407_145309.sql` 核查，`master.msg_notice_publish` 在 2026-04-07 14:53:09 的备份中仍为空表，当前无历史业务样本可供验证。
