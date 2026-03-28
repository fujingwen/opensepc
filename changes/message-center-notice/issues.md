## 已处理问题

1. `sql/dict/base_dict.sql` 原先使用了 `ON CONFLICT`，但现网 `master.sys_dict_data` 没有对应唯一约束，执行时报错。
处理结果：改为 `WHERE NOT EXISTS` 的幂等写法，并补充了 `NULL` 的显式类型转换，已重新执行成功。

2. 前端项目没有 `npm run build` 脚本，实际构建命令为 `npm run build:prod`。
处理结果：已按仓库实际脚本完成生产构建验证。

3. 既有组件 [index.vue](e:/construction-material/construction-material-web/src/components/EnterpriseSelect/index.vue) 存在错误引用，导入了不存在的 `@/api/base/production`，导致整站构建失败。
处理结果：已改为复用现有的 `@/api/base/companyinfo`，前端生产构建已通过。

## 当前状态

无阻塞问题。

## 构建告警

1. Vite 构建时提示存在超大 chunk，这是仓库当前整体体积告警，不影响本次消息通知与通知公告模块功能落地。
2. `src/utils/generator/js.js` 存在既有 `eval` 告警，不属于本次改动范围。
