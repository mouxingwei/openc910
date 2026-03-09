# Tasks

## Phase 1: CSR 寄存器升级

- [ ] Task 1: 升级 vtype CSR 格式
  - [ ] SubTask 1.1: 修改 vtype 寄存器定义，将 vlmul 从 2 位扩展为 3 位
  - [ ] SubTask 1.2: 添加 vma (bit 7) 和 vta (bit 6) 字段
  - [ ] SubTask 1.3: 移除 vediv 字段
  - [ ] SubTask 1.4: 调整 vill 位位置到最高位
  - [ ] SubTask 1.5: 更新 vtype 读写逻辑

- [ ] Task 2: 添加 vlenb CSR (0xC22)
  - [ ] SubTask 2.1: 在 CP0 添加 vlenb CSR 定义
  - [ ] SubTask 2.2: 实现 vlenb 只读逻辑，返回 VLEN/8
  - [ ] SubTask 2.3: 添加 vlenb CSR 访问译码

- [ ] Task 3: 添加 vcsr CSR (0x00F)
  - [ ] SubTask 3.1: 在 CP0 添加 vcsr CSR 定义
  - [ ] SubTask 3.2: 实现 vcsr 读写逻辑
  - [ ] SubTask 3.3: 连接 vxrm 和 vxsat 到 vcsr

## Phase 2: 指令译码升级

- [ ] Task 4: 添加 vsetivli 指令支持
  - [ ] SubTask 4.1: 在 IDU 添加 vsetivli 指令译码
  - [ ] SubTask 4.2: 实现 zimm5 立即数提取
  - [ ] SubTask 4.3: 连接到 vsetvl 执行路径

- [ ] Task 5: 更新 vsetvli 行为
  - [ ] SubTask 5.1: 修改 AVL=0 时的 VL 计算逻辑
  - [ ] SubTask 5.2: 更新 VLMAX 计算支持分数 LMUL

- [ ] Task 6: 更新向量指令译码
  - [ ] SubTask 6.1: 更新 vlmul 字段宽度从 2 位到 3 位
  - [ ] SubTask 6.2: 添加分数 LMUL 检查逻辑
  - [ ] SubTask 6.3: 更新向量寄存器分组逻辑

## Phase 3: 向量执行单元升级

- [ ] Task 7: 升级 VFPU 支持分数 LMUL
  - [ ] SubTask 7.1: 更新 vlmul 信号宽度
  - [ ] SubTask 7.2: 实现 VLMAX 计算支持分数 LMUL
  - [ ] SubTask 7.3: 更新向量寄存器访问逻辑

- [ ] Task 8: 实现尾部/屏蔽元素策略
  - [ ] SubTask 8.1: 添加 vta 信号传播
  - [ ] SubTask 8.2: 添加 vma 信号传播
  - [ ] SubTask 8.3: 实现尾部元素处理逻辑
  - [ ] SubTask 8.4: 实现屏蔽元素处理逻辑

- [ ] Task 9: 更新掩码寄存器处理
  - [ ] SubTask 9.1: 移除 MLEN 相关计算
  - [ ] SubTask 9.2: 统一掩码位位置到最低有效位
  - [ ] SubTask 9.3: 更新掩码相关指令

## Phase 4: 验证与测试

- [ ] Task 10: 更新仿真测试用例
  - [ ] SubTask 10.1: 添加 vtype 新格式测试
  - [ ] SubTask 10.2: 添加分数 LMUL 测试
  - [ ] SubTask 10.3: 添加 vlenb CSR 测试
  - [ ] SubTask 10.4: 添加 vcsr CSR 测试
  - [ ] SubTask 10.5: 添加 vsetivli 指令测试
  - [ ] SubTask 10.6: 添加尾部/屏蔽元素策略测试

- [ ] Task 11: 回归测试
  - [ ] SubTask 11.1: 运行现有向量指令测试套件
  - [ ] SubTask 11.2: 验证向后兼容性
  - [ ] SubTask 11.3: 性能基准测试

## Phase 5: 文档更新

- [ ] Task 12: 更新设计文档
  - [ ] SubTask 12.1: 更新 CSR 寄存器文档
  - [ ] SubTask 12.2: 更新向量扩展模块文档
  - [ ] SubTask 12.3: 添加 RVV 1.0 迁移指南

# Task Dependencies

- [Task 2] depends on [Task 1]
- [Task 3] depends on [Task 1]
- [Task 4] depends on [Task 1]
- [Task 5] depends on [Task 1]
- [Task 6] depends on [Task 1]
- [Task 7] depends on [Task 1, Task 6]
- [Task 8] depends on [Task 1, Task 7]
- [Task 9] depends on [Task 7]
- [Task 10] depends on [Task 1-9]
- [Task 11] depends on [Task 10]
- [Task 12] depends on [Task 11]

# Estimated Effort

| Phase | Tasks | Complexity | Priority |
|-------|-------|------------|----------|
| Phase 1 | 1-3 | High | Critical |
| Phase 2 | 4-6 | High | Critical |
| Phase 3 | 7-9 | Very High | Critical |
| Phase 4 | 10-11 | Medium | High |
| Phase 5 | 12 | Low | Medium |

---

*文档版本: 1.0*
*创建日期: 2026-03-09*
