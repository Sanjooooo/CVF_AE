# 近年改进算法复现说明

日期：2026-06-23

本阶段为扩展主对比补充 3 个近年非 AE 改进算法：

- `GDESAO`：Global Dynamic Evolution Snow Ablation Optimizer，代码同时接受别名 `GDSAO`；
- `ERIME`：enhanced RIME optimizer，代码同时接受别名 `ELRIME`；
- `MSCSO`：Modified Sand Cat Swarm Optimization。

## 复现来源

- `GDESAO`：参考 Scientific Reports 2024 的 UAV path planning 论文，复现 good-point-set initialization、adaptive dynamic snowmelt ratio、SAO exploration/exploitation 和 neighborhood dimensional search。
  - 论文链接：https://www.nature.com/articles/s41598-024-81100-y
- `ERIME`：参考 Scientific Reports 2024 的 enhanced RIME for 3D UAV path planning 论文，复现 elite reverse learning、soft-rime search、hard-rime puncture 和 greedy selection。
  - 论文链接：https://www.nature.com/articles/s41598-024-72279-1
- `MSCSO`：参考 Sensors 2025 的 modified sand cat swarm optimization for 3D UAV path planning 论文，复现 chaotic initialization、Levy-Metropolis disturbance、SA-PSO exploitation 和 elite mutation。
  - 论文链接：https://www.mdpi.com/1424-8220/25/9/2730

当前仓库内实现属于 paper-based reimplementation，不声称逐行复刻作者源码。三个算法均只接入统一 UAV B-spline 编码、统一 `fitnessFAEAE` 目标函数、统一边界投影和 Deb 可行性优先接受规则；不使用 CVF-AE 的参考路径初始化、CVF、repair 或 sparse preservation 等本文专属机制。

## 新增文件

- `optimizer_GDESAO_uav.m`
- `optimizer_ERIME_uav.m`
- `optimizer_MSCSO_uav.m`

## 修改入口

- `getUAVAlgorithmConfig.m`
- `run_single_uav_algorithm_case.m`
- `run_uav_comparison_lite_v2_batch.m`
- `run_cvf_ae_main_comparison.m`

新增 runner 模式：

- `run_cvf_ae_main_comparison('recent-precheck')`
- `run_cvf_ae_main_comparison('recent-formal')`
- `run_cvf_ae_main_comparison('resume-recent-formal')`

`recent-formal` 只跑新增近年改进算法：

- scenes: `[1, 2, 4]`
- algorithms: `GDESAO`, `ERIME`, `MSCSO`
- runs: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260701`

后续正式主对比表应将该结果目录与已冻结的正式主对比目录合并，而不是重跑既有 8 个算法。

## Precheck

已完成小规模接口验证：

- mode: `recent-precheck`
- scenes: `[1, 2, 4]`
- algorithms: `GDESAO`, `ERIME`, `MSCSO`
- runs: `2`
- popSize: `12`
- maxIter: `20`
- run records: `18 / 18`

precheck 平均排名：

- `MSCSO`: `1.6667`
- `GDESAO`: `2.0000`
- `ERIME`: `2.3333`

precheck 仅验证接口、输出字段和基本运行稳定性，不作为论文性能结论。Scene 4 中新增算法存在不可行 run，正式实验必须继续配套 trajectory sanity 和 feasible rate 解释。
