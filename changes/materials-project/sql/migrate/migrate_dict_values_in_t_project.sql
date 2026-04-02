-- ============================================================
-- 迁移 master.t_project 字典字段：旧 F_Id → 新短编码
-- 执行日期：2026-03-31
-- 说明：数据库中 project_nature、project_progress、structure_type、quality_supervision_agency
--       存储的是旧字典系统的 F_Id（长数字ID），需映射为迁移后新字典的短编码
--       construction_unit 当前存储的是企业ID，并通过查询时关联 t_companyinfo 展示企业名称
--       不应再将 construction_unit 迁移为企业名称，否则会破坏当前前后端与联表查询口径
-- ============================================================

-- 1. 工程进度 gcjd（来源：test.base_dictionarydata）
UPDATE master.t_project p
SET project_progress = d."F_EnCode"
FROM test.base_dictionarydata d
JOIN test.base_dictionarytype t ON d."F_DictionaryTypeId" = t."F_Id"
WHERE p.project_progress = d."F_Id"::text
  AND t."F_EnCode" = 'gcjd';
-- 预期影响：1884 行

-- 2. 工程性质 gcxz（来源：test.base_dictionarydata）
UPDATE master.t_project p
SET project_nature = d."F_EnCode"
FROM test.base_dictionarydata d
JOIN test.base_dictionarytype t ON d."F_DictionaryTypeId" = t."F_Id"
WHERE p.project_nature = d."F_Id"::text
  AND t."F_EnCode" = 'gcxz';
-- 预期影响：1884 行

-- 3. 工程结构型式 gcjgxs（来源：test.base_dictionarydata）
UPDATE master.t_project p
SET structure_type = d."F_EnCode"
FROM test.base_dictionarydata d
JOIN test.base_dictionarytype t ON d."F_DictionaryTypeId" = t."F_Id"
WHERE p.structure_type = d."F_Id"::text
  AND t."F_EnCode" = 'gcjgxs';
-- 预期影响：1884 行

-- 4. 质量监督机构 zljdjg（来源：test.base_organize，非字典表）
-- 注意：质量监督机构的值来自 test.base_organize 组织机构表，不是字典表
-- 先更新已存在于 master.sys_dict_data 中的 8 个匹配记录
UPDATE master.t_project p
SET quality_supervision_agency = d.dict_value
FROM test.base_organize o
JOIN master.sys_dict_data d ON d.dict_type = 'zljdjg' AND o."F_FullName" = d.dict_label
WHERE p.quality_supervision_agency = o."F_Id"::text;
-- 预期影响：1518 行

-- 4.1 补录 8 个在 zljdjg 字典中缺失的机构数据
INSERT INTO master.sys_dict_data (dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  ('2034535000000020293', 10, '高新区',                             'gxq',         'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移'),
  ('2034535000000020294', 11, '青岛经济技术开发区',                 'qdjjjskfq',   'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移'),
  ('2034535000000020295', 12, '青岛自贸片区·中德生态园',            'qdzpqsdlst',  'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移'),
  ('2034535000000020296', 13, '青岛灵山湾影视文化产业区',           'qdlswyscy',   'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移'),
  ('2034535000000020297', 14, '古镇口核心区',                       'gzhxq',       'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移'),
  ('2034535000000020298', 15, '泊里镇规划建设管理办公室',           'blzghjs',     'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移'),
  ('2034535000000020299', 16, '青岛海洋高新区',                     'qdhygxq',     'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移'),
  ('2034535000000020300', 17, '青岛董家口经济区管理委员会',         'qddjkjjgwh',  'zljdjg', '', 'default', 'N', '103', '1', now(), '1', now(), '从test.base_organize迁移');
-- 预期影响：8 行

-- 4.2 更新补录的 8 个机构对应的记录
UPDATE master.t_project p
SET quality_supervision_agency = d.dict_value
FROM test.base_organize o
JOIN master.sys_dict_data d ON d.dict_type = 'zljdjg' AND o."F_FullName" = d.dict_label
WHERE p.quality_supervision_agency = o."F_Id"::text;
-- 预期影响：366 行

-- ============================================================
-- 5. 施工单位 construction_unit
-- 当前数据库以企业ID作为存储值，展示时通过 LEFT JOIN master.t_companyinfo 获取企业名称。
-- 此处禁止执行“企业ID -> 企业名称”的更新，避免破坏现有代码和查询口径。
-- ============================================================

-- ============================================================
-- 修正 create_by/update_by：admin → 1
-- ============================================================
UPDATE master.t_project SET create_by = '1' WHERE create_by = 'admin';
-- 预期影响：173 行

UPDATE master.t_project SET update_by = '1' WHERE update_by = 'admin';
-- 预期影响：879 行
