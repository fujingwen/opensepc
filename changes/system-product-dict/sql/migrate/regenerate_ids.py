#!/usr/bin/env python3
"""
重新生成 sys_product 表，通过 full_name 匹配建立正确的 parent_id 关联
"""

import psycopg2

conn = psycopg2.connect(
    host="192.168.0.77",
    port=15432,
    database="building_supplies_supervision",
    user="postgres",
    password="zAIgc4xm5Bcax*os",
    options="-c search_path=master"
)
conn.autocommit = True
cursor = conn.cursor()

# 1. 清空表
print("1. 清空 sys_product 表...")
cursor.execute("DELETE FROM sys_product")
print("   完成")

# 2. 插入 category 数据（来自 base_dictionarytype）
print("2. 插入 category 数据...")
cursor.execute("""
    INSERT INTO sys_product (
        id, parent_id, tree_path, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        id::varchar,
        COALESCE(parent_id::varchar, '0') as parent_id,
        '0' as tree_path,
        'category' as node_type,
        id::varchar as category_id,
        COALESCE(full_name, '') as full_name,
        COALESCE(en_code, '') as en_code,
        COALESCE(sort_code, 0) as sort_code,
        COALESCE(enabled_mark, 1) as enabled_mark,
        COALESCE(description, '') as remark,
        COALESCE(tenant_id, '000000') as tenant_id,
        COALESCE(del_flag, '0') as del_flag,
        COALESCE(create_dept, 103) as create_dept,
        COALESCE(create_by, 'admin') as create_by,
        COALESCE(create_time, NOW()) as create_time
    FROM base_dictionarytype
    WHERE del_flag = '0'
""")
print(f"   完成，插入 {cursor.rowcount} 条")

# 3. 插入 product 数据（base_dictionarydata 中 parent_id='0'）
print("3. 插入 product 数据...")
cursor.execute("""
    INSERT INTO sys_product (
        id, parent_id, tree_path, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        id::varchar,
        '0' as parent_id,
        '0' as tree_path,
        'product' as node_type,
        dictionary_type_id::varchar as category_id,
        COALESCE(full_name, '') as full_name,
        COALESCE(en_code, '') as en_code,
        COALESCE(sort_code, 0) as sort_code,
        COALESCE(enabled_mark, 1) as enabled_mark,
        COALESCE(description, '') as remark,
        COALESCE(tenant_id, '000000') as tenant_id,
        COALESCE(del_flag, '0') as del_flag,
        COALESCE(create_dept, 103) as create_dept,
        COALESCE(create_by, 'admin') as create_by,
        COALESCE(create_time, NOW()) as create_time
    FROM base_dictionarydata
    WHERE del_flag = '0'
    AND (parent_id = '0' OR parent_id IS NULL OR parent_id = '')
""")
print(f"   完成，插入 {cursor.rowcount} 条")

# 4. 更新 product 的 parent_id（通过 dictionary_type_id 匹配 category）
print("4. 更新 product 的 parent_id...")
cursor.execute("""
    UPDATE sys_product sp
    SET parent_id = cat.id
    FROM sys_product cat
    WHERE sp.node_type = 'product'
    AND cat.node_type = 'category'
    AND sp.category_id = cat.id
""")
print(f"   更新 {cursor.rowcount} 条")

# 5. 插入 spec 数据（base_dictionarydata 中 parent_id != '0'）
print("5. 插入 spec 数据...")
cursor.execute("""
    INSERT INTO sys_product (
        id, parent_id, tree_path, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        id::varchar,
        parent_id::varchar,
        '0' as tree_path,
        'spec' as node_type,
        dictionary_type_id::varchar as category_id,
        COALESCE(full_name, '') as full_name,
        COALESCE(en_code, '') as en_code,
        COALESCE(sort_code, 0) as sort_code,
        COALESCE(enabled_mark, 1) as enabled_mark,
        COALESCE(description, '') as remark,
        COALESCE(tenant_id, '000000') as tenant_id,
        COALESCE(del_flag, '0') as del_flag,
        COALESCE(create_dept, 103) as create_dept,
        COALESCE(create_by, 'admin') as create_by,
        COALESCE(create_time, NOW()) as create_time
    FROM base_dictionarydata
    WHERE del_flag = '0'
    AND parent_id IS NOT NULL
    AND parent_id != '0'
    AND parent_id != ''
""")
print(f"   完成，插入 {cursor.rowcount} 条")

# 6. 更新 spec 的 parent_id（通过 full_name 匹配 product）
print("6. 更新 spec 的 parent_id...")

# 先找出 spec 中 parent_id 需要更新的情况
cursor.execute("""
    SELECT DISTINCT sp.parent_id
    FROM sys_product sp
    WHERE sp.node_type = 'spec'
    AND sp.parent_id NOT IN (SELECT id FROM sys_product WHERE node_type = 'product')
""")
orphan_parents = [row[0] for row in cursor.fetchall()]
print(f"   找到 {len(orphan_parents)} 个孤立的 parent_id")

# 通过 full_name 匹配更新
cursor.execute("""
    UPDATE sys_product sp
    SET parent_id = prod.id
    FROM sys_product prod,
         base_dictionarydata dd
    WHERE sp.node_type = 'spec'
    AND prod.node_type = 'product'
    AND sp.full_name = prod.full_name
    AND dd.full_name = sp.full_name
    AND dd.del_flag = '0'
""")
print(f"   通过 full_name 更新 {cursor.rowcount} 条")

# 7. 验证结果
print("\n7. 验证结果...")
cursor.execute("SELECT node_type, COUNT(*) FROM sys_product GROUP BY node_type")
for row in cursor.fetchall():
    print(f"   {row[0]}: {row[1]} 条")

# 检查 parent_id 情况
cursor.execute("SELECT node_type, COUNT(*) FROM sys_product WHERE parent_id = '0' GROUP BY node_type")
print("\n   parent_id='0' 的分布:")
for row in cursor.fetchall():
    print(f"     {row[0]}: {row[1]} 条")

# 检查 spec 中 parent_id 仍为 0 的数量
cursor.execute("SELECT COUNT(*) FROM sys_product WHERE node_type = 'spec' AND parent_id = '0'")
print(f"   spec 中 parent_id='0' 的数量: {cursor.fetchone()[0]}")

# 示例数据
print("\n8. 示例数据:")
print("   Category:")
cursor.execute("SELECT id, full_name, parent_id FROM sys_product WHERE node_type = 'category' LIMIT 3")
for row in cursor.fetchall():
    print(f"     id={row[0]}, name={row[1]}, parent_id={row[2]}")

print("   Product:")
cursor.execute("SELECT sp.id, sp.full_name, sp.parent_id, sc.full_name as cat_name FROM sys_product sp LEFT JOIN sys_product sc ON sp.parent_id = sc.id WHERE sp.node_type = 'product' LIMIT 3")
for row in cursor.fetchall():
    print(f"     id={row[0]}, name={row[1]}, parent_id={row[2]}, category={row[3]}")

print("   Spec:")
cursor.execute("SELECT sp.id, sp.full_name, sp.parent_id, p.full_name as parent_name FROM sys_product sp LEFT JOIN sys_product p ON sp.parent_id = p.id WHERE sp.node_type = 'spec' LIMIT 3")
for row in cursor.fetchall():
    print(f"     id={row[0]}, name={row[1]}, parent_id={row[2]}, parent={row[3]}")

cursor.close()
conn.close()

print("\n完成!")