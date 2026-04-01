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

`base-companyinfo` 已按最新修正意见重新收口。

- 已处理：1、2、3、4、6
- 保留标记：5

## 高优先级问题

### 1. `getByUserId` 能力不再需要

状态：已处理

- 提案中移除了该能力
- 前端 API 和 `EnterpriseSelect` 已移除对应依赖

### 2. 默认密码被硬编码，不符合提案中“来自配置项”的约定

状态：已处理

- 本轮明确按写死逻辑处理
- 提案与设计已同步到这一口径

### 3. `del_flag is null` 的历史数据需修正为 `0`

状态：已处理

- 已补数据库修复脚本
- 代码查询也兼容 `COALESCE(del_flag, 0) = 0`

## 中优先级问题

### 4. 电话校验口径不符合设计：前端只允许手机号，未支持座机；后端也未做二次校验

状态：已处理

- design 写明电话校验应支持：
  - 手机号：`^1[3-9]\\d{9}$`
  - 座机：`^0\\d{2,3}-?\\d{7,8}$`
- 前端三个页面已改为同时支持手机号和座机
- 后端 `BaseCompanyInfoBo` 已补正则校验

### 5. 地区解析能力对历史脏数据兜底不足，无法满足“正确关联中文名称”的验收标准

状态：已标记，暂不处理

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

状态：已处理

- 提案、设计、规格已统一为 `base_province` 口径
- 代码和 SQL 残留也已删除，仅保留 `base_province`

## 验证记录

- 已连接 PostgreSQL 开发库：`building_supplies_supervision`
- 已核对表：
  - `master.t_companyinfo`
  - `master.base_province`
- 实表摘要：
  - `t_companyinfo` 总记录数：`5001`
  - `del_flag = 0`：`4935`
  - `del_flag = 1`：`61`
  - `del_flag = 2`：`5`
  - `del_flag is null`：`0`
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

- 本轮已重新验证：
  - `openspec validate base-companyinfo` 通过
  - `mvn -pl hny-modules/hny-base,hny-modules/hny-materials -am -DskipTests compile` 通过
  - `npm run build:prod` 通过
