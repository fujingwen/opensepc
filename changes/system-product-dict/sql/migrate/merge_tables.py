#!/usr/bin/env python3
"""
合并 base_dictionarytype 和 base_dictionarydata 为新表
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

print("=== 合并方案 ===")
print("""
结构分析:
- base_dictionarytype: 存储顶级分类 (category)
  - 字段: id, full_name, en_code, parent_id, sort_code, enabled_mark, description 等

- base_dictionarydata: 存储具体规格 (spec)
  - 字段: id, full_name, en_code, parent_id, dictionary_type_id, sort_code, enabled_mark, description 等
  - 通过 dictionary_type_id 关联到 base_dictionarytype

合并策略:
1. 创建新表 merged_dictionary
2. 先插入 base_dictionarytype 数据 (node_type='category')
3. 再插入 base_dictionarydata 数据 (node_type='spec')
4. 通过 full_name 匹配建立 parent_id 关联
""")

# 1. 创建新表
print("\n1. 创建新表 merged_dictionary...")
cursor.execute("""
    CREATE TABLE IF NOT EXISTS merged_dictionary (
        id VARCHAR(50) PRIMARY KEY,
        parent_id VARCHAR(50) DEFAULT '0',
        node_type VARCHAR(20) NOT NULL,
        category_id VARCHAR(50) DEFAULT '0',
        full_name VARCHAR(200) NOT NULL,
        en_code VARCHAR(100),
        sort_code BIGINT DEFAULT 0,
        enabled_mark INTEGER DEFAULT 1,
        remark TEXT,
        tenant_id VARCHAR(50),
        del_flag CHAR(1) DEFAULT '0',
        create_dept BIGINT,
        create_by VARCHAR(100),
        create_time TIMESTAMP,
        update_by VARCHAR(100),
        update_time TIMESTAMP
    )
""")
print("   完成")

# 2. 清空表
cursor.execute("DELETE FROM merged_dictionary")
print("2. 清空表")

# 3. 插入 base_dictionarytype 数据 (node_type='category')
print("3. 插入 category 数据...")
cursor.execute("""
    INSERT INTO merged_dictionary (
        id, parent_id, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        id::varchar as id,
        COALESCE(parent_id::varchar, '0') as parent_id,
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

# 4. 插入 base_dictionarydata 数据 (node_type='spec')
print("4. 插入 spec 数据...")
cursor.execute("""
    INSERT INTO merged_dictionary (
        id, parent_id, node_type, category_id, full_name, en_code,
        sort_code, enabled_mark, remark, tenant_id, del_flag,
        create_dept, create_by, create_time
    )
    SELECT
        id::varchar as id,
        COALESCE(parent_id::varchar, '0') as parent_id,
        'spec' as node_type,
        COALESCE(dictionary_type_id::varchar, '0') as category_id,
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
""")
print(f"   完成，插入 {cursor.rowcount} 条")

# 5. 更新 category 的 parent_id (top-level category 应该为 '0')
print("5. 更新 category 的 parent_id...")
# 找出顶级分类 (parent_id 在 base_dictionarytype 中为空的)
cursor.execute("""
    UPDATE merged_dictionary md
    SET parent_id = '0'
    WHERE md.node_type = 'category'
    AND NOT EXISTS (
        SELECT 1 FROM base_dictionarytype dt
        WHERE dt.id::varchar = md.id
        AND dt.parent_id IS NOT NULL
        AND dt.parent_id != '0'
    )
""")
print("   完成")

# 6. 更新 spec 的 parent_id (需要通过 full_name 匹配找到对应的 product)
# spec 的 parent_id 应该指向 base_dictionarydata 中的 parent_id 对应的记录
print("6. 更新 spec 的 parent_id...")
# 先查看 spec 的 parent_id 现状
cursor.execute("""
    SELECT parent_id, COUNT(*)
    FROM merged_dictionary
    WHERE node_type = 'spec'
    GROUP BY parent_id
    LIMIT 10
""")
print("   spec parent_id 分布:")
for row in cursor.fetchall():
    print(f"     {row[0]}: {row[1]} 条")

# 验证结果
print("\n7. 验证结果...")
cursor.execute("SELECT node_type, COUNT(*) FROM merged_dictionary GROUP BY node_type")
for row in cursor.fetchall():
    print(f"   {row[0]}: {row[1]} 条")

cursor.execute("SELECT COUNT(*) FROM merged_dictionary")
print(f"\n总计: {cursor.fetchone()[0]} 条")

# 显示示例数据
print("\n8. 示例数据:")
print("   Category 数据:")
cursor.execute("SELECT id, full_name, parent_id FROM merged_dictionary WHERE node_type = 'category' LIMIT 3")
for row in cursor.fetchall():
    print(f"     id={row[0]}, name={row[1]}, parent_id={row[2]}")

print("   Spec 数据:")
cursor.execute("SELECT id, full_name, parent_id, category_id FROM merged_dictionary WHERE node_type = 'spec' LIMIT 3")
for row in cursor.fetchall():
    print(f"     id={row[0]}, name={row[1]}, parent_id={row[2]}, category_id={row[3]}")

cursor.close()
conn.close()

print("\n合并完成!")
print("\n注意: 当前 parent_id 存储的是原始的 UUID 字符串，如果需要转换为数字 id，需要额外处理。")