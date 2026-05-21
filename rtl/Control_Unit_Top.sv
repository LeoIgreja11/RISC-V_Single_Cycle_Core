////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Control_Unit_Top.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module Control_Unit_Top(
    input logic [6:0] i_Op,
    input logic [6:0] i_funct7,
    input logic [2:0] i_funct3,
    output logic o_RegWrite, o_ALUSrc, o_MemWrite, o_ResultSrc, o_Branch,
    output logic [1:0] o_ImmSrc,
    output logic [2:0] o_ALUControl
);
    logic [1:0] static_ALUOp;

    always_comb begin
//=======================MAIN DECODER=======================
        if(i_Op == 7'b0000011 || i_Op == 7'b0110011 || i_Op == 7'b0010011)
            o_RegWrite = 1'b1;
        else
            o_RegWrite = 1'b0;
        //op == 7'b0000011 --> lw
        //op == 7'b0110011 --> add
        //op == 7'b0010011 --> addi

        if(i_Op == 7'b0100011)
            o_ImmSrc = 2'b01;
        else if (i_Op == 7'b1100011)
            o_ImmSrc = 2'b10;
        else
            o_ImmSrc = 2'b00;
        //if      opcode = 0100011, ImmSrc = 01
        //else if opcode = 1100011, ImmSrc = 10
        //else    opcode = 0000011 or 0110011, ImmSrc = 00

        if(i_Op == 7'b0000011 || i_Op == 7'b0100011 || i_Op == 7'b0010011)
            o_ALUSrc = 1'b1;
        else
            o_ALUSrc = 1'b0;
        //if      opcode = 0000011 or 0100011 or 0010011, ALUSrc = 1
        //else    opcode = 0110011 or 1100011, ALUSrc = 0

        if(i_Op == 7'b0100011)
            o_MemWrite = 1'b1;
        else
            o_MemWrite = 1'b0;
        //if      opcode = 0100011, MemWrite = 1
        //else    opcode = 0000011 or 0110011 or 1100011, MemWrite = 0

        if(i_Op == 7'b0000011)
            o_ResultSrc = 1'b1;
        else
            o_ResultSrc = 1'b0;
        //if      opcode = 0000011, ResultSrc = 1
        //else    opcode = 0100011 or 0110011 or 1100011, ResultSrc = 0

        if(i_Op == 7'b1100011)
            o_Branch = 1'b1;
        else
            o_Branch = 1'b0;
        //if      opcode = 1100011, Branch = 1
        //else    opcode = 0000011 or 0100011 or 0110011, Branch = 0

        if(i_Op == 7'b0110011)
            static_ALUOp = 2'b10;
        else if(i_Op == 7'b1100011)
            static_ALUOp = 2'b01;
        else
            static_ALUOp = 2'b00;
        //if      opcode = 0110011, ALUOp = 10
        //else if opcode = 1100011, ALUOp = 01
        //else    opcode = 0000011 or 0100011, ALUOp = 00

//=======================ALU DECODER=======================
        if(static_ALUOp == 2'b00)
            o_ALUControl = 3'b000; //add
        else if(static_ALUOp == 2'b01)
            o_ALUControl = 3'b001; //sub
        else if((static_ALUOp == 2'b10) & (funct3 == 3'b000) & ({Op[5],funct7[5]} == 2'b11))
            o_ALUControl = 3'b001; //sub
        else if((static_ALUOp == 2'b10) & (funct3 == 3'b000) & ({Op[5],funct7[5]} != 2'b11))
            o_ALUControl = 3'b000; //add
        else if((static_ALUOp == 2'b10) & (funct3 == 3'b010))
            o_ALUControl = 3'b101; //set less than
        else if((static_ALUOp == 2'b10) & (funct3 == 3'b110))
            o_ALUControl = 3'b011; //or
        else if((static_ALUOp == 2'b10) & (funct3 == 3'b111))
            o_ALUControl = 3'b010; //and
        else
            o_ALUControl = 3'b000; //add

    end

endmodule


/*
========================================
----------------- LOAD -----------------
========================================
0000011 -> LOAD
- lb
- lh
- lw
- lbu
- lhu
========================================
---------------- STORE ----------------
========================================
0100011 -> STORE
- sb
- sh
- sw
========================================
---------------- R-TYPE ----------------
========================================
0110011-> R-TYPE
- add
- sub
- sll
- slt
- sltu
- xor
- srl
- sra
- or
- and
========================================
---------------- I-TYPE ----------------
========================================
0010011 - I-TYPE
- addi
- slti
- sltiu
- xori
- ori
- andi
- slli
- srli
- srai
========================================
---------------- B-TYPE ----------------
========================================
1100011 - B-TYPE
- beq
- bne
- blt
- bge
- bltu
- bgeu

*/
