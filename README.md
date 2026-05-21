# RISC-V_Single_Cycle_Core
Microprocessor with Architecture RISC-V in SystemVerilog.

This project implements a 32-bit single-cycle RISC-V core (RV32I) capable of executing a subset of the RISC-V base integer instruction set.

## 1. Project Overview
This project implements a **single-cycle RISC-V CPU** in SystemVerilog.  
Each instruction completes in a single clock cycle.

> ⚠️ Note: This core is still in a testing and development phase.

Key points:

- Modular design with separate ALU, Control Unit, Register File, and Memory blocks.
- Supports a subset of RV32I base instructions (arithmetic, logical, memory, branch e jump operations).
- Includes a simple testbench for simulation using Icarus Verilog (`iverilog`) and VCD waveform output with GTKWave.
- Separation between **datapath** and **control logic** allows future instruction-level expansion.

## 2. Supported Instruction Set (ISA)
The core implements a fundamental subset of the **RV32I** base integer instruction set. These instructions were selected to validate all major paths of the single-cycle microarchitecture including computational, memory access, and flow control operations.

| Instruction     | Format  | Functional Category | Description |
|-----------------|---------|--------------------|------------|
| ADD, SUB       | R-type  | Arithmetic         | Standard addition and subtraction between registers. |
| AND, OR        | R-type  | Logical            | Bitwise logical operations. |
| SLT            | R-type  | Comparison         | Set Less Than (signed comparison). |
| ADDI           | I-type  | Arithmetic Imm     | Addition with a 12-bit sign-extended immediate. |
| LW             | I-type  | Load               | Load 32-bit word from Data Memory to register. |
| SW             | S-type  | Store              | Store 32-bit word from register to Data Memory. |
| BEQ            | B-type  | Branch             | Conditional jump if two registers are equal. |


## 3. Microarchitecture & Datapath
### 3.1 Module Diagram
![RISC-V Single Cycle Module Diagram](https://github.com/LeoIgreja11/RISC-V_Single_Cycle_Core/blob/main/image/RV32I-Single-Cycle-Core-drawio.png)

### 3.2 Datapath Description
The core datapath consists of the following modules and components:

- **Program Counter (PC)**
  - 32-bit register storing the address of the current instruction.
  - Increments by 4 each cycle or updates based on branch outcomes.

- **Instruction Memory**
  - Stores instructions in 32-bit word-aligned format.
  - Provides the instruction to the decoder each cycle.

- **Register File**
  - 32 general-purpose registers (x0-x31).
  - Register x0 is hardwired to 0.
  - Provides source operands to the ALU and receives write-back data.

- **ALU (Arithmetic Logic Unit)**
  - Performs arithmetic and logical operations such as ADD, SUB, AND, OR.
  - Generates the Zero flag for branch decisions.

- **Control Unit**
  - Main Decoder: decodes opcode to generate high-level control signals (RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSRc, Branch and ALUControl).
  - ALU Decoder: generates ALU operation codes based on funct3 and funct7.
  - *(A more detailed description of the Control Unit signals and mapping is provided in Section 5.)*

- **Data Memory**
  - Stores and retrieves data for load (`lw`) and store (`sw`) instructions.
  - 32-bit wide, synchronous with the clock.

- **Branch Logic**
  - Determines if a conditional branch (e.g., `beq`, `bne`) is taken.
  - Updates the PC accordingly.

All signals between modules are synchronous and propagate within a single clock cycle.

## 4. Control Unit & Signal Mapping
The Control Unit acts as the "brain" of the processor, decoding the 32-bit instruction to coordinate the datapath modules. It is implemented using a two-level decoding scheme:

  1. Main Decoder: Generates high-level control signals based on the opcode.
  2. ALU Decoder: Refines the ALUOp from the Main Decoder using funct3 and funct7 bits to determine the specific ALU operation.

## Control Signals Truth Table

The following table maps the instructions to their respective internal control signals:

| Instruction | Opcode  | RegWrite | ImmSrc | ALUSrc | MemWrite | ResultSrc | Branch | ALUOp |
|------------|----------|----------|--------|--------|----------|------------|--------|--------|
| R-type     | 0110011  | 1        | xx     | 0      | 0        | 00         | 0      | 10     |
| lw         | 0000011  | 1        | 00     | 1      | 0        | 01         | 0      | 00     |
| sw         | 0100011  | 0        | 01     | 1      | 1        | xx         | 0      | 00     |
| beq        | 1100011  | 0        | 10     | 0      | 0        | xx         | 1      | 01     |
| addi       | 0010011  | 1        | 00     | 1      | 0        | 00         | 0      | 10     |

---

### Control Signal Description

- **RegWrite:** Enables writing to the Register File.  
- **ALUSrc:** Selects between Register `rd2` or Immediate for the second ALU operand.  
- **ResultSrc:** Selects the data source for the register write-back (ALUResult or Data Memory).  

## 5. Verification & Simulation Environment
To verify the RISC-V single-cycle core, we ran a simple "Add and Store Word" program:

### Assembly code
```asm
addi x5, x0, 15      # x5 = 15 -> memory address
addi x6, x0, 15      # x6 = 15 -> data to store
sw   x6, 0(x5)       # store x6 into memory at address x5
```

### Instruction_Memory.v
```verilog
initial begin
    mem[0] = 32'h00F00293; // addi x5, x0, 15
    mem[1] = 32'h00F00313; // addi x6, x0, 15
    mem[2] = 32'h0062A023; // sw x6, 0(x5)
end
```

### Data_Memory.v
```verilog
initial begin
    mem[0] = 32'h0000000F; // optional initial value, will be overwritten by store word(sw)
end
```

### Register_File.v
```verilog
integer i;
initial begin
    for(i=0; i<32; i=i+1)
        Register[i] = 32'h0;       // initialization with all registers to 0
    Register[0] = 32'h00000000;    // x0 always 0
    Register[5] = 32'h0000000F;    // set initial value for x5 (used as memory address)
end
```
![Add and Store Word Simulation](https://github.com/LeoIgreja11/RISC-V_Single_Cycle_Core/raw/main/image/ADD_STORE_WORD.png)

To verify conditional execution, we ran a simple "Branch Test" program:

### Assembly code
```asm
addi x5, x0, 5        # x5 = 5 -> memory address / comparison value
addi x6, x0, 5        # x6 = 5 -> comparison value
beq x5, x6, label     # branch if x5 == x6, skip next instruction
addi x7, x0, 1        # executed only if branch not taken
label: addi x7, x0, 99 # executed if branch taken

```

### Instruction_Memory.v
```systemverilog
initial begin
    mem[0] = 32'h00500293; // addi x5, x0, 5
    mem[1] = 32'h00500313; // addi x6, x0, 5
    mem[2] = 32'h00628263; // beq x5, x6, +4 bytes (skip next instruction)
    mem[3] = 32'h00100393; // addi x7, x0, 1  
    mem[4] = 32'h06300393; // addi x7, x0, 99 
end

```

### Register_File.v
```systemverilog
integer i;
initial begin
    for(i=0;i<32;i=i+1)
        Register[i] = 32'h0;       // initialization with all registers to 0 
    Register[0] = 32'h00000000;    // x0 always 0
    Register[5] = 32'h00000005;    // set initial value for x5 
    Register[6] = 32'h00000005;    // set initial value for x6
end

```
![Branch Test Simulation](https://github.com/LeoIgreja11/RISC-V_Single_Cycle_Core/raw/main/image/BRANCH_TEST.png)

> Additionally, more instruction test programs can be added inside the `instructions` folder as `.hex` files.  
> Each `.hex` file can be loaded into the Instruction Memory to easily test new instruction sequences, verify corner cases, or benchmark the processor, using the command:
 ```systemverilog
 $readmemh("<file_name>", mem);
 ```

## 6. Synthesis & Physical Constraints (Optional/Future Work)
..soon

## 7. How to Run
Compile with Icarus Verilog:
```bash
iverilog -g2012 -f file.f -o sim/out.vvp
```
Run the simulation:
```bash
vvp sim/out.vvp
```
View waveforms in GTWave:
```bash
gtkwave sim/Single_Cycle.vcd
```

## 8. References & Acknowledgments
..soon

