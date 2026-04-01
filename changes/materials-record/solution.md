# solution

问题1，现在的设计是，用manufacture_id字段来关联生产企业，manufactur字段没有用处了，帮我检查这种设计是否合理？如果合理则按照当前设计走，在提案中标注这一点。
问题2，按照有效期计算
问题3：按照  batch-import-dialog 提案的组件实现导入
问题4：需要严格限制备案证号“不可重复”
问题5：字典用certificate_status
问题6：确认send_flag是否真正需要，
问题7：优化分页
问题8：原来的表中用的是enabled_mark表示是否删除，我们的系统用的是del_flag来表示，这里需要同步数据库，把enabled_mark映射到del_flag；del_flag的0是未删除、2是删除，然后只用del_flag和company_type去判断即可。
问题9：先保留不做处理
