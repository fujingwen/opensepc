## 1. OpenSpec

- [x] 1.1 复核 `test` 旧消息表结构与数据分布
- [x] 1.2 将提案中的消息表方案从 `msg_message/msg_message_user` 改为迁移模型
- [x] 1.3 更新 `design.md`
- [x] 1.4 更新 `specs/message_center/spec.md`
- [x] 1.5 更新 `issues.md`

## 2. SQL

- [x] 2.1 调整消息表 DDL 为 `base_message`
- [x] 2.2 调整消息收件表 DDL 为 `base_message_receive`
- [x] 2.3 新增 `base_message_template` DDL
- [x] 2.4 新增 `sql/migrate` 迁移脚本
- [x] 2.5 更新消息相关索引
- [x] 2.6 清理已过时的 `msg_message/msg_message_user` 提案 SQL
- [x] 2.7 补充 `master.msg_message/msg_message_user -> base_*` 兼容迁移

## 3. Backend

- [x] 3.1 系统消息模块改为基于迁移后的表模型
- [x] 3.2 保持消息中心接口路径不变
- [x] 3.3 建材产品业务提醒改为直接写 `base_message_receive`
- [ ] 3.4 视需要补充消息模板运行时支持

## 4. Frontend

- [x] 4.1 保持消息中心前端 API 不变
- [x] 4.2 保持发送/查看/预警页面结构不变
- [ ] 4.3 如字典调整，补充页面兼容验证

## 5. Validation

- [x] 5.1 校验 Mapper / Entity / Service 字段一致性
- [x] 5.2 校验建材产品提醒链路
- [x] 5.3 校验提案、SQL、代码三者一致
