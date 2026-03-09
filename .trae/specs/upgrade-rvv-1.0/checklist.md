# RVV 1.0 升级检查清单

## Phase 1: CSR 寄存器升级

- [ ] vtype CSR 格式符合 RVV 1.0 规范
- [ ] vlmul 字段宽度为 3 位
- [ ] vma 字段位于 bit 7
- [ ] vta 字段位于 bit 6
- [ ] vill 位于最高位 (bit XLEN-1)
- [ ] vediv 字段已移除
- [ ] vlenb CSR (0xC22) 已实现
- [ ] vlenb 返回正确的 VLEN/8 值
- [ ] vlenb 为只读寄存器
- [ ] vcsr CSR (0x00F) 已实现
- [ ] vcsr 包含 vxrm[1:0] 和 vxsat 字段
- [ ] vcsr 读写功能正常

## Phase 2: 指令支持升级

- [ ] vsetivli 指令译码正确
- [ ] vsetivli 立即数提取正确 (zimm5)
- [ ] vsetivli 执行结果正确
- [ ] vsetvli AVL=0 时 VL=0
- [ ] VLMAX 计算支持分数 LMUL
- [ ] vsetvl{i} 指令正确处理保留的 vlmul 编码 (100)

## Phase 3: 向量执行单元升级

- [ ] VFPU vlmul 信号宽度已更新为 3 位
- [ ] VFPU 支持分数 LMUL 计算
- [ ] VFPU 向量寄存器访问支持分数 LMUL
- [ ] vta 信号正确传播到执行单元
- [ ] vma 信号正确传播到执行单元
- [ ] 尾部元素处理逻辑已实现
- [ ] 屏蔽元素处理逻辑已实现
- [ ] MLEN 相关计算已移除
- [ ] 掩码位统一使用最低有效位

## Phase 4: 验证与测试

- [ ] vtype 新格式测试通过
- [ ] 分数 LMUL 测试通过
- [ ] vlenb CSR 测试通过
- [ ] vcsr CSR 测试通过
- [ ] vsetivli 指令测试通过
- [ ] 尾部元素策略测试通过
- [ ] 屏蔽元素策略测试通过
- [ ] 现有向量指令测试套件通过
- [ ] 向后兼容性验证通过
- [ ] 性能基准测试通过

## Phase 5: 文档更新

- [ ] CSR 寄存器文档已更新
- [ ] 向量扩展模块文档已更新
- [ ] RVV 1.0 迁移指南已添加

---

*文档版本: 1.0*
*创建日期: 2026-03-09*
