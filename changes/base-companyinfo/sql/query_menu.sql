-- 查询基础数据相关菜单权限（含按钮权限）
-- 执行后请将结果反馈，以便更新提案和SQL

SELECT
    menu_id,
    menu_name,
    parent_id,
    order_num,
    path,
    component,
    menu_type,
    perms,
    icon,
    visible,
    status,
    remark
FROM sys_menu
WHERE menu_id BETWEEN 5000000 AND 5009999
   OR parent_id BETWEEN 5000000 AND 5009999
   OR menu_name IN ('基础数据', '施工企业管理', '生产企业管理', '代理商管理', '省市区管理')
   OR path LIKE '%companyinfo%'
   OR path LIKE '%region%'
ORDER BY parent_id, order_num;

-- 或者查询所有菜单结构
-- SELECT menu_id, menu_name, parent_id, order_num, menu_type, path, perms FROM sys_menu WHERE parent_id = 0 ORDER BY order_num;