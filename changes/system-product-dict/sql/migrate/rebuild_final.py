#!/usr/bin/env python3
"""
重建 sys_product 表，使用序列生成 id
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

# 清空并重建
cursor.execute("DELETE FROM sys_product")
cursor.execute("SELECT setval('master.seq_sys_product', 999, true)")

# 1. category
print("1. category...")
cursor.execute("""
    INSERT INTO sys_product (
        parent_id, tree_path, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        0, '0', 'category', 0,
        COALESCE(full_name, ''), COALESCE(en_code, ''),
        COALESCE(sort_code, 0), COALESCE(enabled_mark, 1),
        COALESCE(description, ''), COALESCE(tenant_id, '000000'),
        COALESCE(del_flag, '0'), COALESCE(create_dept, 103),
        1, COALESCE(create_time, NOW())
    FROM base_dictionarytype WHERE del_flag = '0'
""")
cursor.execute("UPDATE sys_product SET category_id = id WHERE node_type = 'category'")
cursor.execute("SELECT id, full_name FROM sys_product WHERE node_type = 'category'")
cat_map = {row[1]: row[0] for row in cursor.fetchall()}
print(f"   {len(cat_map)}")

# 2. product
print("2. product...")
cursor.execute("""
    INSERT INTO sys_product (
        parent_id, tree_path, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        0, '0', 'product', 0,
        COALESCE(full_name, ''), COALESCE(en_code, ''),
        COALESCE(sort_code, 0), COALESCE(enabled_mark, 1),
        COALESCE(description, ''), COALESCE(tenant_id, '000000'),
        COALESCE(del_flag, '0'), COALESCE(create_dept, 103),
        1, COALESCE(create_time, NOW())
    FROM base_dictionarydata
    WHERE del_flag = '0'
    AND (parent_id = '' OR parent_id IS NULL OR trim(parent_id) = '')
""")
cursor.execute("SELECT id, full_name FROM sys_product WHERE node_type = 'product'")
prod_map = {row[1]: row[0] for row in cursor.fetchall()}

for full_name, cat_id in cat_map.items():
    cursor.execute(
        "UPDATE sys_product SET parent_id = %s, category_id = %s WHERE full_name = %s AND node_type = 'product'",
        (cat_id, cat_id, full_name)
    )
print(f"   {len(prod_map)}, updated {cursor.rowcount}")

# 3. spec
print("3. spec...")
cursor.execute("""
    INSERT INTO sys_product (
        id, parent_id, tree_path, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        nextval('master.seq_sys_product'), 0, '0', 'spec', 0,
        COALESCE(full_name, ''), COALESCE(en_code, ''),
        COALESCE(sort_code, 0), COALESCE(enabled_mark, 1),
        COALESCE(description, ''), COALESCE(tenant_id, '000000'),
        COALESCE(del_flag, '0'), COALESCE(create_dept, 103),
        1, COALESCE(create_time, NOW())
    FROM base_dictionarydata
    WHERE del_flag = '0'
    AND parent_id IS NOT NULL AND parent_id != ''
""")
print(f"   {cursor.rowcount}")

# 获取 spec 信息
cursor.execute("SELECT id, full_name FROM sys_product WHERE node_type = 'spec'")
spec_list = [(row[0], row[1]) for row in cursor.fetchall()]

# 获取映射
cursor.execute("SELECT id::varchar, full_name FROM base_dictionarydata WHERE del_flag = '0' AND parent_id IS NOT NULL AND parent_id != ''")
parent_name_map = {str(row[0]): row[1] for row in cursor.fetchall()}

# 更新 spec
print("更新 spec...")
count = 0
for spec_id, spec_name in spec_list:
    cursor.execute(
        "SELECT parent_id FROM base_dictionarydata WHERE full_name = %s AND del_flag = '0' LIMIT 1",
        (spec_name,)
    )
    row = cursor.fetchone()
    if row:
        parent_old_id = str(row[0])
        parent_full_name = parent_name_map.get(parent_old_id, '')
        parent_id = prod_map.get(parent_full_name, 0)
        if parent_id > 0:
            cursor.execute('SELECT category_id FROM sys_product WHERE id = %s', (parent_id,))
            result = cursor.fetchone()
            category_id = result[0] if result else 0
            cursor.execute(
                'UPDATE sys_product SET parent_id = %s, category_id = %s WHERE id = %s',
                (parent_id, category_id, spec_id)
            )
            count += 1

print(f"   {count}")

# 验证
print("\n验证:")
cursor.execute('SELECT node_type, COUNT(*) FROM sys_product GROUP BY node_type')
for row in cursor.fetchall():
    print(f"   {row[0]}: {row[1]}")

cursor.execute("SELECT node_type, COUNT(*) FROM sys_product WHERE parent_id = 0 GROUP BY node_type")
print("parent_id=0:")
for row in cursor.fetchall():
    print(f"   {row[0]}: {row[1]}")

cursor.close()
conn.close()
print("\n完成!")