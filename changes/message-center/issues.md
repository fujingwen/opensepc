# 消息中心问题记录

## 已确认问题

1. 原提案的数据模型设计使用 `master.msg_message` / `master.msg_message_user`，与旧系统真实消息模型不一致。
2. `test.base_messagereceive` 并不是简单的 `base_message` 从表，大量记录引用的是外部业务消息 ID。
3. `test.t_message` 与“发送消息”场景强相关，迁移时不能忽略。
4. 旧系统消息数据存在少量非纯数字用户标识，迁移 SQL 需要兼容映射。
5. 当前 `master.msg_message` / `master.msg_message_user` 已存在少量运行时数据，切换实现时不能直接丢失。

## 已修复问题

1. 发送消息页面新增时，选择接收人报错：
   - `Uncaught (in promise) ReferenceError: prop is not defined`
   - `Uncaught (in promise) TypeError: Cannot read properties of undefined (reading 'multiple')`
2. 点击消息查看页面直接报错：
   - `Uncaught (in promise) TypeError: Cannot destructure property 'type' of 'vnode' as it is null`

## 对照操作手册发现

以下问题为对照《青岛市建设工程材料信息管理平台操作手册》后新增确认，后续核对时请优先按“操作手册差异”处理：

1. 顶部铃铛未读数目前仍依赖前端本地状态，未与真实消息/公告数据联动；操作手册要求右上角消息提醒能够反映真实未读数量。
2. 业务类消息点击后应按业务类型跳转到对应页面；操作手册中的材料审核类消息应能跳转到建材产品列表或对应业务页面，当前实现仍统一停留在详情弹窗。
3. 新发送的消息不会同步出现在右上角“通知公告”提醒区域，和操作手册中“消息提醒统一入口”的使用方式不一致。

## 当前结论

1. 消息中心运行时表已调整为：
   - `master.base_message`
   - `master.base_message_receive`
   - `master.base_message_template`
2. 人工发送消息使用：
   - 主表 `base_message`
   - 收件表 `base_message_receive`
3. 业务自动提醒直接写入：
   - `base_message_receive`
4. `test.t_message` 历史数据迁移时并入新的人工消息模型，不再保留独立运行时表。

## 备注

1. 本文件中带“对照操作手册发现”的条目，均为按操作手册逐项比对后新增的问题来源标记。
2. 后续如果相关问题修复完成，建议保留“对照操作手册发现”标签，仅将状态改为“已修复”，方便复核。
