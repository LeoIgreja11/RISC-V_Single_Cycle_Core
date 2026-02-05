# RISC-V_Single_Cycle_Core
Microprocessor with Architecture RISC-V  in Verilog 

Detailed description coming soon.

## 1. Project Overview
..soon

## 2. Key Specifications
..soon

## 3. Supported Instruction Set (ISA)
..soon

## 4. Microarchitecture & Datapath
..soon

## 5. Control Unit & Signal Mapping
..soon

## 6. Verification & Simulation Environment
.To verify the RISC-V single-cycle core, we ran a simple "Add and Store Word" program:

### Assembly code
```asm
addi x5, x0, 15      # x5 = 15 → memory address
addi x6, x0, 15      # x6 = 15 → data to store
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




## 7. Synthesis & Physical Constraints (Optional/Future Work)
..soon

## 8. Key Challenges & Technical Insights
..soon

## 9. How to Run
..soon

## 10. References & Acknowledgments
..soon
