# Kingbase Master 缺表补齐任务清单

## 1. Analysis

- [x] 1.1 核对 PostgreSQL 与 KingbaseES 的连接信息
- [x] 1.2 对比两边 `master` schema 基础表差异
- [x] 1.3 确认缺失表的行数、索引和约束
- [x] 1.4 确认代码层对缺失表的直接依赖
- [x] 1.5 确认 `sys_dict_type` 默认值函数兼容风险

## 2. OpenSpec

- [x] 2.1 新建 `kingbase-master-table-sync` 变更目录
- [x] 2.2 编写 `proposal.md`
- [x] 2.3 编写 `design.md`
- [x] 2.4 编写 `tasks.md`
- [x] 2.5 编写最小 `spec` 约束

## 3. Migration Preparation

- [ ] 3.1 生成 6 张缺失表的 KingbaseES DDL
- [ ] 3.2 生成索引与约束补齐 SQL
- [ ] 3.3 设计 `sys_dict_type` 默认值兼容方案
- [ ] 3.4 生成数据迁移 SQL
- [ ] 3.5 设计 `base_message_receive` 分批迁移方案

## 4. Migration Execution

- [ ] 4.1 在 KingbaseES 创建缺失表
- [ ] 4.2 补齐索引与约束
- [ ] 4.3 执行小表数据迁移
- [ ] 4.4 分批迁移 `base_message_receive`
- [ ] 4.5 执行迁移后行数与抽样校验

## 5. Validation

- [ ] 5.1 验证消息中心链路
- [ ] 5.2 验证字典类型链路
- [ ] 5.3 验证登录日志链路
- [ ] 5.4 验证质量追溯链路
