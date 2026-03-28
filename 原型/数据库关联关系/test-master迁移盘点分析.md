# test 与 master 迁移盘点分析

## 1. 适用范围

本次分析只关注迁移清单中列出的功能模块，不再展开无关扩展模块。

聚焦模块包括：

- 基础数据：生产企业、代理商、施工企业
- 组织、部门、岗位管理
- 角色与权限管理
- 账号信息及登录
- 工程项目
- 备案产品信息管理
- 施工企业填报建材数据
- 代理商、生产企业审核
- 消息提醒及通知公告
- 预警信息
- 质量追溯
- 统计分析
- 数据大屏
- 单点登录
- 数据共享
- 工程造价信息查询

## 2. 迁移规则

本次盘点统一按 `E:\construction-material\openspec\rules\database-rules.md` 的规则理解迁移目标。

### 2.1 两类迁移方式

#### 第一类：master 已有承载表

如果 `master` 下已经有现成承载表，且该表就是当前项目目标模型，则应将 `test` 下旧表数据按规则映射迁入 `master` 现有表。

这一类不是“原表直接复制”，而是“按字段映射规则迁入现有目标表”。

典型例子：

- `base_user -> sys_user`
- `base_organize -> sys_dept`
- `base_position -> sys_post`
- `base_module -> sys_menu`
- `base_dictionarytype -> sys_dict_type`
- `base_dictionarydata -> sys_dict_data`
- `base_province -> base_region`

#### 第二类：master 没有承载表

如果迁移清单对应的业务表在 `test` 中存在，而 `master` 下没有对应承载表，则应直接在 `master` 中建立该业务表，并从 `test` 迁入。

这类迁移应保留旧业务表语义，不应新建无关替代表。

典型例子：

- `test.t_project -> master.t_project`
- `test.t_quality_trace -> master.t_quality_trace`

## 3. 当前数据库现状

数据库：

- 库名：`building_supplies_supervision`
- 旧系统 schema：`test`
- 当前项目 schema：`master`

当前项目默认数据源已指向 `master`。

数据库核查后可确认：

- `master` 中已存在系统底座表：`sys_user`、`sys_role`、`sys_dept`、`sys_post`、`sys_menu`、`sys_dict_type`、`sys_dict_data`
- `master` 中已存在部分业务表：`t_companyinfo`、`t_record_product`、`t_project_product`
- `master` 中不存在：`t_project`、`t_quality_trace`
- `master` 中存在错误替代表：`mat_project`、`mat_record`
- `master` 中不存在 `mat_product`，而正确业务表应是 `t_project_product`

## 4. 功能模块逐项判断

### 4.1 企业基础数据

相关表：

- 旧系统：`test.t_companyinfo`
- 当前表：`master.t_companyinfo`

数据量：

- `test.t_companyinfo`：4988
- `master.t_companyinfo`：4988

结论：

- 这一块已经按正确方向迁移
- `t_companyinfo` 属于应保留业务表
- 不需要再新建设计替代表

### 4.2 用户、组织、岗位、角色、菜单、字典、行政区划

这一类不应保留 `test` 下的原系统表结构，而应映射到 `master` 已有承载表。

建议映射如下：

- `base_user -> sys_user`
- `base_organize -> sys_dept`
- `base_position -> sys_post`
- 角色与授权数据综合迁入 `sys_role`、`sys_user_role`、`sys_role_menu`
- `base_module -> sys_menu`
- `base_dictionarytype -> sys_dict_type`
- `base_dictionarydata -> sys_dict_data`
- `base_province -> base_region`

说明：

- 行政区划在 `master` 中已确认只有 `base_region`，没有 `sys_region`
- 因此行政区划应迁入 `master.base_region`
- 这类模块应严格按 `database-rules.md` 做字段重命名、审计字段补齐、默认值补齐

### 4.3 工程项目

当前情况：

- 旧系统业务表：`test.t_project`
- 当前错误替代表：`master.mat_project`
- 正确目标表：`master.t_project`

数据量：

- `test.t_project`：3746
- `master.mat_project`：1
- `master.t_project`：不存在

结论：

- `master.mat_project` 不应继续使用，应删除
- 正确做法是建立 `master.t_project`
- 然后执行 `test.t_project -> master.t_project`

### 4.4 备案产品

当前情况：

- 旧系统业务表：`test.t_record_product`
- 当前正确承载表：`master.t_record_product`
- 当前错误替代表：`master.mat_record`

数据量：

- `test.t_record_product`：6716
- `master.t_record_product`：6608
- `master.mat_record`：12

结论：

- 正确目标应是 `master.t_record_product`
- `master.mat_record` 不应继续保留，应删除
- 当前 `t_record_product` 已迁一部分，但数据不完整

### 4.5 建材填报

这里需要纠正此前判断。

正确业务表不是 `t_product_relation`，而是：

- 旧系统业务表：`test.t_project_product`
- 当前正确承载表：`master.t_project_product`

数据库核查结果：

- `test.t_project_product`：60962
- `master.t_project_product`：60962

结论：

- 建材填报对应表应认定为 `t_project_product`
- 这一块业务表本身已经在 `master` 中存在，且数量与 `test` 一致
- 当前代码里如果仍围绕 `mat_product` 建模，则方向错误，应回调到 `t_project_product`

需要特别说明：

- `t_product_relation` 不是建材填报主表
- `t_product_relation` 更像是“建材填报数据与检测数据的关联中间表”
- 不应把它当成建材填报主数据表

### 4.6 代理商、生产企业审核

该功能依附于建材填报主表。

正确数据基础应是：

- `t_project_product`

结论：

- 审核流应围绕 `t_project_product` 设计
- 不应围绕 `mat_product`

### 4.7 质量追溯

当前情况：

- 旧系统业务表：`test.t_quality_trace`
- 正确目标表：`master.t_quality_trace`

数据量：

- `test.t_quality_trace`：616
- `master.t_quality_trace`：不存在

结论：

- 质量追溯应直接迁移 `t_quality_trace`
- 当前尚未开始正确迁移

### 4.8 消息中心与通知公告

旧系统相关表：

- `test.t_message`
- `test.base_message`
- `test.base_messagereceive`

当前 `master` 中已有：

- `sys_menu`
- `sys_dict_type`
- `sys_dict_data`
- `sys_notice`

判断：

- “系统公告”可以研究是否映射到 `sys_notice`
- 但“发送消息 / 消息查看 / 预警信息”在 `master` 中没有明显等价承载表
- 因此这部分不能简单判定为已迁移
- 需要区分：
  - 公告类：研究映射到 `sys_notice`
  - 消息中心类：可能仍需保留旧表结构迁入 `master`

## 5. 迁移清单相关表的关联关系核对

本节只核对迁移清单涉及的表关系，并对 `openspec/原型/数据库关联关系` 现有文档进行纠偏。

### 5.1 已验证正确的关系

#### 1. `t_project_product.F_ProjectId -> t_project.F_Id`

核查结果：

- `t_project_product` 总量：60962
- 匹配到 `t_project`：60962

结论：

- 该关系正确
- 建材填报主表与工程项目是一对多关系

#### 2. `t_project.F_ConstructionPermitNo -> jck_t_gc_sgxkz.sgxkz_zh`

核查结果：

- `t_project` 中共有 3746 条项目
- 存在大量许可编号能匹配到 `jck_t_gc_sgxkz`

结论：

- 该关系基本成立
- 但 `jck_t_gc_sgxkz.sgxkz_zh` 在源数据里不是严格唯一键
- 应将其视为业务关联字段，而不是强外键

#### 3. `t_project_product.F_ManufacturerId -> t_companyinfo.F_Id`

核查结果：

- `t_project_product` 共 60962 条
- 匹配 `t_companyinfo`：60957

结论：

- 该关系强成立
- 生产企业优先关联 `t_companyinfo`

#### 4. `t_project_product.F_SupplierId -> t_companyinfo.F_Id`

核查结果：

- `t_project_product` 共 60962 条
- 匹配 `t_companyinfo`：43758

结论：

- 该关系成立，但不是所有记录都有供应商
- 与业务描述一致：部分产品可能直供，无供应商

### 5.2 需要纠正的关系

#### 1. `t_quality_trace.F_OriginalId -> t_project_product.F_Id`

核查结果：

- `t_quality_trace` 共 616 条
- 匹配 `t_project_product`：0
- 样本中 `F_OriginalId` 基本为空

结论：

- 现有文档中把这条关系当成核心关系是错误的
- 当前库里 `t_quality_trace` 并未真实通过 `F_OriginalId` 关联 `t_project_product`
- 质量追溯当前更像是独立导入数据表，而不是严格的建材填报从表

#### 2. `t_project_product.F_ManufacturerId -> jck_qyk_qyjcxx.qywybs`

核查结果：

- 匹配数：0

结论：

- 现有文档将其作为主要关联关系是错误的
- 实际上应优先认定为关联 `t_companyinfo`

#### 3. `t_record_product.F_SocialCreditCode -> jck_qyk_qyjcxx.qyshtyxydm`

核查结果：

- 匹配数：0

结论：

- 现有文档中该关系不成立
- 至少在当前 test 数据中，不能作为有效关联规则使用

#### 4. `t_record_product.F_RecordNo` 唯一

核查结果：

- 存在重复备案号

结论：

- 现有文档将 `F_RecordNo` 视为严格唯一值并不准确
- 业务上它应当是备案号
- 但当前源数据存在重复，迁移时要先清洗或定义去重规则

### 5.3 关于 `t_product_relation` 的正确定位

表结构：

- `F_Id`
- `F_ProductId`
- `F_CheckProductId`
- `F_Status`

结论：

- `t_product_relation` 不是建材填报主表
- 它更像是“项目建材产品”和“检测/追溯数据”的关系表
- 当前应将其归入质量追溯辅助关系，而不是建材填报主数据

补充核查结果：
- `t_product_relation.F_ProductId -> t_project_product.F_Id` 在现有 `test` 数据中 1058/1058 全量命中
- `t_product_relation.F_CheckProductId -> t_quality_trace.F_Id` 在现有 `test` 数据中命中数为 0
- `t_product_relation.F_CheckProductId -> t_quality_trace.F_OriginalId` 在现有 `test` 数据中命中数也为 0

因此应修正为：
- 从表结构命名和原型意图看，`t_product_relation` 的设计目标仍然是“产品与质量追溯数据关系表”
- 但从当前真实库数据看，这条到 `t_quality_trace` 的关系并未落实
- 现阶段不能把 `t_product_relation -> t_quality_trace` 当作已经被数据验证成立的关系，只能视为“设计意图存在、源数据未兑现”

## 6. 对现有分析文档的判断

### 6.1 `0.数据表关系.md`

可保留的判断：

- `t_project_product -> t_project`
- `t_record_product -> t_project_product` 通过 `F_RecordNo` 发生业务关联
- `t_companyinfo` 是企业主体表

需要纠正的判断：

- 不应再把 `t_product_relation` 当作建材填报主表
- 不应把 `t_quality_trace.F_OriginalId -> t_project_product.F_Id` 认定为已成立
- 不应把 `F_ManufacturerId` 的主关联目标写成 `jck_qyk_qyjcxx`
- 不应把 `F_SocialCreditCode -> jck_qyk_qyjcxx.qyshtyxydm` 认定为已成立
- 不应把 `F_RecordNo` 认定为严格唯一

### 6.2 `1.备案产品和建材产品表.md`

可保留的判断：

- `t_record_product` 和 `t_project_product` 的业务关联字段是 `F_RecordNo`
- 业务含义上，备案产品是主数据，项目建材产品是使用数据

需要纠正的判断：

- 不能将 `F_RecordNo` 认定为严格唯一
- 因为源数据存在重复备案号，所以“严格 1:N”应改写为“业务意图为 1:N，实际数据存在重复，需要清洗”

### 6.3 `已确定数据表.md`

需要纠正：

- 建材填报主表应写为 `t_project_product`
- `t_product_relation` 不能作为建材填报主表
- 系统模块迁移应补充“映射到 master 现有表”规则，而不是简单保留旧表

### 6.4 `消息中心和通知公告.md`

可保留的判断：

- `t_message` 用于企业端发送消息
- `base_message` / `base_messagereceive` 用于系统消息和接收

需要补充：

- “系统公告”可研究映射到 `master.sys_notice`
- “消息中心 / 预警信息”目前在 `master` 中没有明显等价表，不能直接判定为已有承载

### 6.5 `质量追溯/质量追溯.md`

可保留的判断：
- `t_quality_trace` 是质量追溯核心表
- `t_product_relation` 的业务意图是作为产品与追溯数据的关联表
- “缺陷建材使用情况”页面应围绕 `t_project_product`、`t_project`、`t_quality_trace` 三类数据组织

需要纠正的判断：
- 不应再把 `t_product_relation.F_CheckProductId -> t_quality_trace.F_Id` 认定为已被真实数据验证
- 不应再把“缺陷建材使用情况页面分析”写成已经完全确认的物理关联链路
- 更准确的写法应为：
  - 页面目标链路设计上是 `t_quality_trace -> t_product_relation -> t_project_product -> t_project`
  - 但当前 `test` 库中只验证了 `t_product_relation -> t_project_product`
  - `t_product_relation -> t_quality_trace` 尚未在真实数据中命中，后续迁移时需要重新确认来源规则或补数规则

## 7. 迁移结论

### 7.1 已按正确方向迁移或已具备承载基础

- 企业基础数据：`t_companyinfo`
- 建材填报主表：`t_project_product`
- 系统底座：`sys_user`、`sys_role`、`sys_dept`、`sys_post`、`sys_menu`、`sys_dict_type`、`sys_dict_data`
- 行政区划承载表：`base_region`

### 7.2 方向错误，需要纠偏

- `master.mat_project`：应删除，改为 `master.t_project`
- `master.mat_record`：应删除，改为 `master.t_record_product`
- `mat_product` 方案：应放弃，建材填报应统一到 `t_project_product`

### 7.3 尚未完成正确迁移

- `test.t_project -> master.t_project`
- `test.t_record_product -> master.t_record_product` 差异数据补齐
- `test.t_quality_trace -> master.t_quality_trace`
- 消息中心与预警相关表的最终承载方案

## 8. 建议的实施顺序

1. 删除错误替代表：`mat_project`、`mat_record`
2. 确定系统表映射方案：`base_* -> sys_* / base_region`
3. 建立 `master.t_project`
4. 执行 `test.t_project -> master.t_project`
5. 补齐 `test.t_record_product -> master.t_record_product`
6. 建立 `master.t_quality_trace`
7. 执行 `test.t_quality_trace -> master.t_quality_trace`
8. 修正代码：工程项目改回 `t_project`，备案产品改回 `t_record_product`，建材填报统一围绕 `t_project_product`
9. 再补审核流、消息提醒、预警、统计分析、质量追溯闭环

## 9. 下一步建议

建议继续补两份执行文档：

1. `test -> master` 字段映射文档
   - `t_project`
   - `t_record_product`
   - `t_quality_trace`
   - `base_user / base_organize / base_position / base_module / base_dictionary* / base_province`

2. 代码回调清单
   - 哪些接口、页面、SQL 还在用 `mat_project`
   - 哪些接口、页面、SQL 还在用 `mat_record`
   - 哪些地方需要从 `mat_product` 改回 `t_project_product`

这样才能把“盘点分析”进一步落成“可执行迁移方案”。
