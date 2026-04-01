# 企业信息管理功能规格

- **模块名称**: `base_companyinfo`
- **模块说明**: 基于 `t_companyinfo` 统一管理施工企业、生产企业、代理商三类企业信息，并向前端返回可直接消费的企业名称、联系人、地区名称及代理关系字段

## ADDED Requirements

### Requirement: 施工企业与生产企业查询结果必须返回页面所需字段
系统 SHALL 在施工企业和生产企业的列表、详情查询中返回页面直接使用的字段。

#### Scenario: 返回企业名称与联系人
- **GIVEN** 用户查询施工企业或生产企业列表、详情
- **WHEN** 后端从 `t_companyinfo` 查询到记录
- **THEN** 接口返回中必须包含 `enterpriseName`
- **AND** `enterpriseName` 的值来源于 `t_companyinfo.company_name`
- **AND** 接口返回中必须包含 `contactPerson`
- **AND** `contactPerson` 的值来源于 `t_companyinfo.contact_user`

### Requirement: 地区字段必须转换为中文名称
系统 SHALL 将企业信息中的地区 ID 转换为可展示的中文名称。

#### Scenario: area 存储地区 ID 数组
- **GIVEN** 企业记录中的 `area` 为 `["37","3706","370681"]` 这类字符串
- **WHEN** 用户查询列表或详情
- **THEN** 后端必须按 ID 关联 `base_province` 表
- **AND** 通过 `base_province.full_name` 获取省、市、区名称
- **AND** 接口返回 `provinceCode`、`cityCode`、`districtCode`
- **AND** 接口返回 `provinceName`、`cityName`、`districtName`
- **AND** 接口返回 `region`
- **AND** `region` 格式为 `省/市/区`

#### Scenario: 地区名称回显
- **GIVEN** 用户打开施工企业、生产企业或代理商编辑页
- **WHEN** 后端返回企业详情
- **THEN** 接口必须返回完整的 `provinceCode/provinceName/cityCode/cityName/districtCode/districtName`
- **AND** 前端能够基于这些字段完成地区组件回显

### Requirement: 联系电话必须支持手机号和座机号
系统 SHALL 在前后端同时校验联系电话格式，并支持手机号和座机号。

#### Scenario: 录入手机号
- **WHEN** 用户输入合法手机号
- **THEN** 前端校验通过
- **AND** 后端校验通过

#### Scenario: 录入座机号
- **WHEN** 用户输入合法座机号
- **THEN** 前端校验通过
- **AND** 后端校验通过

#### Scenario: 录入非法电话
- **WHEN** 用户输入既不是手机号也不是座机号的值
- **THEN** 前端应提示格式错误
- **AND** 后端应拒绝保存

### Requirement: 代理商查询结果必须同时返回所属生产企业和代理商名称
系统 SHALL 在代理商场景下区分“所属生产企业名称”和“代理商名称”。

#### Scenario: 代理商列表返回字段
- **GIVEN** 用户查询代理商列表
- **WHEN** 后端从 `t_companyinfo` 查询 `company_type = 3` 的记录
- **THEN** 接口返回中必须包含 `agentName`
- **AND** `agentName` 的值来源于代理商记录的 `company_name`
- **AND** 接口返回中必须包含 `enterpriseName`
- **AND** `enterpriseName` 的值来源于代理商记录 `parent_id` 对应的生产企业 `company_name`

#### Scenario: 代理商详情返回字段
- **GIVEN** 用户查看或编辑代理商详情
- **WHEN** 后端返回代理商详情数据
- **THEN** 接口必须返回 `productionId`
- **AND** `productionId` 的值来源于代理商记录的 `parent_id`
- **AND** 接口必须返回 `enterpriseName` 作为所属生产企业名称
- **AND** 接口必须返回 `agentName` 作为代理商名称

### Requirement: 代理商查询条件必须支持代理商名称
系统 SHALL 支持通过代理商名称查询代理商列表。

#### Scenario: 按代理商名称查询
- **GIVEN** 用户在代理商页面输入代理商名称关键字
- **WHEN** 用户发起查询
- **THEN** 后端必须按代理商记录的 `company_name` 执行模糊匹配
- **AND** 查询结果继续返回所属生产企业名称与代理商名称

## Modified Requirements

### Requirement: 企业信息视图对象字段语义
系统 SHALL 统一企业信息接口的视图字段语义。

#### Scenario: 普通企业页面字段语义
- **GIVEN** 当前页面为施工企业或生产企业页面
- **WHEN** 接口返回 `enterpriseName`
- **THEN** `enterpriseName` 表示企业自身名称

#### Scenario: 代理商页面字段语义
- **GIVEN** 当前页面为代理商页面
- **WHEN** 接口返回 `enterpriseName`
- **THEN** `enterpriseName` 表示所属生产企业名称
- **AND** `agentName` 表示代理商自身名称

### Requirement: 企业信息写入时地区字段组装
系统 SHALL 在新增和编辑企业信息时按省市区编码组装地区存储值。

#### Scenario: 新增或编辑企业
- **GIVEN** 用户提交 `provinceCode/cityCode/districtCode`
- **WHEN** 后端保存企业信息
- **THEN** 后端应将三段地区编码组装回 `area`
- **AND** 后续查询仍可根据 `area` 正确反查地区中文名称

### Requirement: 历史 del_flag 空值数据必须标准化
系统 SHALL 将 `t_companyinfo` 中 `del_flag is null` 的历史数据标准化为 `0`。

#### Scenario: 修复历史数据
- **GIVEN** `t_companyinfo` 中存在 `del_flag is null` 的记录
- **WHEN** 执行数据库修复脚本
- **THEN** 这些记录的 `del_flag` 应更新为 `0`
