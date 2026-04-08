# 企业信息管理提案

## Why

系统已经基于 `t_companyinfo` 统一存储施工企业、生产企业、代理商三类企业信息，但当前企业信息管理接口与页面字段口径不一致，导致页面展示与编辑回显存在明显缺失：

- 企业列表和详情接口返回的 `enterpriseName`、`contactPerson` 为空
- 地区字段返回的是 `["37","3706","370681"]` 这类行政区划 ID 数组，前端无法直接展示中文名称
- 代理商页面缺少“所属生产企业”和“代理商名称”两个关键字段

这些问题会直接影响三个页面的列表展示、详情查看、编辑回显和下拉选择体验，因此需要将接口返回结构和字段语义补齐，并同步更新提案与规格，确保实现、联调和验收使用同一套定义。

## What Changes

- 继续使用 `t_companyinfo` 统一管理三类企业数据，通过 `company_type` 区分：
  - `company_type = 1`：施工企业
  - `company_type = 2`：生产企业
  - `company_type = 3`：代理商
- 明确企业信息接口返回字段语义：
  - 普通企业页面返回 `enterpriseName` 表示企业名称
  - 代理商页面返回 `enterpriseName` 表示所属生产企业名称
  - 代理商页面新增返回 `agentName` 表示代理商名称
  - 接口统一返回 `contactPerson` 作为联系人
- 明确地区字段返回规则：
  - `area` 允许继续存储地区 ID 数组字符串
  - 查询接口必须基于 `base_province` 表按 ID 关联 `full_name`
  - 返回 `provinceCode/provinceName/cityCode/cityName/districtCode/districtName`
  - 返回 `region`，格式为 `省/市/区`，例如 `山东省/青岛市/李沧区`
- 明确代理商与生产企业关系：
  - `parent_id` 存储所属生产企业 ID
  - 查询接口返回 `productionId`
  - 代理商列表、详情、编辑回显都必须能展示所属生产企业名称
- 保持新增企业时自动创建用户并分配角色的原有能力不变
- 当前默认密码继续按写死值 `Hny@2022` 处理，不在本轮改为配置项

### 账号与用户同步规则

- 新增施工企业、生产企业、代理商时，必须在落库前校验最终将写入 `sys_user.user_name` 的账号是否已存在，禁止出现两条相同 `user_name`
- 账号生成规则与自动创建用户保持一致：
  - 施工企业：`user_name = enterpriseName`
  - 生产企业：`user_name = enterpriseName`
  - 代理商：优先使用 `userAccount`；未填写时回退为代理商名称
- 若账号已存在，接口应直接拦截并返回明确提示，避免出现“企业数据新增成功但系统账号跳过创建”的半成功状态
- 删除施工企业、生产企业、代理商时，需要同步删除该企业关联的 `sys_user`、`sys_user_role`、`sys_user_post`、`sys_user_pw_history`
- 从用户管理删除企业账号时，也需要反向删除对应的 `t_companyinfo` 企业记录，保证企业主数据与账号数据一致

## Capabilities

### New Capabilities

- `base_companyinfo`：统一的企业信息管理能力
  - 施工企业管理
  - 生产企业管理
  - 代理商管理
- 企业信息查询结果组装能力
  - 字段别名转换：`company_name -> enterpriseName/agentName`
  - 联系人字段转换：`contact_user -> contactPerson`
  - 行政区划名称填充：`地区 ID -> 中文 full_name`
  - 代理商父企业名称回填：`parent_id -> enterpriseName`

### Modified Capabilities

- 企业信息接口返回结构从“数据库原始字段映射”调整为“页面可直接消费的视图对象”
- 地区展示从原始 ID 数组调整为中文展示串和拆分后的省市区字段
- 代理商页面的接口语义从单一企业名称调整为“所属生产企业名称 + 代理商名称”双字段模式

## Impact

### 后端

- `BaseCompanyInfoBo` 需要支持：
  - `provinceCode/provinceName/cityCode/cityName/districtCode/districtName`
  - `productionId`
  - `agentName`
- `BaseCompanyInfoVo` 需要支持：
  - `enterpriseName`
  - `contactPerson`
  - `provinceCode/provinceName/cityCode/cityName/districtCode/districtName`
  - `region`
  - `productionId`
  - `agentName`
- `BaseCompanyInfoServiceImpl` 需要在查询结果装配阶段：
  - 回填企业名称与联系人
  - 解析 `area`
  - 关联 `base_province.full_name`
  - 组装代理商所属生产企业名称
- 企业信息表中的 `del_flag is null` 历史数据需要统一修正为 `0`
- 前后端联系电话校验统一支持手机号和座机号

### 前端

- 施工企业页面、生产企业页面直接消费 `enterpriseName`、`contactPerson`、`region`
- 代理商页面直接消费：
  - `enterpriseName`：所属生产企业名称
  - `agentName`：代理商名称
  - `productionId`：所属生产企业 ID
- 地区选择组件依赖接口返回完整的省市区编码与名称用于回显

## Acceptance Criteria

- [ ] 施工企业列表和详情接口返回 `enterpriseName`、`contactPerson`
- [ ] 生产企业列表和详情接口返回 `enterpriseName`、`contactPerson`
- [ ] 地区相关接口返回 `region`，格式为 `省/市/区`
- [ ] 地区相关接口返回 `provinceCode/provinceName/cityCode/cityName/districtCode/districtName`
- [ ] 代理商列表接口返回 `enterpriseName`（所属生产企业名称）和 `agentName`（代理商名称）
- [ ] 代理商详情接口返回 `productionId`，可用于编辑页回显所属生产企业
- [ ] `area` 中保存地区 ID 时，接口仍能正确关联 `base_province.full_name`
- [ ] 联系电话同时支持手机号与座机号校验
- [ ] `t_companyinfo.del_flag is null` 的历史数据已清洗为 `0`

- [ ] 新增施工企业时，若 `enterpriseName` 已被 `sys_user.user_name` 使用，接口必须拦截新增
- [ ] 新增生产企业时，若 `enterpriseName` 已被 `sys_user.user_name` 使用，接口必须拦截新增
- [ ] 新增代理商时，若 `userAccount` 或回退后的代理商名称已被 `sys_user.user_name` 使用，接口必须拦截新增
- [ ] 删除企业时，关联的 `sys_user`、`sys_user_role`、`sys_user_post`、`sys_user_pw_history` 被同步清理
- [ ] 从用户管理删除企业账号时，对应 `t_companyinfo` 企业记录被同步删除

## Manual Alignment

对照《青岛市建设工程材料信息管理平台操作手册》，本变更的实际范围已经超出手册中的操作员视角：

- 手册侧重“企业完善自身信息”与“生产单位创建本单位代理商”。
- 当前提案实际提供了施工企业、生产企业、代理商三类企业的后台主数据管理页面。
- 其中代理商维护在手册里应绑定当前生产单位上下文，当前实现则允许从全量生产企业中选择所属企业，属于更强的后台管理能力。

## Notes

- 账号唯一约束当前先在业务层落地，后续如需进一步防并发冲突，可补充数据库唯一索引作为兜底

- 本次变更重点是统一“接口返回模型”和“页面字段语义”，不是调整底层表结构
- `area` 当前仍可保留为地区 ID 数组字符串形式，后端负责转为前端可用字段
- 代理商场景下，`enterpriseName` 不再表示代理商自身名称，而是表示所属生产企业名称
- 本提案不实现按用户获取企业信息能力
- 本提案只保留 `base_province` 作为地区数据来源
