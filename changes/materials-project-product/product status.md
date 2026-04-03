# 建材产品信息确认状态流转

## 状态定义

- `0` 待信息确认
- `1` 信息确认通过
- `2` 信息确认不通过
- `3` 待再次信息确认
- `4` 信息确认再次不通过

补充字段：

- `supplier_check_status`
  - 有代理商时用于代理商确认状态
  - 首轮：`0/1/2`
  - 二轮：`3/4`
- `send_flag`
  - 当前沿用既有字段，发送通知时置为 `1`

## 流转规则

### 1. 首次新增

- 未选择代理商：
  - `check_status = 0`
  - `supplier_check_status = null`
  - 直接通知生产单位确认
- 已选择代理商：
  - `check_status = 0`
  - `supplier_check_status = 0`
  - 先通知代理商确认

### 2. 代理商确认

- 仅在存在代理商且 `supplier_check_status` 为 `0/3` 时可操作
- 代理商通过：
  - 首轮：`supplier_check_status = 1`，`check_status = 0`
  - 二轮：`supplier_check_status = 1`，`check_status = 3`
  - 然后通知生产单位确认
- 代理商不通过：
  - 首轮：`check_status = 2`，`supplier_check_status = 2`
  - 二轮：`check_status = 4`，`supplier_check_status = 4`

### 3. 生产单位确认

- 无代理商时，`check_status` 为 `0/3` 即可确认
- 有代理商时，必须先满足 `supplier_check_status = 1`
- 生产单位通过：
  - `check_status = 1`
- 生产单位不通过：
  - 首轮：`check_status = 2`
  - 二轮：`check_status = 4`

### 4. 驳回后重提

- 仅 `check_status = 2` 允许编辑后重提
- 重提后：
  - 无代理商：`check_status = 3`，通知生产单位再次确认
  - 有代理商：`check_status = 3`，`supplier_check_status = 3`，先通知代理商再次确认

### 5. 二次驳回锁定

- `check_status = 4` 后禁止再次编辑

## 前端展示规则

- 有代理商且代理商仍待处理时，表格状态文案显示为“待代理商信息确认”
- 其余场景继续按 `info_confirm_status` 字典显示
- 若处于代理商待处理阶段，且距 `update_time` 或 `create_time` 超过 48 小时，则追加“超48小时”标记

## 当前实现说明

- 新增、重提后会自动发送站内消息到下一审核方
- 审核接口为 `/materials/product/audit`
- 当前审核权限通过“当前登录用户是否匹配企业关联用户名/昵称”判断
