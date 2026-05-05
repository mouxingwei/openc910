# RVV1.0 最近代码修改同步说明

## 1. 文档范围

本文同步记录 `C910_RTL_FACTORY/gen_rtl _rvv1.0` 目录下最近一轮 RVV1.0 支持代码修改，覆盖 IDU/RF、VFPU、VFALU、Ara 算子 wrapper、多周期除法、三源操作数、mask/vimm 语义、以及 P2 跨 64-bit 片的 slide/gather/compress/reduction 实现。

当前实现以 64-bit VFALU 数据片为基本执行粒度，优先补齐 RVV1.0 integer/permute/reduction 的可执行通路。LMUL/完整 VLEN 调度、精确 vstart/tail policy、完整 VRF group 访问仍属于后续完善范围。

## 2. 修改文件总览

| 路径 | 修改类型 | RVV1.0 作用 |
| --- | --- | --- |
| `cpu/rtl/ct_core.v` | 顶层连线 | 接入 RVV1.0 扩展后的 IDU/VFPU 相关端口 |
| `filelists/C910_asic_rtl.fl` | filelist | 加入新增 RVV/Ara wrapper RTL |
| `idu/rtl/ct_idu_rf_dp.v` | RF 数据通路 | 补充 pipe6/pipe7 的 vector 源操作数、mask、vimm、src2 传递路径 |
| `idu/rtl/ct_idu_rf_pipe6_decd.v` | RF 解码 | 打开/扩展 RVV1.0 pipe6 vector decode，生成 eu_sel/func/vimm 等执行控制 |
| `idu/rtl/ct_idu_rf_pipe7_decd.v` | RF 解码 | 与 pipe6 同步补齐 pipe7 vector decode 控制 |
| `idu/rtl/ct_idu_top.v` | IDU 顶层 | 汇接 RF 新增 RVV1.0 端口 |
| `vfpu/rtl/ct_vfpu_dp.v` | VFPU 数据通路 | 透传完整 eu_sel、src2、mask、vimm、pipe6 IID，接入 vdiv 结果 |
| `vfpu/rtl/ct_vfpu_top.v` | VFPU 顶层 | 连接 VFALU pipe6/pipe7 新端口和 vdiv wrapper |
| `vfalu/rtl/ct_ara_simd_alu_wrap.v` | 新增 wrapper | 复用 Ara 风格 64-bit SIMD ALU 能力，覆盖 P0 integer/logic/compare/shift/merge 基础算子 |
| `vfalu/rtl/ct_ara_simd_div_wrap.v` | 新增 wrapper | 实现 RVV integer div/rem 的多周期执行和 valid 输出 |
| `vfalu/rtl/ct_vfalu_top_pipe6.v` | VFALU pipe6 顶层 | 接入 Ara ALU、VPERM、VMISC、FREDUCT、DIV 相关路径 |
| `vfalu/rtl/ct_vfalu_top_pipe7.v` | VFALU pipe7 顶层 | 同步扩展 pipe7 端口，保留后续并行执行空间 |
| `vfalu/rtl/ct_vfalu_dp_pipe6.v` | VFALU pipe6 mux | 将 Ara ALU、VMISC、VPERM、FREDUCT 结果纳入 forward/writeback mux |
| `vfalu/rtl/ct_vfalu_dp_pipe7.v` | VFALU pipe7 mux | 同步 Ara ALU 结果选择能力 |
| `vfalu/rtl/ct_vmisc_ctrl.v` | VMISC 控制 | 改用完整 eu_sel bit7 判断 VMISC pipe down |
| `vfalu/rtl/ct_vmisc_top.v` | VMISC 顶层 | 新增完整 eu_sel 输入并传递给 ctrl |
| `vfalu/rtl/ct_vperm_ctrl.v` | VPERM 控制 | 改用完整 eu_sel bit6 判断 VPERM pipe down |
| `vfalu/rtl/ct_vperm_top.v` | VPERM 顶层 | 新增 IID、mask、src2、vimm/vimm_vld、完整 eu_sel 端口 |
| `vfalu/rtl/ct_vperm_dp.v` | VPERM 数据通路 | 实现 P2 跨 64-bit 片 slide/gather/compress/extract |
| `vfalu/rtl/ct_freduct_ctrl.v` | FREDUCT 控制 | 改用完整 eu_sel bit8 判断 reduction pipe down |
| `vfalu/rtl/ct_freduct_top.v` | FREDUCT 顶层 | 新增 IID、完整 eu_sel 端口 |
| `vfalu/rtl/ct_freduct_dp.v` | FREDUCT 数据通路 | 实现 P2 integer reduction 和 widening reduction 累积 |

## 3. RVV1.0 执行单元选择语义

RF decode 输出的 `eu_sel[11:0]` 是当前 RVV1.0 路由的核心控制字段。此前 VFALU 只接收到压缩后的 `dp_vfalu_ex1_pipex_sel[2:0]`，导致 VPERM、VMISC、VREDU 等单元不能可靠启动。本轮修改将完整 `eu_sel` 从 RF/VFPU 透传到 VFALU 子单元。

| eu_sel bit | 执行单元 | 当前用途 |
| --- | --- | --- |
| bit5 | VALU / Ara ALU | integer ALU、logic、compare、shift、merge/move 等 P0/P1 基础算子 |
| bit6 | VPERM | `vslide*`、`vrgather*`、`vcompress`、`vext` |
| bit7 | VMISC | mask/misc 类已有扩展通路 |
| bit8 | VREDU/FREDUCT | integer reduction / widening reduction |
| bit10 | VMULU | 乘法类预留/已部分规划 |
| bit11 | VDIRU/VDIV | 多周期 integer div/rem 路由 |

## 4. IDU/RF 修改章节

### 4.1 RF vector decode 打开

`ct_idu_rf_pipe6_decd.v` 和 `ct_idu_rf_pipe7_decd.v` 已从原先的 vector placeholder 逐步转为 RVV1.0 decode 路径。核心变化是：

- 生成 RVV integer、mask、permute、reduction、mul/div 类 `decd_vec_eu_sel`。
- 通过 `pipe*_decd_func[19:0]` 携带 `{sew[1:0], func[17:0]}`。
- 为 VPERM/VREDU/VMISC 等非传统 FADD/FSPU 单元保留独立路由。
- 增加 `vimm[4:0]` 和 `vimm_vld`，用于 `.vi`、`vrgather.vi`、`vslide*.vi` 等立即数字段。

### 4.2 三源操作数和 mask 数据

`ct_idu_rf_dp.v` 已补充 pipe6/pipe7 的第三源和 mask 数据通路：

- `srcf2/srcv2` 传递给 VFPU/VFALU，用于 `vmacc/vmadd/vnmsac/vmerge/vmv` 等三源或 old-vd merge 语义。
- `srcvm`/mask 数据透传给 VPERM/VALU，用于 `vm=0` 的 masked element 选择。
- `vimm/vimm_vld` 从 RF decode 进入 VFPU，再进入 VFALU 子单元。

## 5. VFPU 修改章节

### 5.1 新增 VFALU 透传信号

`ct_vfpu_dp.v` 和 `ct_vfpu_top.v` 新增或刷新以下关键通路：

| 信号 | 位宽 | 来源 | 目的 | 用途 |
| --- | --- | --- | --- | --- |
| `dp_vfalu_ex1_pipe6_eu_sel` | 12 | `ctrl_ex1_pipe6_eu_sel` | VFALU pipe6 | 完整执行单元选择 |
| `dp_vfalu_ex1_pipe7_eu_sel` | 12 | `ctrl_ex1_pipe7_eu_sel` | VFALU pipe7 | 完整执行单元选择 |
| `dp_vfalu_ex1_pipe6_iid` | 7 | pipe6 EX1 IID | VPERM/FREDUCT | 判断跨片状态是否属于同一条指令 |
| `dp_vfalu_ex1_pipe*_srcf2` | 64 | RF src2 | VFALU | 三源、merge/move、乘加类操作 |
| `dp_vfalu_ex1_pipe*_mask` | 64 | RF mask | VFALU | masked operation 和 compress |
| `dp_vfalu_ex1_pipe*_vimm` | 5 | RF decode | VFALU | RVV `.vi` 立即数 |
| `dp_vfalu_ex1_pipe*_vimm_vld` | 1 | RF decode | VFALU | 标识 vimm 有效 |

### 5.2 多周期除法结果接入

`ct_ara_simd_div_wrap.v` 提供多周期 integer div/rem 结果，`ct_vfpu_top.v` 实例化后将结果交给 `ct_vfpu_dp.v` 的 pipe6 数据通路。当前实现重点保证：

- 以 valid 表示多周期结果完成。
- 按 SEW 执行 8/16/32/64-bit lane 级除法/取余。
- 对除零和有符号 overflow 语义做 RVV 风格处理。
- 与现有 VFPU writeback/forward 路径对齐。

## 6. VFALU 修改章节

### 6.1 Ara SIMD ALU wrapper

`ct_ara_simd_alu_wrap.v` 作为当前 P0/P1 integer ALU 的本地 wrapper，接收 C910 VFALU pipe 输入并输出 `ara_alu_forward_result` / `ara_alu_forward_r_vld`。当前用于覆盖：

- `vadd/vsub/vrsub`
- `vand/vor/vxor`
- compare/mask result 类
- min/max
- shift/narrow shift 的基础 64-bit 片内行为
- `vmerge/vmv` 的 mask/operand 语义

### 6.2 VPERM 跨 64-bit 片实现

`ct_vperm_dp.v` 从原先 placeholder 更新为元素级数据通路，支持按 SEW 拆分 64-bit slice：

| 指令类 | 当前实现 |
| --- | --- |
| `vslideup` | 使用当前 slice 和上一 slice 的 `prev_src0` 形成局部窗口，支持跨上一 64-bit 边界取数 |
| `vslidedown` | 使用当前 slice 和保存的相邻 slice 窗口处理跨边界取数 |
| `vslide1up/vslide1down` | 额外使用 scalar fill 输入 |
| `vrgather.vv` | 以 `srcf1` 作为 index vector，从当前/上一 slice 窗口取元素 |
| `vrgather.vi/vx` | 以 `vimm` 或 scalar index 作为 gather index |
| `vcompress` | 依据 mask 选中元素，使用 `compress_carry` 在连续 slice 之间搬运未写满的元素 |
| `vext` | 按 SEW 从当前 slice 抽取指定元素 |

跨片状态包括：

- `prev_src0`
- `prev_func_op`
- `prev_iid`
- `prev_sew`
- `compress_carry`
- `compress_carry_cnt`

`prev_iid` 用于防止连续两条同类指令错误共享跨片状态。

### 6.3 FREDUCT reduction 实现

`ct_freduct_dp.v` 从浮点 placeholder 改为 integer reduction 数据通路，当前支持：

- `vredsum`
- `vredand/vredor/vredxor`
- `vredminu/vredmin`
- `vredmaxu/vredmax`
- `vwredsumu/vwredsum`

实现方式：

- `srcf1` lane0 作为新 reduction stream 的 seed。
- `srcf0` 当前 64-bit slice 内按 SEW 逐元素 reduce。
- `reduct_accum` 保存跨 slice 累积值。
- `prev_iid/prev_func_op/prev_sew` 判断是否开启新 stream。
- 最终结果写在 lane0，其余 lane 当前清零。

### 6.4 VFALU pipe6 结果 mux

`ct_vfalu_dp_pipe6.v` 已将 FREDUCT 结果加入最终选择逻辑。当前 pipe6 mux 包括：

- FADD
- FSPU
- Ara SIMD ALU
- FREDUCT
- VMISC
- VPERM

这保证 reduction/permute/misc 不只是产生内部结果，也能进入 VFPU forward/writeback。

## 7. 当前限制和后续事项

| 类别 | 当前状态 | 后续建议 |
| --- | --- | --- |
| 跨 64-bit 片顺序 | 当前依赖顺序流入的 slice 状态 | 后续应由 VRF/VLEN 调度显式提供前后 slice 或统一 lane sequencer |
| `vslidedown` 全局语义 | 当前为局部窗口实现 | 完整 VLEN 下需要未来 slice 访问或反向遍历支持 |
| `vrgatherei16` | 尚未完整覆盖 | 需要按 16-bit index EEW 独立 decode 和 index 提取 |
| `vcompress` 完整 VLEN | 已有 carry 雏形 | 仍需与 vstart/vl/tail policy 对齐 |
| reduction mask/tail | 当前主打 unmasked 64-bit slice reduction | 后续加入 mask、vl、vstart、tail agnostic/undisturbed |
| LMUL/EMUL | 当前未完成 group 级 rename/访问 | 需继续完善 VRT/VRF group map |
| CSR side effect | `vxsat/vstart/vl/vtype` 未完整落地 | 需 CP0/RTU 精确提交配合 |

## 8. 编译验证记录

最近一次局部验证命令和结果：

| 验证项 | 结果 |
| --- | --- |
| `ct_vperm_ctrl.v + ct_vperm_dp.v + ct_vperm_top.v + gated_clk_cell.v` | 通过 |
| `ct_freduct_ctrl.v + ct_freduct_dp.v + ct_freduct_top.v + gated_clk_cell.v` | 通过 |
| `ct_vmisc_ctrl.v + ct_vmisc_dp.v + ct_vmisc_top.v + gated_clk_cell.v` | 通过 |
| `vfalu/rtl/*.v + gated_clk_cell.v` | 通过 |
| `ct_vfpu_dp.v + gated_clk_cell.v` | 通过 |
| `ct_vfpu_top.v` 窄集合 elaboration | 端口连接已检查，完整 elaboration 停在未纳入窄集合的 `ct_vfpu_cbus/ct_vfpu_rbus/ct_vfdsu_top/ct_vfmau_top` |

## 9. 建议新增 directed tests

| 类别 | 建议用例 |
| --- | --- |
| P0 ALU | `vadd/vsub/vrsub/vand/vor/vxor/vmin/vmax/vsll/vsrl/vsra`，覆盖 SEW=8/16/32/64 |
| merge/move | `vmerge.vvm/vxm/vim`、`vmv.v.v/v.x/v.i`，覆盖 `vm=0/1` 和 mask 交替 |
| div/rem | `vdiv/vdivu/vrem/vremu`，覆盖除零、有符号 overflow、负数余数 |
| slide | `vslideup/vslidedown/vslide1up/vslide1down`，覆盖 offset=0/1/跨 64-bit 边界 |
| gather | `vrgather.vv/vx/vi`，覆盖 index 命中当前 slice、上一 slice、越界 |
| compress | mask 稀疏/密集/跨 slice carry 场景 |
| reduction | `vredsum/vredmax/vredmin/vwredsum`，覆盖新 IID 边界和连续同类指令 |

