# VFALU RVV1.0 修改章节

## 1. 覆盖范围

本文同步最近 `vfalu/rtl` 中 RVV1.0 P0/P1/P2 的执行单元修改。

涉及文件：

- `ct_ara_simd_alu_wrap.v`
- `ct_ara_simd_div_wrap.v`
- `ct_vfalu_top_pipe6.v`
- `ct_vfalu_top_pipe7.v`
- `ct_vfalu_dp_pipe6.v`
- `ct_vfalu_dp_pipe7.v`
- `ct_vmisc_ctrl.v`
- `ct_vmisc_top.v`
- `ct_vperm_ctrl.v`
- `ct_vperm_top.v`
- `ct_vperm_dp.v`
- `ct_freduct_ctrl.v`
- `ct_freduct_top.v`
- `ct_freduct_dp.v`

## 2. 顶层集成修改

### 2.1 pipe6

`ct_vfalu_top_pipe6.v` 已集成：

- `ct_ara_simd_alu_wrap`
- `ct_freduct_top`
- `ct_vmisc_top`
- `ct_vperm_top`
- `ct_vfalu_dp_pipe6` final mux 更新

新增关键输入：

- `dp_vfalu_ex1_pipex_eu_sel[11:0]`
- `dp_vfalu_ex1_pipex_iid[6:0]`
- `dp_vfalu_ex1_pipex_mask[63:0]`
- `dp_vfalu_ex1_pipex_srcf2[63:0]`
- `dp_vfalu_ex1_pipex_vimm[4:0]`
- `dp_vfalu_ex1_pipex_vimm_vld`

### 2.2 pipe7

`ct_vfalu_top_pipe7.v` 已同步扩展 eu_sel/src2/mask/vimm 等接口，保证 pipe7 后续可以复用同类 RVV1.0 执行路径。

## 3. VPERM 修改

`ct_vperm_ctrl.v` 改为通过 `eu_sel[6]` 产生 pipe down。`ct_vperm_top.v` 新增 IID、mask、src2、vimm 端口。`ct_vperm_dp.v` 实现以下操作：

| 指令 | 实现要点 |
| --- | --- |
| `vslideup` | 当前 slice + 上一 slice 局部窗口 |
| `vslidedown` | 当前 slice + 相邻 slice 局部窗口 |
| `vslide1up/down` | 使用 scalar fill |
| `vrgather.vv` | `srcf1` 为 index vector |
| `vrgather.vx/vi` | scalar/vimm index |
| `vcompress` | mask 选中元素，`compress_carry` 跨 slice 搬运 |
| `vext` | 按 SEW 抽取元素 |

跨片状态：

- `prev_src0`
- `prev_func_op`
- `prev_iid`
- `prev_sew`
- `compress_carry`
- `compress_carry_cnt`

## 4. FREDUCT 修改

`ct_freduct_ctrl.v` 改为通过 `eu_sel[8]` 产生 pipe down。`ct_freduct_dp.v` 当前实现 integer reduction：

- `vredsum`
- `vredand`
- `vredor`
- `vredxor`
- `vredminu/vredmin`
- `vredmaxu/vredmax`
- `vwredsumu/vwredsum`

实现方式：

- 新 stream 使用 `srcf1` lane0 作为 seed。
- 当前 64-bit slice 内按 SEW reduce。
- `reduct_accum` 保存跨 slice 累积值。
- `prev_iid/prev_func_op/prev_sew` 防止连续同类指令串流。

## 5. pipe6 结果选择

`ct_vfalu_dp_pipe6.v` final result mux 已扩展为：

```text
FADD / FSPU / Ara ALU / FREDUCT / VMISC / VPERM
```

MFVR 数据选择也加入 Ara ALU、FREDUCT、VMISC、VPERM 相关结果，确保新执行单元结果能被 forward/writeback 使用。

## 6. 验证状态

已通过局部编译：

- VPERM top/ctrl/dp
- FREDUCT top/ctrl/dp
- VMISC top/ctrl/dp
- 全 `vfalu/rtl/*.v`

完整 VFPU top elaboration 仍依赖未纳入窄集合的 `ct_vfpu_cbus/ct_vfpu_rbus/ct_vfdsu_top/ct_vfmau_top`。

