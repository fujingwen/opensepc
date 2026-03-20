-- 行政区划状态字典
-- 字典类型
insert into sys_dict_type values(100, '000000', '行政区划状态', 'sys_region_status', 103, 1, NOW(), null, null, '行政区划状态列表');

-- 字典数据
insert into sys_dict_data values(1000, '000000', 1,  '正常',     '1',       'sys_region_status',  '',   'primary', 'Y', 103, 1, NOW(), null, null, '正常状态');
insert into sys_dict_data values(1001, '000000', 2,  '停用',     '0',       'sys_region_status',  '',   'danger',  'N', 103, 1, NOW(), null, null, '停用状态');
