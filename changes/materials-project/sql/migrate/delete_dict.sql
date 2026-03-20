-- ----------------------------
-- Delete Dictionary Data for Engineering Project Module
-- ----------------------------

-- 删除字典数据（先删除数据，再删除类型）
DELETE FROM "master"."sys_dict_data" WHERE dict_type = 'project_progress';
DELETE FROM "master"."sys_dict_data" WHERE dict_type = 'has_report';
DELETE FROM "master"."sys_dict_data" WHERE dict_type = 'is_integrated';
DELETE FROM "master"."sys_dict_data" WHERE dict_type = 'project_nature';
DELETE FROM "master"."sys_dict_data" WHERE dict_type = 'project_structure';

-- 删除字典类型
DELETE FROM "master"."sys_dict_type" WHERE dict_id = 201;
DELETE FROM "master"."sys_dict_type" WHERE dict_id = 202;
DELETE FROM "master"."sys_dict_type" WHERE dict_id = 203;
DELETE FROM "master"."sys_dict_type" WHERE dict_id = 204;
DELETE FROM "master"."sys_dict_type" WHERE dict_id = 205;
