
# RISC-V Processor — RTL Design & Verification

A Verilog RTL implementation of a 64-bit RISC-V processor developed progressively from a **single-cycle datapath** to a **5-stage pipelined microarchitecture**.

The project focuses on understanding processor datapath design, instruction decoding, control generation, pipeline organization, data forwarding, branch handling, and simulation-based verification.

---

## Project Overview

This repository contains two implementations of the RISC-V processor:

```text
RISC-V
│
├── Single-Cycle
│   └── Single-cycle RISC-V processor
│
└── Pipeline
    └── 5-stage pipelined RISC-V processor
````

The implementations use a 64-bit datapath and support a subset of the RV64I instruction set.

RISC-V is an open standard instruction-set architecture. The RV64I base ISA uses 64-bit integer registers and address space.
Official specification: [https://docs.riscv.org/reference/isa/](https://docs.riscv.org/reference/isa/)

---

# Architecture

## 1. Single-Cycle Processor

The single-cycle implementation executes each instruction through the complete datapath within one clock cycle.

```text
                    ┌──────────────────┐
                    │ Program Counter  │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ Instruction      │
                    │ Memory           │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ Instruction      │
                    │ Decode           │
                    └────────┬─────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
       ┌─────────────┐               ┌─────────────┐
       │ Register    │               │ Control     │
       │ File        │               │ Unit        │
       └──────┬──────┘               └──────┬──────┘
              │                             │
              └──────────────┬──────────────┘
                             ▼
                      ┌─────────────┐
                      │     ALU     │
                      └──────┬──────┘
                             │
                   ┌─────────┴─────────┐
                   │                   │
                   ▼                   ▼
            ┌────────────┐       Branch Logic
            │   Data     │
            │  Memory    │
            └─────┬──────┘
                  │
                  ▼
            ┌────────────┐
            │ Writeback  │
            │    MUX     │
            └─────┬──────┘
                  │
                  ▼
             Register File
```

### Single-Cycle Components

* Program Counter
* Instruction Memory
* Register File
* Immediate Generator
* Control Unit
* ALU Control
* ALU
* ALU Source MUX
* Data Memory
* Writeback MUX
* Branch/PC Selection Logic

---

# 2. Five-Stage Pipelined Processor

The pipelined implementation divides instruction execution into five stages:

```text
 IF          ID          EX          MEM          WB
 │           │           │           │           │
 ▼           ▼           ▼           ▼           ▼
Fetch  →   Decode  →   Execute  →   Memory  → Writeback
 │           │           │           │           │
 └─ IF/ID ──┘           │           │           │
             └─ ID/EX ──┘           │           │
                         └─ EX/MEM ──┘           │
                                    └─ MEM/WB ────┘
```

### Pipeline Stages

#### IF — Instruction Fetch

Fetches the instruction from instruction memory using the program counter.

```text
PC → Instruction Memory → Instruction
```

The instruction and PC are stored in the `IF/ID` pipeline register.

#### ID — Instruction Decode

The instruction is decoded and:

* Source registers are identified
* Destination register is identified
* Immediate value is generated
* Control signals are generated
* Register-file operands are read

The results are stored in `ID/EX`.

#### EX — Execute

The Execute stage performs:

* ALU operations
* Operand selection
* Data forwarding
* Branch comparison
* Branch target calculation

The results are stored in `EX/MEM`.

#### MEM — Memory Access

Load and store operations access the data memory.

```text
EX/MEM → Data Memory → MEM/WB
```

#### WB — Writeback

The final result is selected from:

```text
ALU Result
     OR
Memory Data
```

and written back to the register file.

---

# Pipeline Features

The pipelined implementation includes:

* 5-stage pipeline
* IF/ID pipeline register
* ID/EX pipeline register
* EX/MEM pipeline register
* MEM/WB pipeline register
* 64-bit datapath
* Register file
* ALU
* Control unit
* Immediate generator
* Instruction memory
* Data memory
* Data forwarding
* Forwarding multiplexers
* Branch target calculation
* Branch decision logic
* Writeback logic

---

# Data Forwarding

The pipeline contains a forwarding unit to resolve common data dependencies without waiting for register writeback.

Example:

```assembly
ADD x3, x1, x2
SUB x4, x3, x1
```

The second instruction requires the newly calculated value of `x3`.

The forwarding paths allow the value to be supplied directly from later pipeline stages:

```text
              ┌──────────────┐
EX/MEM ──────►│              │
              │  Forwarding  │──► ALU
MEM/WB ──────►│     MUX      │
              │              │
Register ────►│              │
              └──────────────┘
```

The forwarding unit generates:

```text
ForwardA
ForwardB
```

which control the forwarding multiplexers.

---

# Branch Handling

Branch instructions use the ALU comparison result and branch target calculation.

For:

```assembly
BEQ x1, x2, label
```

the processor:

1. Reads the source registers
2. Compares the operands
3. Calculates the branch target
4. Determines whether the branch is taken
5. Selects the next PC

The next PC is selected between:

```text
PC + 4
```

and:

```text
Branch Target
```

using the PC multiplexer.

---

# Supported Instruction Subset

The current implementations support a subset of RV64I instructions.

| Instruction | Type | Function               |
| ----------- | ---- | ---------------------- |
| `ADD`       | R    | Integer addition       |
| `SUB`       | R    | Integer subtraction    |
| `AND`       | R    | Bitwise AND            |
| `OR`        | R    | Bitwise OR             |
| `XOR`       | R    | Bitwise XOR            |
| `SLL`       | R    | Logical left shift     |
| `SRL`       | R    | Logical right shift    |
| `SRA`       | R    | Arithmetic right shift |
| `SLT`       | R    | Signed comparison      |
| `ADDI`      | I    | Add immediate          |
| `LD`        | I    | Load 64-bit value      |
| `SD`        | S    | Store 64-bit value     |
| `BEQ`       | B    | Branch if equal        |

> This is a processor implementation of a selected instruction subset, not a complete implementation of every RV64I instruction.

---

# Repository Structure

```text
RISC-V/
│
├── README.md
│
├── Single-Cycle/
│   │
│   ├── alu.v
│   ├── alu_control.v
│   ├── alu_src_mux.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── immediate_generator.v
│   ├── instruction_memory.v
│   ├── pc_mux.v
│   ├── program_counter.v
│   ├── register_file.v
│   ├── write_back_mux.v
│   │
│   ├── riscv_top.v
│   ├── tb_riscv_top.v
│   └── program.mem
│
└── Pipeline/
    │
    ├── alu.v
    ├── alu_control.v
    ├── alu_src_mux.v
    ├── control_unit.v
    ├── data_memory.v
    │
    ├── if_id_register.v
    ├── id_ex_register.v
    ├── ex_mem_register.v
    ├── mem_wb_register.v
    │
    ├── forwarding_unit.v
    ├── forward_mux.v
    │
    ├── immediate_generator.v
    ├── instruction_memory.v
    ├── pc_mux.v
    ├── program_counter.v
    ├── register_file.v
    │
    ├── riscv_top.v
    └── program.mem
```

---

# Single-Cycle vs Pipeline

| Feature             | Single-Cycle | 5-Stage Pipeline |
| ------------------- | -----------: | ---------------: |
| 64-bit datapath     |            ✓ |                ✓ |
| Program Counter     |            ✓ |                ✓ |
| Instruction Memory  |            ✓ |                ✓ |
| Register File       |            ✓ |                ✓ |
| ALU                 |            ✓ |                ✓ |
| Control Unit        |            ✓ |                ✓ |
| Immediate Generator |            ✓ |                ✓ |
| Data Memory         |            ✓ |                ✓ |
| Branch Logic        |            ✓ |                ✓ |
| Pipeline Registers  |            — |                ✓ |
| IF/ID               |            — |                ✓ |
| ID/EX               |            — |                ✓ |
| EX/MEM              |            — |                ✓ |
| MEM/WB              |            — |                ✓ |
| Data Forwarding     |            — |                ✓ |
| Forwarding MUX      |            — |                ✓ |

---

# Verification

The processor is verified through RTL simulation.

Verification focuses on:

* Instruction execution
* Register-file updates
* ALU operations
* Immediate generation
* Memory read/write operations
* Branch execution
* Pipeline register behavior
* Data forwarding
* Final register values
* Simulation waveforms

Important signals for waveform analysis include:

```text
PC
Instruction

IF/ID
ID/EX
EX/MEM
MEM/WB

ForwardA
ForwardB

ALU Result
Branch Target
Branch Taken

RegWrite
MemRead
MemWrite
MemToReg

Writeback Data
```

---

# Simulation

The RTL can be simulated using tools such as:

* Icarus Verilog
* ModelSim
* QuestaSim
* Vivado Simulator

Example using Icarus Verilog:

```bash
iverilog -o riscv_sim \
    alu.v \
    alu_control.v \
    alu_src_mux.v \
    control_unit.v \
    data_memory.v \
    if_id_register.v \
    id_ex_register.v \
    ex_mem_register.v \
    mem_wb_register.v \
    forwarding_unit.v \
    forward_mux.v \
    immediate_generator.v \
    instruction_memory.v \
    pc_mux.v \
    program_counter.v \
    register_file.v \
    riscv_top.v
```

Run the simulation:

```bash
vvp riscv_sim
```

For waveform analysis:

```bash
gtkwave riscv.vcd
```

---

# Verification Workflow

```text
             RTL Design
                 │
                 ▼
          Compile RTL
                 │
                 ▼
          Run Testbench
                 │
                 ▼
        Check Register/Memory
             Results
                 │
                 ▼
        Generate Waveform
                 │
                 ▼
         Analyze Pipeline
                 │
                 ▼
          Debug RTL
```

---

# Project Progression

The project was developed progressively:

```text
RISC-V ISA
    │
    ▼
Single-Cycle Datapath
    │
    ▼
Instruction Decode
    │
    ▼
Control + ALU
    │
    ▼
Memory + Branches
    │
    ▼
Pipeline Registers
    │
    ▼
5-Stage Pipeline
    │
    ▼
Data Forwarding
    │
    ▼
Pipeline Verification
```

This progression demonstrates how a basic single-cycle processor can be extended into a pipelined microarchitecture.

---

# Current Limitations

The current pipeline implementation does **not** include a dedicated load-use hazard detection/stall unit.

Therefore, the following are considered future improvements:

* Load-use hazard detection
* Pipeline stalling
* Bubble insertion
* Comprehensive control-hazard flushing
* Additional RV64I instructions
* SystemVerilog-based constrained/random verification
* Functional coverage
* Assertion-based verification
* Automated regression testing
* FPGA implementation

---

# Future Work

Planned extensions include:

### Pipeline Hazard Handling

```text
Load-Use Detection
       │
       ▼
Pipeline Stall
       │
       ▼
Bubble Insertion
```

### Control Hazards

Improve branch handling using:

* Pipeline flushing
* Earlier branch resolution
* Branch prediction

### Instruction Set

Expand support toward a larger RV64I subset and potentially additional RISC-V extensions.

### Verification

Develop a more comprehensive SystemVerilog verification environment containing:

* Directed tests
* Assertions
* Functional coverage
* Randomized instruction sequences
* Automated regression

---

# Tools Used

```text
HDL             : Verilog
Architecture    : RISC-V RV64
RTL Design      : Verilog
Simulation      : Icarus Verilog / ModelSim / QuestaSim
Waveform        : GTKWave
Target          : FPGA / RTL Simulation
```

---

# Learning Outcomes

This project provided practical experience with:

* RISC-V instruction formats
* Processor datapath design
* RTL design
* Verilog module design
* Register-file architecture
* ALU design
* Control-unit design
* Immediate generation
* Memory interfaces
* Pipeline architecture
* Pipeline registers
* Data forwarding
* Branch handling
* RTL simulation
* Waveform-based debugging

---

# References

* [RISC-V Ratified Specifications](https://docs.riscv.org/reference/home/index.html)
* [RISC-V Instruction Set Manual](https://github.com/riscv/riscv-isa-manual)

---

# Author

**Kurre Vinay**

B.Tech Electrical Engineering
Indian Institute of Technology Hyderabad



[1]: https://docs.riscv.org/reference/isa/v20240411/unpriv/colophon.html?utm_source=chatgpt.com "Preface :: RISC-V Ratified Specifications Library"
