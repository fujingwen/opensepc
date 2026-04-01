# base-companyinfo 问题记录

## 已解决项

1. 生产企业页面曾存在分页、联系人、联系电话、地区中文名显示异常等问题，现已修复，接口已能从 `master.t_companyinfo` 与 `base_province` 正确回填相关字段。
2. `master.t_companyinfo.create_by` 曾错误写入 `admin`，现已改为实际登录用户 ID。
3. 生产企业、施工企业、代理商页面权限标识曾与数据库实际权限不一致，现已修正。
4. `master.t_companyinfo.update_by` 曾错误写入 `admin`，现已改为实际登录用户 ID。
5. 代理商新增页“所属生产企业”曾是手工输入，现已改为下拉选择，并复用生产企业列表。
6. `getProductions` 接口已收敛为仅返回 `id` 与 `enterpriseName`。
7. 新增企业时自动创建用户的密码已改为加密后落库。
8. 代理商页面新增时曾误调 `production/getByUserId`，现已改为直接使用 `getProductions`。

## 2026-04-01 审查补充

### 审查范围

- 对照 `proposal.md` / `design.md` / `specs/base_companyinfo/spec.md`
- 对照前后端实现
- 连接 PostgreSQL 开发库核对 `master.t_companyinfo` / `master.base_province`

### 当前结论

`base-companyinfo` 主体能力已实现，但仍有若干项与提案/设计/spec 不完全一致，尤其是“按用户取企业接口”“默认密码来源”“电话校验口径”“历史数据可解析性”几项。

## 高优先级问题

### 1. 前端声明了 `getByUserId` 能力，但后端未实现对应接口

- 设计中明确列出：
  - `GET /api/base/companyinfo/construction/getByUserId`
  - `GET /api/base/companyinfo/production/getByUserId`
- 前端 API 中也保留了 `/base/companyinfo/${path}/getByUserId/${userId}` 调用。
- 当前后端控制器未实现任何 `getByUserId` 路由。

影响：

- 若页面或组件使用该能力，会直接 404。
- 提案中的“按用户获取企业信息”能力未闭环。

相关文件：

- `construction-material-web/src/api/base/companyinfo.js`
- `construction-material-web/src/components/EnterpriseSelect/index.vue`
- `construction-material-backend/hny-modules/hny-base/src/main/java/com/hny/base/controller/BaseCompanyInfoController.java`

### 2. 默认密码被硬编码，不符合提案中“来自配置项”的约定

- proposal/design 明确写的是默认密码 `Hny@2022`，并强调来自配置项。
- 当前监听器中使用的是硬编码常量 `DEFAULT_PASSWORD = "Hny@2022"`。

影响：

- 无法通过配置中心或环境配置调整默认密码。
- 与提案描述的可配置行为不一致。

相关文件：

- `construction-material-backend/hny-modules/hny-system/src/main/java/com/hny/system/listener/BaseCompanyInfoUserCreateListener.java`

### 3. 逻辑删除过滤条件与真实数据不兼容，会漏掉 `del_flag is null` 的有效数据

- 当前查询条件固定为 `del_flag = 0`。
- 实际数据库中：
  - 总记录数：`5001`
  - `del_flag is null`：`6`
  - `del_flag = 0`：`4929`
  - `del_flag = 2`：存在
- 其他模块 SQL 已普遍采用 `coalesce(del_flag, 0) = 0` 口径。

影响：

- 当前企业列表/详情会漏掉库中 `del_flag is null` 的有效历史记录。
- 与实际数据口径不一致。

相关文件：

- `construction-material-backend/hny-modules/hny-base/src/main/java/com/hny/base/service/impl/BaseCompanyInfoServiceImpl.java`

## 中优先级问题

### 4. 电话校验口径不符合设计：前端只允许手机号，未支持座机；后端也未做二次校验

- design 写明电话校验应支持：
  - 手机号：`^1[3-9]\\d{9}$`
  - 座机：`^0\\d{2,3}-?\\d{7,8}$`
- 当前前端三个页面均只校验手机号。
- 后端 `BaseCompanyInfoBo` 仅做非空和长度校验，没有正则校验。

影响：

- 合法座机号码无法录入。
- 与“前后端双重校验”的设计不一致。

相关文件：

- `construction-material-web/src/views/base/construction/index.vue`
- `construction-material-web/src/views/base/production/index.vue`
- `construction-material-web/src/views/base/agent/index.vue`
- `construction-material-backend/hny-modules/hny-base/src/main/java/com/hny/base/domain/bo/BaseCompanyInfoBo.java`

### 5. 地区解析能力对历史脏数据兜底不足，无法满足“正确关联中文名称”的验收标准

- 实际数据库中存在大量 `area = 'null'` 的记录。
- 另外解析出的地区码中有 4 个值无法在 `master.base_province` 找到：
  - `64`
  - `6401`
  - `640104`
  - `null`
- 当前服务层对这类情况只是回退原始 `area` 字段，不会修正或标准化。

影响：

- 对部分历史数据，接口无法稳定返回符合预期的 `provinceName/cityName/districtName/region`。
- 提案中的“只要 `area` 存的是地区 ID，就能正确关联中文名”在当前真实数据下并未完全成立。

相关文件：

- `construction-material-backend/hny-modules/hny-base/src/main/java/com/hny/base/service/impl/BaseCompanyInfoServiceImpl.java`

### 6. 设计文档中的数据前提与现状不一致

- design 中仍描述省市区来源表为 `base_region`，而当前实现和 proposal/spec 实际使用的是 `base_province`。
- design 中提到迁移自 `base_production` / `base_construction` / `base_agent`，但当前实际承载表已是 `master.t_companyinfo`。

影响：

- 提案内部文档存在口径分叉，后续开发和验收容易误判。

相关文件：

- `openspec/changes/base-companyinfo/design.md`
- `openspec/changes/base-companyinfo/proposal.md`
- `openspec/changes/base-companyinfo/specs/base_companyinfo/spec.md`

## 验证记录

- 已连接 PostgreSQL 开发库：`building_supplies_supervision`
- 已核对表：
  - `master.t_companyinfo`
  - `master.base_province`
  - `master.base_region`
- 实表摘要：
  - `t_companyinfo` 总记录数：`5001`
  - `company_type = 1`：`1097`
  - `company_type = 2`：`3633`
  - `company_type = 3`：`271`
  - 有效代理商（`coalesce(del_flag,0)=0 and company_type=3`）：`241`
  - 有效代理商缺失父企业：`0`
  - 活跃记录中 `area` 为空：`3263`
  - 活跃记录中 `contact_user` 为空：`1037`
  - 活跃记录中 `contact_phone` 为空：`1053`
  - 活跃记录中 `company_name` 为空：`15`
  - 解析出的地区码总数：`286`
  - 无法在 `base_province` 命中的地区码：`4`

## 额外说明

- 本次前端生产构建未能作为 `base-companyinfo` 的最终验收依据，因为仓库当前存在一个与本提案无关的阻塞错误：
  - `src/views/materials/project/index.vue` 缺少结束标签，导致 `npm run build:prod` 失败。
