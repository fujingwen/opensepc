# 数据大屏问题记录

## 审查时间

- 2026-04-07

## 审查结论

1. 已将废弃综合接口从前端、后端和 OpenSpec 提案中移除。
2. 当前数据大屏只保留拆分接口主链路：
   - `/materials/dashboard/summary`
   - `/materials/dashboard/rates`
   - `/materials/dashboard/regions`
   - `/materials/dashboard/types`
   - `/materials/dashboard/lists`
3. `/materials/dashboard/regions` 仍采用“按项目先聚合、再按区市汇总”的优化方案，应继续保留。
4. 本轮未执行前端构建或页面运行；这是按用户要求保留的限制，不影响本次结构收敛结论。

## 当前未决事项

- 暂未发现与本次废弃接口清理直接相关的未决问题。
