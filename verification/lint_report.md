# RVV 1.0 Static Lint Report

## Check Information

| Item | Value |
|------|-------|
| Check Tool | iverilog -g2012 -Wall |
| Check Time | 2026-04-04 00:03:26 |
| Modules Checked | 4 |

---

## Summary

| Level | Count |
|-------|-------|
| Errors | 22 |
| Warnings | 19 |
| Passed Modules | 0 |
| Failed Modules | 4 |

---

## Module Results

### CP0 Module

Status: **FAIL**

#### Errors

- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3499: error: syntax error in continuous assignment`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3504: error: syntax error in continuous assignment`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3509: error: syntax error in continuous assignment`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3514: error: syntax error in continuous assignment`

#### Warnings

- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:2626: warning: implicit definition of wire 'cp0_idu_vma'.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:2627: warning: implicit definition of wire 'cp0_idu_vta'.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3499: warning: macro REVISION undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3504: warning: macro SUB_VERSION undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3509: warning: macro PATCH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\cp0\rtl\ct_cp0_regs.v:3514: warning: macro PRODUCT_ID undefined (and assumed null) at this point.`


### IDU Module

Status: **FAIL**


### LSU Module

Status: **FAIL**

#### Errors

- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:560: error: Unknown module type: gated_clk_cell`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1332: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1402: error: Unknown module type: ct_rtu_compare_iid`

#### Warnings

- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:819: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:819: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1058: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1058: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1076: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1076: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1079: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1079: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1082: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1082: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1359: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1360: warning: macro PA_WIDTH undefined (and assumed null) at this point.`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\lsu\rtl\ct_lsu_ld_ag.v:1361: warning: macro PA_WIDTH undefined (and assumed null) at this point.`


### RTU Module

Status: **FAIL**

#### Errors

- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:348: error: Unknown module type: gated_clk_cell`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:372: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:382: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:392: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:402: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:412: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:422: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:432: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:442: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:452: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:462: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:696: error: Unknown module type: gated_clk_cell`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:783: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:793: error: Unknown module type: ct_rtu_compare_iid`
- `..\C910_RTL_FACTORY\gen_rtl _rvv1.0\rtu\rtl\ct_rtu_rob_expt.v:803: error: Unknown module type: ct_rtu_compare_iid`

---

## Recommendations

1. Fix all syntax errors before synthesis
2. Review warnings for potential issues
3. Ensure all module dependencies are resolved

---

*Report generated by RVV 1.0 Static Lint Script*
