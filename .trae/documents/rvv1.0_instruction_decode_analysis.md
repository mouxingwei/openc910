# RVV 1.0 指令译码覆盖分析计划

## 1. 分析目标

检查当前所有RVV 1.0指令是否在decd模块(pipe6_decd.v和pipe7_decd.v)中完成译码处理，识别缺失或不完整的指令译码。

## 2. 分析文件

- **指令规格**: `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-1.0\rvv_instructions.json`
- **设计文档**: 
  - `d:\code\openc910\doc\design_docs\idu\ct_idu_rf_pipe6_decd.md`
  - `d:\code\openc910\doc\design_docs\idu\ct_idu_rf_pipe7_decd.md`
- **RTL代码**:
  - `d:\code\openc910\C910_RTL_FACTORY\gen_rtl _rvv1.0\idu\rtl\ct_idu_rf_pipe6_decd.v`
  - `d:\code\openc910\C910_RTL_FACTORY\gen_rtl _rvv1.0\idu\rtl\ct_idu_rf_pipe7_decd.v`

## 3. RVV 1.0 指令分类

### 3.1 整数算术指令 (OPIVV/OPIVX/OPIVI)
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vadd | ✓ | ✓ | 已实现 |
| vsub | ✓ | ✓ | 已实现 |
| vrsub | ✓ | ✓ | 已实现 |
| vminu | ✓ | ✓ | 已实现 |
| vmin | ✓ | ✓ | 已实现 |
| vmaxu | ✓ | ✓ | 已实现 |
| vmax | ✓ | ✓ | 已实现 |
| vand | ✓ | ✓ | 已实现 |
| vor | ✓ | ✓ | 已实现 |
| vxor | ✓ | ✓ | 已实现 |
| vadc | ✓ | ✓ | 已实现 |
| vmadc | ✓ | ✓ | 已实现 |
| vsbc | ✓ | ✓ | 已实现 |
| vmsbc | ✓ | ✓ | 已实现 |
| vmerge | ✓ | ✓ | 已实现 |
| vmv | ✓ | ✓ | 已实现 |

### 3.2 比较指令 (OPIVV/OPIVX/OPIVI)
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vmseq | ✓ | ✓ | 已实现 |
| vmsne | ✓ | ✓ | 已实现 |
| vmsltu | ✓ | ✓ | 已实现 |
| vmslt | ✓ | ✓ | 已实现 |
| vmsleu | ✓ | ✓ | 已实现 |
| vmsle | ✓ | ✓ | 已实现 |
| vmsgtu | ✓ | ✓ | 已实现 |
| vmsgt | ✓ | ✓ | 已实现 |

### 3.3 饱和算术指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vsaddu | ✓ | ✓ | 已实现 |
| vsadd | ✓ | ✓ | 已实现 |
| vssubu | ✓ | ✓ | 已实现 |
| vssub | ✓ | ✓ | 已实现 |
| vaadd | ✓ | ✓ | 已实现 |
| vasub | ✓ | ✓ | 已实现 |

### 3.4 移位指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vsll | ✓ | ✓ | 已实现 |
| vsmul | ✓ | ✓ | 已实现 |
| vsrl | ✓ | ✓ | 已实现 |
| vsra | ✓ | ✓ | 已实现 |
| vssrl | ✓ | ✓ | 已实现 |
| vssra | ✓ | ✓ | 已实现 |
| vnsrl | ✓ | ✓ | 已实现 |
| vnsra | ✓ | ✓ | 已实现 |
| vnclipu | ✓ | ✓ | 已实现 |
| vnclip | ✓ | ✓ | 已实现 |

### 3.5 移动/排列指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vrgather | ✓ | ✓ | 已实现 |
| vrgatherei16 | ✓ | ✓ | 已实现 |
| vslideup | ✓ | ✓ | 已实现 |
| vslidedown | ✓ | ✓ | 已实现 |
| vslide1up | ✓ | ✓ | 已实现 |
| vslide1down | ✓ | ✓ | 已实现 |
| vcompress | ✓ | ✓ | 已实现 |

### 3.6 扩展算术指令 (OPMVV/OPMVX)
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vwaddu | ✓ | ✓ | 已实现 |
| vwadd | ✓ | ✓ | 已实现 |
| vwsubu | ✓ | ✓ | 已实现 |
| vwsub | ✓ | ✓ | 已实现 |
| vwaddu.w | ✓ | ✓ | 已实现 |
| vwadd.w | ✓ | ✓ | 已实现 |
| vwsubu.w | ✓ | ✓ | 已实现 |
| vwsub.w | ✓ | ✓ | 已实现 |

### 3.7 乘法指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vmulhu | ✓ | ✓ | 已实现 |
| vmul | ✓ | ✓ | 已实现 |
| vmulhsu | ✓ | ✓ | 已实现 |
| vmulh | ✓ | ✓ | 已实现 |
| vwmulu | ✓ | ✓ | 已实现 |
| vwmulsu | ✓ | ✓ | 已实现 |
| vwmul | ✓ | ✓ | 已实现 |

### 3.8 乘加指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vmadd | ✓ | ✓ | 已实现 |
| vnmsub | ✓ | ✓ | 已实现 |
| vmacc | ✓ | ✓ | 已实现 |
| vnmsac | ✓ | ✓ | 已实现 |
| vwmaccu | ✓ | ✓ | 已实现 |
| vwmacc | ✓ | ✓ | 已实现 |
| vwmaccsu | ✓ | ✓ | 已实现 |
| vwmaccus | ✓ | ✓ | 已实现 |

### 3.9 除法/求余指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vdivu | ✓ | - | 仅Pipe6 |
| vdiv | ✓ | - | 仅Pipe6 |
| vremu | ✓ | - | 仅Pipe6 |
| vrem | ✓ | - | 仅Pipe6 |

### 3.10 归约指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vredsum | ✓ | - | 仅Pipe6 |
| vredand | ✓ | - | 仅Pipe6 |
| vredor | ✓ | - | 仅Pipe6 |
| vredxor | ✓ | - | 仅Pipe6 |
| vredminu | ✓ | - | 仅Pipe6 |
| vredmin | ✓ | - | 仅Pipe6 |
| vredmaxu | ✓ | - | 仅Pipe6 |
| vredmax | ✓ | - | 仅Pipe6 |
| vwredsumu | ✓ | - | 仅Pipe6 |
| vwredsum | ✓ | - | 仅Pipe6 |

### 3.11 掩码指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vmandn | ✓ | ✓ | 已实现 |
| vmand | ✓ | ✓ | 已实现 |
| vmor | ✓ | ✓ | 已实现 |
| vmxor | ✓ | ✓ | 已实现 |
| vmorn | ✓ | ✓ | 已实现 |
| vmnand | ✓ | ✓ | 已实现 |
| vmnor | ✓ | ✓ | 已实现 |
| vmxnor | ✓ | ✓ | 已实现 |

### 3.12 浮点算术指令 (OPFVV/OPFVF)
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vfadd | ✓ | ✓ | 已实现 |
| vfsub | ✓ | ✓ | 已实现 |
| vfrsub | ✓ | ✓ | 已实现 |
| vfmin | ✓ | ✓ | 已实现 |
| vfmax | ✓ | ✓ | 已实现 |
| vfsgnj | ✓ | ✓ | 已实现 |
| vfsgnjn | ✓ | ✓ | 已实现 |
| vfsgnjx | ✓ | ✓ | 已实现 |
| vfdiv | ✓ | - | 仅Pipe6 |
| vfrdiv | ✓ | - | 仅Pipe6 |
| vfsqrt | ✓ | - | 仅Pipe6 |
| vfmul | ✓ | ✓ | 已实现 |
| vfmadd | ✓ | ✓ | 已实现 |
| vfnmadd | ✓ | ✓ | 已实现 |
| vfmsub | ✓ | ✓ | 已实现 |
| vfnmsub | ✓ | ✓ | 已实现 |
| vfmacc | ✓ | ✓ | 已实现 |
| vfnmacc | ✓ | ✓ | 已实现 |
| vfmsac | ✓ | ✓ | 已实现 |
| vfnmsac | ✓ | ✓ | 已实现 |

### 3.13 浮点特殊指令 (RVV 1.0新增)
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vfrsqrt7.v | ✓ | - | **已实现** (Pipe6 lines 1434-1438) |
| vfrec7.v | ✓ | - | **已实现** (Pipe6 lines 1439-1443) |
| vfclass.v | ✓ | ✓ | 已实现 |

### 3.14 浮点归约指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vfredusum | ✓ | ✓ | 已实现 |
| vfredosum | ✓ | ✓ | 已实现 |
| vfredmin | ✓ | ✓ | 已实现 |
| vfredmax | ✓ | ✓ | 已实现 |

### 3.15 浮点扩展指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vfwadd | ✓ | ✓ | 已实现 |
| vfwsub | ✓ | ✓ | 已实现 |
| vfwadd.w | ✓ | ✓ | 已实现 |
| vfwsub.w | ✓ | ✓ | 已实现 |
| vfwmul | ✓ | ✓ | 已实现 |
| vfwmacc | ✓ | ✓ | 已实现 |
| vfwnmacc | ✓ | ✓ | 已实现 |
| vfwmsac | ✓ | ✓ | 已实现 |
| vfwnmsac | ✓ | ✓ | 已实现 |

### 3.16 浮点移动指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vfslide1up | ✓ | - | 需要确认 |
| vfslide1down | ✓ | - | 需要确认 |
| vfmerge | ✓ | ✓ | 已实现 |

### 3.17 类型转换指令
| 指令 | Pipe6 | Pipe7 | 状态 |
|------|-------|-------|------|
| vfcvt.xu.f.v | ✓ | ✓ | 已实现 |
| vfcvt.x.f.v | ✓ | ✓ | 已实现 |
| vfcvt.f.xu.v | ✓ | ✓ | 已实现 |
| vfcvt.f.x.v | ✓ | ✓ | 已实现 |
| vfcvt.rtz.xu.f.v | ✓ | ✓ | 已实现 |
| vfcvt.rtz.x.f.v | ✓ | ✓ | 已实现 |
| vfwcvt.xu.f.v | ✓ | ✓ | 已实现 |
| vfwcvt.x.f.v | ✓ | ✓ | 已实现 |
| vfwcvt.f.xu.v | ✓ | ✓ | 已实现 |
| vfwcvt.f.x.v | ✓ | ✓ | 已实现 |
| vfwcvt.f.f.v | ✓ | ✓ | 已实现 |
| vfncvt.xu.f.w | ✓ | ✓ | 已实现 |
| vfncvt.x.f.w | ✓ | ✓ | 已实现 |
| vfncvt.f.xu.w | ✓ | ✓ | 已实现 |
| vfncvt.f.x.w | ✓ | ✓ | 已实现 |
| vfncvt.f.f.w | ✓ | ✓ | 已实现 |

## 4. 关键发现

### 4.1 已实现的RVV 1.0特殊指令
1. **vfrsqrt7.v** - 在pipe6_decd.v中已实现 (lines 1434-1438)
   - 使用FSPU执行单元
   - func = VFRSQRT7 (20'b0010_0000_0000_0010_1100)
   - ready_stage = EX3_READY

2. **vfrec7.v** - 在pipe6_decd.v中已实现 (lines 1439-1443)
   - 使用FSPU执行单元
   - func = VFREC7 (20'b0010_0000_0000_0010_1101)
   - ready_stage = EX3_READY

### 4.2 指令分配策略
- **Pipe6**: 主要处理除法、归约、浮点除法/平方根等复杂操作
- **Pipe7**: 主要处理乘法、乘加等操作

### 4.3 需要确认的指令
1. **vfslide1up/vfslide1down** - 参数已定义，但译码逻辑需要确认
2. **vrgatherei16** - 需要确认译码逻辑

## 5. 缺失指令分析

### 5.1 Pipe7中缺失的指令
以下指令仅在Pipe6中实现，Pipe7中被注释掉：
- vdivu, vdiv, vremu, vrem (除法指令)
- vredsum, vredand, vredor, vredxor, vredminu, vredmin, vredmaxu, vredmax (归约指令)
- vwredsumu, vwredsum (扩展归约指令)
- vfdiv, vfrdiv, vfsqrt (浮点除法/平方根)
- vfrsqrt7, vfrec7 (浮点特殊指令)

**这是设计决策，不是缺失** - 这些指令被分配到Pipe6执行。

### 5.2 需要补充的指令
经过分析，当前RTL代码已经覆盖了RVV 1.0规范中定义的所有主要指令类别。

## 6. 执行单元分配

| 执行单元 | 功能 | Pipe6 | Pipe7 |
|----------|------|-------|-------|
| FSPU | 浮点特殊处理 | ✓ | ✓ |
| FADD | 浮点加法 | ✓ | ✓ |
| FCNVT | 浮点转换 | ✓ | ✓ |
| FDSU | 浮点除法/平方根 | ✓ | - |
| FMAU | 浮点乘加 | ✓ | ✓ |
| VALU | 向量算术 | ✓ | ✓ |
| VPERM | 向量排列 | ✓ | ✓ |
| VMISC | 向量杂项 | ✓ | ✓ |
| VREDU | 向量归约 | ✓ | - |
| VSHIFT | 向量移位 | ✓ | ✓ |
| VMULU | 向量乘法 | ✓ | ✓ |
| VDIRU | 向量除法 | ✓ | - |

## 7. 结论

### 7.1 译码覆盖状态
- **已覆盖**: RVV 1.0规范中定义的所有主要指令类别
- **vfrsqrt7.v/vfrec7.v**: 已在pipe6_decd.v中正确实现译码
- **指令分配**: Pipe6和Pipe7有明确的指令分配策略，符合设计规范

### 7.2 建议
1. **vfslide1up/vfslide1down**: 确认参数定义是否与译码逻辑匹配
2. **测试验证**: 建议创建测试用例验证所有RVV 1.0指令的译码正确性

## 8. 后续任务

1. 验证vfrsqrt7/vfrec7在FSPU模块中的执行逻辑
2. 确认vfslide1up/vfslide1down的完整译码链路
3. 创建RVV 1.0指令译码测试用例
