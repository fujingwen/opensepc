-- 查看当前部门数据
SET search_path TO master;
SELECT dept_id, parent_id, dept_name, del_flag
FROM sys_dept
WHERE del_flag = '0'
ORDER BY parent_id, order_num;