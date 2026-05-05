# VFPU RVV1.0 修改章节

## 1. 覆盖范围

本文同步最近 `vfpu/rtl` 中为 RVV1.0 扩展新增或刷新过的接口和数据通路。

涉及文件：

- `C910_RTL_FACTORY/gen_rtl _rvv1.0/vfpu/rtl/ct_vfpu_dp.v`
- `C910_RTL_FACTORY/gen_rtl _rvv1.0/vfpu/rtl/ct_vfpu_top.v`

## 2. 新增 VFALU 透传接口

VFPU DP/TOP 已向 VFALU 透传完整 RVV1.0 执行上下文：

| 信号 | 位宽 | 来源 | 目的 | 功能 |
| --- | --- | --- | --- | --- |
| `dp_vfalu_ex1_pipe6_eu_sel` | 12 | `ctrl_ex1_pipe6_eu_sel` | pipe6 VFALU | 完整执行单元选择 |
| `dp_vfalu_ex1_pipe7_eu_sel` | 12 | `ctrl_ex1_pipe7_eu_sel` | pipe7 VFALU | 完整执行单元选择 |
| `dp_vfalu_ex1_pipe6_iid` | 7 | EX1 pipe6 IID | VPERM/FREDUCT | 跨 64-bit slice 状态边界 |
| `dp_vfalu_ex1_pipe*_srcf2` | 64 | RF src2 | VFALU | 三源/merge/move/乘加 |
| `dp_vfalu_ex1_pipe*_mask` | 64 | RF mask | VFALU | masked operation/compress |
| `dp_vfalu_ex1_pipe*_vimm` | 5 | RF decode | VFALU | `.vi` 立即数 |
| `dp_vfalu_ex1_pipe*_vimm_vld` | 1 | RF decode | VFALU | vimm 有效标志 |

## 3. eu_sel 路由修正

旧通路只向 VFALU 暴露 `dp_vfalu_ex1_pipex_sel[2:0]`，无法表达 VPERM、VMISC、VREDU 等 RVV1.0 单元。当前修改保留原 3-bit sel 给传统 FADD/FSPU 路径，同时新增完整 `eu_sel[11:0]` 给 RVV 子单元。

## 4. 多周期除法接入

`ct_vfpu_top.v` 实例化 `ct_ara_simd_div_wrap.v`，`ct_vfpu_dp.v` 接收 `vdivu_vfpu_ex1_pipe6_result` 和 valid 信号，将 integer div/rem 结果纳入 pipe6 writeback/forward 流程。

当前支持重点：

- 多周期 valid 输出。
- SEW=8/16/32/64 lane 级 div/rem。
- 除零和 signed overflow 的 RVV 风格处理。

## 5. 后续事项

- 将 `vstart/vl/vtype/vta/vma` 从 CP0/IDU 贯通到 VFPU。
- 将 `vxsat`、fflags 类 side effect 纳入 RTU 精确提交。
- 对多周期 div/rem 增加 flush kill、replay 和 scoreboard ready 细化控制。

