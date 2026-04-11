# RVV 1.0 指令集文件刷新计划

## 任务目标

根据RVV 0.7.1版本的JSON和Excel文件，刷新RVV 1.0版本的对应文件，增加一个差异域段，说明相比0.7.1版本是新增、删除还是修改。

## 输入文件

- **0.7.1版本**: 
  - `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1\rvv_instructions_0.7.1.json`
  - `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1\rvv_instructions_0.7.1.xlsx`

- **1.0版本**: 
  - `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-1.0\rvv_instructions.json`
  - `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-1.0\rvv_instructions.xlsx`

## 输出文件

- 更新后的 `rvv_instructions.json` (1.0版本)
- 更新后的 `rvv_instructions.xlsx` (1.0版本)

## 版本差异分析

### 分类差异

| 分类 | 0.7.1数量 | 1.0数量 | 变化 |
|------|-----------|---------|------|
| arithmetic | 66 | 69 | +3 |
| logical | 9 | 9 | 无变化 |
| move | 14 | 21 | +7 |
| shift | 33 | 33 | 无变化 |
| compare | 32 | 30 | -2 |
| reduction | 10 | 10 | 无变化 |
| multiply-add | 29 | 29 | 无变化 |
| mask | 14 | 12 | -2 |
| fp | 61 | 66 | +5 |
| convert | 14 | 21 | +7 |
| special | 3 | 5 | +2 |
| load | 40 | 24 | -16 |
| store | 16 | 20 | +4 |
| configuration | 0 | 3 | +3 (新增分类) |
| atomic | 0 | 7 | +7 (新增分类) |
| dot | 10 | 0 | -10 (删除分类) |
| clip | 6 | 0 | -6 (删除分类) |

### 主要指令命名差异

| 0.7.1版本 | 1.0版本 | 变化类型 |
|-----------|---------|----------|
| vlb/vlbu/vlh/vlhu/vlw/vlwu/vld | vle8/vle16/vle32/vle64 | 修改：加载指令重命名 |
| vsb/vsh/vsw/vsd | vse8/vse16/vse32/vse64 | 修改：存储指令重命名 |
| vlsb/vlsh/vlsw/vlsd | vlse8/vlse16/vlse32/vlse64 | 修改：跨步加载重命名 |
| vlxb/vlxh/vlxw/vlxd | vluxei8/vluxei16/vluxei32/vluxei64 | 修改：索引加载重命名 |
| vmpopc | vcpop | 修改：掩码计数重命名 |
| vmfirst | vfirst | 修改：掩码首位重命名 |
| vdotu/vdot | - | 删除：点积指令移除 |
| vclipb/vcliph/vclipw | vnclip | 修改：截断指令重命名 |
| - | vsetvli/vsetivli/vsetvl | 新增：配置指令 |
| - | vle8ff/vle16ff等 | 新增：Fault-Only-First加载 |
| - | vfrec7/vfrsqrt7 | 新增：近似指令 |
| - | vamo* | 新增：原子操作指令 |

## 实施步骤

### 步骤1：创建差异分析脚本

创建 `update_rvv_1.0_with_diff.py`，包含：

1. **加载两个版本的JSON文件**
   ```python
   with open('rvv_instructions_0.7.1.json', 'r') as f:
       v071_data = json.load(f)
   with open('rvv_instructions.json', 'r') as f:
       v10_data = json.load(f)
   ```

2. **构建指令索引**
   - 使用 `(name, funct6, funct3)` 作为唯一标识
   - 构建两个版本的指令字典

3. **差异检测算法**
   ```python
   def detect_diff(inst_071, inst_10):
       if inst_071 is None:
           return {"type": "新增", "details": "1.0版本新增指令"}
       if inst_10 is None:
           return {"type": "删除", "details": "1.0版本移除指令"}
       
       changes = []
       if inst_071["name"] != inst_10["name"]:
           changes.append(f"名称: {inst_071['name']} -> {inst_10['name']}")
       if inst_071["operands"] != inst_10["operands"]:
           changes.append(f"操作数: {inst_071['operands']} -> {inst_10['operands']}")
       # ... 其他字段比较
       
       if changes:
           return {"type": "修改", "details": "; ".join(changes)}
       return {"type": "无变化", "details": ""}
   ```

4. **差异类型定义**
   - **新增**: 0.7.1不存在，1.0新增
   - **删除**: 0.7.1存在，1.0移除
   - **修改**: 两个版本都存在但有差异
   - **无变化**: 两个版本完全相同

### 步骤2：生成差异映射表

创建指令名称映射表，处理重命名情况：

```python
NAME_MAPPING = {
    # 加载指令
    "vlb": "vle8", "vlbu": "vle8",
    "vlh": "vle16", "vlhu": "vle16",
    "vlw": "vle32", "vlwu": "vle32",
    "vld": "vle64",
    # 存储指令
    "vsb": "vse8", "vsh": "vse16",
    "vsw": "vse32", "vsd": "vse64",
    # 掩码指令
    "vmpopc": "vcpop", "vmfirst": "vfirst",
    # 截断指令
    "vclipb": "vnclip", "vcliph": "vnclip", "vclipw": "vnclip",
}
```

### 步骤3：更新JSON文件

为每条指令添加 `diff_info` 字段：

```json
{
  "name": "vle8",
  "category": "加载类 (Load)",
  "diff_info": {
    "type": "修改",
    "v071_name": "vlb",
    "details": "名称: vlb -> vle8; 操作数格式变化"
  }
}
```

对于新增指令：
```json
{
  "name": "vsetvli",
  "category": "配置类 (Configuration)",
  "diff_info": {
    "type": "新增",
    "v071_name": null,
    "details": "1.0版本新增配置指令"
  }
}
```

对于删除指令：
```json
{
  "name": "vdotu",
  "category": "点积类 (Dot Product)",
  "diff_info": {
    "type": "删除",
    "v10_name": null,
    "details": "1.0版本移除点积指令"
  }
}
```

### 步骤4：更新Excel文件

在Excel中增加工作表和列：

1. **差异总览工作表**
   - 新增指令数量
   - 删除指令数量
   - 修改指令数量
   - 无变化指令数量

2. **指令总表增加列**
   - 差异类型
   - 0.7.1指令名
   - 差异详情

3. **新增指令工作表**
   - 列出所有1.0新增的指令

4. **删除指令工作表**
   - 列出所有1.0移除的指令

5. **修改指令工作表**
   - 列出所有有变化的指令及其修改点

### 步骤5：生成差异报告

在JSON中添加差异统计：

```json
{
  "diff_summary": {
    "total_added": 45,
    "total_removed": 20,
    "total_modified": 35,
    "total_unchanged": 257,
    "added_categories": ["configuration", "atomic"],
    "removed_categories": ["dot", "clip"],
    "major_changes": [
      "加载/存储指令命名规范化",
      "新增Fault-Only-First加载指令",
      "新增向量配置指令",
      "新增原子操作指令",
      "移除点积指令",
      "移除截断指令"
    ]
  }
}
```

## 详细差异清单

### 新增指令（1.0新增）

1. **配置指令** (3条)
   - vsetvli, vsetivli, vsetvl

2. **Fault-Only-First加载** (约8条)
   - vle8ff, vle16ff, vle32ff, vle64ff
   - vle8ff.v等变体

3. **近似指令** (2条)
   - vfrec7, vfrsqrt7

4. **原子操作** (7条)
   - vamoswapei8.v, vamoaddei8.v等

5. **浮点转换扩展** (约10条)
   - 新增更多浮点转换指令

6. **其他新增** (约15条)
   - vrgatherei16, vcompress.vm等

### 删除指令（1.0移除）

1. **点积指令** (10条)
   - vdotu, vdot, vfdot
   - vwsmaccu, vwsmacc, vwsmaccsu, vwsmaccus

2. **截断指令** (6条)
   - vclipb, vclipbu, vcliph, vcliphu, vclipw, vclipwu

3. **旧版加载指令** (约20条)
   - vlb, vlbu, vlh, vlhu, vlw, vlwu, vld
   - vlsb, vlsbu等跨步加载
   - vlxb, vlxbu等索引加载

### 修改指令（名称或功能变化）

1. **加载指令重命名**
   - vlb -> vle8
   - vlh -> vle16
   - vlw -> vle32
   - vld -> vle64

2. **存储指令重命名**
   - vsb -> vse8
   - vsh -> vse16
   - vsw -> vse32
   - vsd -> vse64

3. **掩码指令重命名**
   - vmpopc -> vcpop
   - vmfirst -> vfirst

4. **操作数格式变化**
   - 多数指令的操作数格式从 `vd, vs1, vs2, m` 改为 `vd, vs1, vs2[, vm]`

## 注意事项

1. **指令标识**: 使用 `(name, funct6, funct3)` 组合作为唯一标识
2. **重命名处理**: 需要特别处理指令重命名情况，避免误判为删除+新增
3. **分类变化**: 1.0新增了configuration和atomic分类，移除了dot和clip分类
4. **统计一致性**: 确保差异统计与实际指令数量一致
