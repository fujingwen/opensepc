# 工程项目回调规格

## ADDED Requirements

### Requirement: 工程项目主表统一到 `t_project`

系统 SHALL 使用 `master.t_project` 作为工程项目主承载表。

#### Scenario: 查询工程项目列表

- **Given** 用户进入工程项目页面
- **When** 系统执行工程项目分页查询
- **Then** 数据来源应为 `master.t_project`
- **Then** 系统应过滤逻辑删除数据

#### Scenario: 维护工程项目

- **Given** 用户拥有工程项目维护权限
- **When** 用户新增、编辑或删除工程项目
- **Then** 系统应读写 `master.t_project`

### Requirement: 工程项目数据从 `test.t_project` 迁移

系统 SHALL 支持将历史工程项目数据从 `test.t_project` 迁移到 `master.t_project`。

#### Scenario: 执行迁移

- **Given** `test.t_project` 中存在历史工程项目数据
- **When** 执行迁移脚本
- **Then** 系统应将业务字段写入 `master.t_project`
- **Then** 系统应补齐 `tenant_id`、`create_dept`、`del_flag`

### `master.t_project` 字段定义

| # | 字段名 | 类型 | 含义 | 前端标签 | 字典/备注 |
|---|--------|------|------|---------|----------|
| 1 | id | varchar(50) | 主键ID | - | NOT NULL |
| 2 | tenant_id | varchar(20) | 租户ID | - | NOT NULL, 默认'000000' |
| 3 | construction_permit | varchar(100) | 施工许可证 | 施工许可证 | 文本输入 |
| 4 | permit_issue_date | timestamp | 施工许可证发证日期 | 施工许可证发证日期 | 日期选择 |
| 5 | project_name | varchar(500) | 工程名称 | 工程名称 | 文本输入 |
| 6 | project_nature | varchar(100) | 工程性质 | 工程性质 | 字典 gcxz |
| 7 | building_area | numeric(18,2) | 建筑面积（平方米） | 建筑面积（平方米） | 数字输入 |
| 8 | project_progress | varchar(100) | 工程进度 | 工程进度 | 字典 gcjd |
| 9 | project_address | varchar(1000) | 工程地址 | 工程地址 | 文本输入 |
| 10 | structure_type | varchar(100) | 工程结构型式 | 工程结构型式 | 字典 gcjgxs |
| 11 | quality_supervision_agency | varchar(500) | 质量监督机构 | 质量监督机构 | 字典 zljdjg |
| 12 | construction_unit | varchar(500) | 施工单位 | 施工单位 | 文本输入（自动填充当前用户） |
| 13 | construction_unit_manager | varchar(100) | 施工单位负责人 | 施工单位负责人 | 文本输入 |
| 14 | manager_contact | varchar(50) | 施工单位负责人联系方式 | 施工单位负责人联系方式 | 文本输入（手机号校验） |
| 15 | has_report | varchar(20) | 有无填报 | 有无填报 | 字典 has_report |
| 16 | is_integrated | varchar(20) | 是否对接一体化平台编码 | 是否对接一体化平台编码 | 字典 is_integrated |
| 17 | remarks | text | 备注 | 备注 | 文本域 |
| 18 | create_by | varchar(50) | 创建人 | - | 系统字段 |
| 19 | create_time | timestamp | 创建时间 | 创建时间 | 系统字段 |
| 20 | update_by | varchar(50) | 更新人 | - | 系统字段 |
| 21 | update_time | timestamp | 更新时间 | 更新时间 | 系统字段 |
| 22 | del_flag | integer | 删除标志 | - | 0=存在, 2=删除 |
| 23 | create_dept | varchar(50) | 创建部门 | - | 默认'103' |

### 字典值映射问题

> **关键问题**：数据库中字典字段（`project_nature`、`project_progress`、`structure_type`、`quality_supervision_agency`）存储的是**旧字典系统的 `F_Id`（长数字ID，如 `270407069977281797`）**，而迁移后的新字典 `master.sys_dict_data` 使用的是**短编码（如 `shqzbjd`、`ggjz`、`lsq`）**作为 `dict_value`。需要进行数据迁移映射。

#### 旧字典值（test.base_dictionarydata）→ 新字典值（master.sys_dict_data）映射关系

**gcjd（工程进度）**

| 旧 F_Id | 旧 F_EnCode / 新 dict_value | 含义 |
|---------|---------------------------|------|
| 270407069977281797 | shqzbjd | 施工前准备阶段 |
| 270407267512222981 | tfkwjjkzhjd | 土方开挖及基坑支护阶段 |
| 270407374198539525 | jcsgjd | 基础施工阶段 |
| 270407570366137605 | ztjgqjd | 总体结构1/2前阶段 |
| 270407698351129861 | ztjghjd | 总体结构1/2后阶段 |
| 270407816039105797 | zsazjd | 装饰安装阶段 |
| 270407984524297477 | jgyyjd | 竣工预验阶段 |
| 270408056989287685 | tg | 停工 |

**gcxz（工程性质）**

| 旧 F_Id | 旧 F_EnCode / 新 dict_value | 含义 |
|---------|---------------------------|------|
| 271061974257763589 | ggjz | 公建 |
| 279039617003422981 | zz | 住宅 |
| 279038606134215941 | cf | 厂房 |
| 289157172212794629 | xx | 学校 |
| 356658908959343877 | dbc | 待补充 |
| 271061891747415301 | zlrczf | 住宅（人才公寓） |
| 279038448680043781 | bzf | 保障房 |
| 279038743212459269 | eczx | 二次装修 |
| 279038912553288965 | fdc | 房地产 |
| 279038997563442437 | gt | 工业 |
| 279039139754542341 | sy | 商业 |
| 279039258637894917 | tsf | 土石方 |
| 279039370437068037 | ylyl | 医疗，养老项目 |
| 279039474296423685 | yey | 幼儿园 |
| 279039752932427013 | zzgj | 住宅、公建 |
| 279039886655227141 | zx | 装修 |
| 279045402236290309 | zzptsy | 住宅及配套商业 |
| 279126157872334085 | azf | 安置房 |
| 279125766069814533 | cj | 车间 |
| 279125456786031877 | jz | 精装 |
| 279123711913624837 | sz | 商住 |

**gcjgxs（工程结构型式）**

| 旧 F_Id | 旧 F_EnCode / 新 dict_value | 含义 |
|---------|---------------------------|------|
| 270410448577234181 | kjjlq | 框架剪力墙 |
| 270410531842557189 | kjtc | 框架填充 |
| 270410615921575173 | zhjg | 砖混结构 |
| 270410708896711941 | hntqk | 混凝土砌块 |
| 270410828472124677 | qgqb | 轻钢轻板 |
| 270410906867860741 | gjg | 钢结构 |
| 270411003403961605 | xjjlq | 现浇剪力墙 |
| 270411113781265669 | qt | 其他 |
| 356658817473185029 | dbc | 待补充 |

**zljdjg（质量监督机构）**

| 旧 F_Id | 旧 F_EnCode / 新 dict_value | 含义 |
|---------|---------------------------|------|
| 270411841673364741 | lsq | 崂山区 |
| 270411927065199877 | xhaxq | 西海岸新区 |
| 270412123044054277 | cyq | 城阳区 |
| 270412287989253381 | sjcglzx | 青岛市建筑工程管理服务中心 |
| 270412390082807045 | lxs | 莱西市 |
| 270412473029362949 | pds | 平度市 |
| 270412552079410437 | jzs | 胶州市 |
| 270412633960613125 | xxb | 信息部 |
| 270412719897707781 | jmq | 即墨区 |

#### 映射方案

通过 `test.base_dictionarydata` 表的 `F_Id`（旧值）与 `F_EnCode`（新值）建立映射，逐字段执行 `UPDATE`：

```sql
-- 以 project_progress 为例
UPDATE master.t_project p
SET project_progress = d."F_EnCode"
FROM test.base_dictionarydata d
JOIN test.base_dictionarytype t ON d."F_DictionaryTypeId" = t."F_Id"
WHERE p.project_progress = d."F_Id"::text
  AND t."F_EnCode" = 'gcjd';
```

对 `project_nature`、`structure_type`、`quality_supervision_agency` 同理执行。

### Requirement: 一体化工程编码下拉选择

系统 SHALL 支持在新增/编辑工程项目时，通过下拉选择关联一体化工程编码。

#### 数据源

- 来源表：`test.jck_t_gc_sgxkz`（工程施工许可证表 / 一体化工程编码表）
- 记录数：18,775 条（其中有效记录 17,872 条，sgxkz_zh 非空且非 '0'）
- 迁移目标：`master.jck_t_gc_sgxkz`

#### 关键字段

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| sgxkz_uuid | varchar(255) | 主键 UUID |
| sgxkz_zh | varchar(255) | 施工许可证号 |
| sgxkz_gcmc | varchar(500) | 工程名称 |
| gc_code | varchar(255) | 工程编码 |
| xm_code | varchar(255) | 项目编码 |
| sgxkz_jsdwmc | varchar(255) | 建设单位名称 |
| sgxkz_sgdw | varchar(255) | 施工单位 |

#### Scenario: 新增时选择一体化工程编码

- **Given** 用户新增工程项目
- **When** 用户在"一体化工程编码"下拉框中选择一条记录
- **Then** 系统自动将 `sgxkz_zh`（施工许可证号）填充到"施工许可证"字段
- **Then** 系统自动将 `is_integrated`（对接一体化平台编码）设为"是"
- **When** 用户未选择一体化工程编码
- **Then** 该字段留空，不影响其他字段

#### 关联关系

```text
master.t_project.construction_permit  ←→  master.jck_t_gc_sgxkz.sgxkz_zh
```

- test.t_project 中 3,746 条记录有 3,186 条可通过 F_ConstructionPermitNo ↔ sgxkz_zh 匹配到 jck_t_gc_sgxkz

#### 实现方案

1. **数据迁移**：`master.jck_t_gc_sgxkz` 已存在，18,775 条记录
2. **后端**：
   - `GET /materials/project/sgxkzPage` 分页查询接口
   - 返回字段：`sgxkz_zh`(permit)、`sgxkz_gcmc`(projectName)、`sgxkz_sgdw`(constructionUnit)
   - 支持按工程名称或施工许可证号模糊搜索
3. **前端**：
   - 新增时，"一体化工程编码"作为表单第一个字段，`el-select` 远程搜索
   - **打开新增 dialog 时立即加载第一页数据**（空关键词触发）
   - 选中后自动填充 `construction_permit` 和 `is_integrated = '1'`
   - 字段非必填
   - 下拉框下方显示提示文字："注：可使用施工许可证号或工程名称过滤"

### Requirement: 新增表单字段调整

系统 SHALL 按原型调整工程项目新增表单的必填、可见与录入方式。

#### Scenario: 新增时的字段规则

- **Given** 用户新增工程项目
- **Then** 以下字段**非必填**：施工许可证、施工许可证发证日期
- **Then** 以下字段**不显示**：有无填报、是否对接一体化平台编码
- **Then** 施工单位字段为下拉选择（来自 `t_companyinfo`），非 disabled 输入框

### Requirement: 列表操作按钮

系统 SHALL 在工程项目列表页提供与原型一致的操作按钮和导出行为。

#### Scenario: 操作按钮

- **Given** 用户在工程项目列表页
- **Then** 操作按钮包含：新增、导出、导出已开工未填报项目表
- **Then** 不包含批量删除按钮和列表多选列

#### Scenario: 导出已开工未填报项目表

- **Given** 用户点击"导出已开工未填报项目表"
- **Then** 系统导出工程进度排除"施工前准备阶段(shqzbjd)"和"土方开挖及基坑支护阶段(tfkwjjkzhjd)"且"有无填报"为"否"的项目
- **Then** 导出表名为"工程信息管理"
- **Then** 导出字段：工程名称、施工许可证、工程进度、工程地址、施工单位、施工单位现场负责人、施工单位现场负责人联系方式、质量监督机构、填报状态
