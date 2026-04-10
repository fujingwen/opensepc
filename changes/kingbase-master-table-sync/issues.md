# Kingbase Master 缺表补齐问题记录

## 审查时间

- 2026-04-10

## 已完成事项

1. ~~金仓开发库 `master` schema 中原提案提到的 6 张缺失表现已全部存在：`base_message`、`base_message_receive`、`base_message_template`、`sys_dict_type`、`sys_logininfor`、`t_product_relation`。~~
2. ~~`base_message`、`base_message_receive`、`base_message_template`、`t_product_relation` 的主键与索引结构已与 PostgreSQL 源库对齐；`sys_dict_type`、`sys_logininfor` 的约束现状也与源库保持一致。~~
3. ~~`t_product_relation` 在金仓开发库中的行数已与 PostgreSQL 源库一致，均为 1058。~~

## 未完成问题

1. proposal/design/tasks 仍按“金仓缺表、待迁移”的状态书写，已经落后于当前数据库现实，需要整体回写为“缺表已补齐、进入验收与收尾阶段”。
2. `base_message`、`base_message_receive`、`sys_logininfor` 属于运行期持续写入表，当前金仓开发库行数已分别为 `26 / 185493 / 2537`，不再与 PostgreSQL 源库的 `22 / 177258 / 2444` 保持完全一致；原提案中“持续逐表等量对齐”的验收口径已不适合作为长期标准。
3. 迁移后链路验证结论尚未回写到 change 文档，当前仍缺少“消息中心 / 字典类型 / 登录日志 / 质量追溯”四条链路的收尾记录。

## 数据库核对

1. PostgreSQL 源库计数：`base_message=22`、`base_message_receive=177258`、`base_message_template=0`、`sys_dict_type=152`、`sys_logininfor=2444`、`t_product_relation=1058`。
2. 金仓开发库计数：`base_message=26`、`base_message_receive=185493`、`base_message_template=0`、`sys_dict_type=152`、`sys_logininfor=2537`、`t_product_relation=1058`。
3. 金仓开发库当前可查到的索引/约束与 PostgreSQL 源库一致：
   - `base_message`：主键 + `sender_id/message_type/send_time/del_flag` 索引
   - `base_message_receive`：主键 + `message_id/receiver_user_id/message_type/business_type/send_time/del_flag` 索引
   - `base_message_template`：主键
   - `sys_dict_type`：`dict_id` 唯一键
   - `sys_logininfor`：当前与源库一致，均未定义主键
   - `t_product_relation`：主键 + `product_id/quality_trace_id/hidden_flag` 索引
