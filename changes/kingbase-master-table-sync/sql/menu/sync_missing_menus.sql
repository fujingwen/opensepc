BEGIN;

INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029131000000000001,'统计中心',0,22,'statistics','',NULL,'1','0','M','0','0','','histogram',103,1,'2026-04-03 06:48:25.172205',NULL,NULL,'统计中心顶级菜单',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029131000000000101,'统计分析',2029131000000000001,1,'analysis','statistics/analysis/index',NULL,'1','0','C','0','0','materials:statistics:list','data-analysis',103,1,'2026-04-03 06:48:25.212116',NULL,NULL,'统计分析页面',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029131000000000102,'采购价格分析',2029131000000000001,2,'price','statistics/price/index',NULL,'1','0','C','0','0','materials:price:list','trend-charts',103,1,'2026-04-03 06:48:25.212116',NULL,NULL,'采购价格分析页面',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029131000000000111,'查询',2029131000000000101,1,'','',NULL,'1','0','F','0','0','materials:statistics:query','#',103,1,'2026-04-03 06:48:25.238961',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029131000000000112,'导出',2029131000000000101,2,'','',NULL,'1','0','F','0','0','materials:statistics:export','#',103,1,'2026-04-03 06:48:25.238961',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029131000000000121,'查询',2029131000000000102,1,'','',NULL,'1','0','F','0','0','materials:price:query','#',103,1,'2026-04-03 06:48:25.238961',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029131000000000122,'导出',2029131000000000102,2,'','',NULL,'1','0','F','0','0','materials:price:export','#',103,1,'2026-04-03 06:48:25.238961',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000001,'质量追溯',0,21,'quality','',NULL,'1','0','M','0','0','','guide',103,1,'2026-04-03 07:34:10.504828',NULL,NULL,'质量追溯顶级菜单',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000101,'抽测缺陷建材产品',2029132000000000001,1,'spot-testing','quality/spot-testing/index',NULL,'1','0','C','0','0','materials:qualityTrace:spot:list','filter',103,1,'2026-04-03 07:34:10.528809',NULL,NULL,'抽测缺陷建材产品页面',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000102,'检测缺陷建材产品',2029132000000000001,2,'detect-testing','quality/detect-testing/index',NULL,'1','0','C','0','0','materials:qualityTrace:detect:list','apple',103,1,'2026-04-03 07:34:10.528809',NULL,NULL,'检测缺陷建材产品页面',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000103,'缺陷建材使用情况',2029132000000000001,3,'usage','quality/usage/index',NULL,'1','0','C','0','0','materials:qualityTrace:usage:list','tickets',103,1,'2026-04-03 07:34:10.528809',NULL,NULL,'缺陷建材使用情况页面',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000104,'缺陷建材厂家',2029132000000000001,4,'factory','quality/factory/index',NULL,'1','0','C','0','0','materials:qualityTrace:factory:list','operation',103,1,'2026-04-03 07:34:10.528809',NULL,NULL,'缺陷建材厂家页面',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000111,'查询',2029132000000000101,1,'','',NULL,'1','0','F','0','0','materials:qualityTrace:spot:query','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000112,'导入',2029132000000000101,2,'','',NULL,'1','0','F','0','0','materials:qualityTrace:spot:import','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000113,'删除',2029132000000000101,3,'','',NULL,'1','0','F','0','0','materials:qualityTrace:spot:remove','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000121,'查询',2029132000000000102,1,'','',NULL,'1','0','F','0','0','materials:qualityTrace:detect:query','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000122,'删除',2029132000000000102,2,'','',NULL,'1','0','F','0','0','materials:qualityTrace:detect:remove','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000123,'复检合格',2029132000000000102,3,'','',NULL,'1','0','F','0','0','materials:qualityTrace:detect:recheck','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000131,'查询',2029132000000000103,1,'','',NULL,'1','0','F','0','0','materials:qualityTrace:usage:query','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000132,'隐藏',2029132000000000103,2,'','',NULL,'1','0','F','0','0','materials:qualityTrace:usage:hide','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;
INSERT INTO master.sys_menu(menu_id,menu_name,parent_id,order_num,path,component,query_param,is_frame,is_cache,menu_type,visible,status,perms,icon,create_dept,create_by,create_time,update_by,update_time,remark,create_name,image_path) VALUES (2029132000000000141,'查询',2029132000000000104,1,'','',NULL,'1','0','F','0','0','materials:qualityTrace:factory:query','#',103,1,'2026-04-03 07:34:10.544579',NULL,NULL,'',NULL,NULL)
ON CONFLICT (menu_id) DO NOTHING;

INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029131000000000001 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029131000000000001);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029131000000000101 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029131000000000101);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029131000000000102 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029131000000000102);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029131000000000111 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029131000000000111);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029131000000000112 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029131000000000112);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029131000000000121 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029131000000000121);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029131000000000122 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029131000000000122);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000001 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000001);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000101 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000101);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000102 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000102);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000103 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000103);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000104 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000104);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000111 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000111);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000112 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000112);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000113 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000113);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000121 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000121);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000122 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000122);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000123 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000123);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000131 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000131);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000132 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000132);
INSERT INTO master.sys_role_menu(role_id,menu_id) SELECT 1,2029132000000000141 WHERE NOT EXISTS (SELECT 1 FROM master.sys_role_menu x WHERE x.role_id=1 AND x.menu_id=2029132000000000141);

COMMIT;
