# IDU/RF RVV1.0 修改章节

## 1. 覆盖范围

本文补充最近 `idu/rtl` 相关 RVV1.0 代码修改，配合总览文档 `doc/design_docs/rvv1.0_recent_code_update.md` 使用。

涉及文件：

- `C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_dp.v`
- `C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_pipe6_decd.v`
- `C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_pipe7_decd.v`
- `C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_top.v`

## 2. RF Decode 修改

### 2.1 RVV1.0 vector decode

pipe6/pipe7 decode 已按 RVV1.0 扩展方向打开 vector 指令分类，生成面向 VFPU/VFALU 的：

- `eu_sel[11:0]`
- `func[19:0]`
- `ready_stage[2:0]`
- `vimm[4:0]`
- `vimm_vld`

`func[19:0]` 当前采用 `{sew[1:0], vec_func[17:0]}` 格式，供 VFALU 子单元按 SEW 和 func opcode 组合判断具体操作。

### 2.2 执行单元路由

| eu_sel bit | RVV1.0 单元 | 当前用途 |
| --- | --- | --- |
| bit5 | VALU | Ara SIMD ALU wrapper，基础 integer/logic/compare/shift/merge |
| bit6 | VPERM | slide/gather/compress/extract |
| bit7 | VMISC | mask/misc 类操作 |
| bit8 | VREDU | integer reduction |
| bit10 | VMULU | 乘法类预留/规划 |
| bit11 | VDIRU/VDIV | integer div/rem 多周期路径 |

## 3. RF DP 数据通路修改

### 3.1 三源操作数

RF DP 已补充 pipe6/pipe7 第三源操作数路径，用于：

- `vmacc/vnmsac/vmadd/vnmsub`
- `vmerge`
- `vmv`
- 后续 widening/narrowing 旧目的寄存器 merge 场景

### 3.2 mask 和 vimm

mask/vimm 语义已进入执行通路：

- `srcvm` 作为 RVV mask 数据传给 VFPU/VFALU。
- `vimm[4:0]` 和 `vimm_vld` 用于 `.vi` 类指令和 `vrgather.vi`/`vslide` offset。
- `vm=0` 时应使用 mask 控制 element 写入或选择；`vm=1` 时执行单元可按全使能处理。

## 4. 当前风险

| 风险 | 说明 | 后续动作 |
| --- | --- | --- |
| VRT/VRF group 语义未完整 | 当前仍以 64-bit slice 和单寄存器路径为主 | 继续补 LMUL/EMUL group rename 和 VRF group read/write |
| `vsew` 仍主要使用低 2 bit | SEW=8/16/32/64 足够，但 reserved/illegal 保护需上游保证 | 后续补完整 `vsew[2:0]` 和 illegal 检查 |
| mask/tail policy 未完全闭环 | 执行通路有 mask 数据，但 vta/vma/tu/mu 还未全链路实现 | 后续补 CP0/RTU/VFPU policy 传递和 merge |

