////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: riscv.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module riscv (clk_1M0,rst,i_wd_instrmem,wrmem_en,step_program,o_RD_Instr);

    input  clk_1M0,rst,wrmem_en,step_program;
    input  logic [31:0] i_wd_instrmem;
    output logic [31:0] o_RD_Instr;

    wire[31:0] inst_PC_Top,inst_RD1_Top,inst_Imm_Ext_Top,inst_ALUResult,inst_ReadData,inst_RD2_Top,
    inst_SrcB,inst_Result,inst_PC_Next,inst_PCBranch;
    wire inst_clk_1M0_gated, inst_rst_sync, inst_RegWrite,inst_MemWrite,inst_ALUSrc,inst_ResultSrc,
    inst_Branch,inst_PCSrc,inst_Zero,inst_PCSrc_mux;
    wire [1:0] inst_ImmSrc;
    wire [2:0] inst_ALUControl_Top;

    Clock_Gating Clock_Gating(
        .clk_en(!wrmem_en),
        .clk_1M0(clk_1M0),
        .clk_1M0_gated(inst_clk_1M0_gated)
    );

    Reset_Sync Reset_Sync(
        .rst(rst),
        .clk_1M0(clk_1M0),
        .rst_sync(inst_rst_sync)
    );

    PC PC(
        .clk_1M0_gated(inst_clk_1M0_gated),
        .rst_sync(inst_rst_sync),
        .i_zero(inst_Zero),
        .i_branch(inst_Branch),
        .wrmem_pc_en(wrmem_en),
        .i_imm_ext_reg({inst_Imm_Ext_Top[30:0],1'b0}),
        .o_pc_reg(inst_PC_Top)
    );

    Instruction_Memory Instruction_Memory(
        .clk_1M0_gated(inst_clk_1M0_gated),
        .rst_sync(inst_rst_sync),
        .i_step_program_en(step_program),
        .wrmem_en(wrmem_en),
        .i_wd_instrmem(i_wd_instrmem),
        .i_adressMemory_im(inst_PC_Top[6:2]),
        .o_readData(o_RD_Instr)
    );

    Register_File Register_File(
        .clk_1M0_gated(inst_clk_1M0_gated),
        .rst_sync(inst_rst_sync),
        .i_writereg3_en(inst_RegWrite),
        .i_writeData3(inst_Result),
        .i_addressreg1(o_RD_Instr[19:15]),
        .i_addressreg2(o_RD_Instr[24:20]),
        .i_addressreg3(o_RD_Instr[11:7]),
        .o_readData1(inst_RD1_Top),
        .o_readData2(inst_RD2_Top)
    );

    Sign_Extend Sign_Extend(
        .i_instruc(o_RD_Instr),
        .i_ImmSrc(inst_ImmSrc),
        .o_Imm_Ext(inst_Imm_Ext_Top)
    );

    Mux Mux_Register_to_ALU(
        .i_a(inst_RD2_Top),
        .i_b(inst_Imm_Ext_Top),
        .i_s(inst_ALUSrc),
        .o_c(inst_SrcB)
    );

    ALU ALU(
        .i_A(inst_RD1_Top),
        .i_B(inst_SrcB),
        .o_Result(inst_ALUResult),
        .i_ALUControl(inst_ALUControl_Top),
        .o_Zero(inst_Zero),
        .o_Carry(),
        .o_Negative(),
        .o_OverFlow()
    );

    Control_Unit_Top Control_Unit_Top(
        .i_Op(o_RD_Instr[6:0]),
        .i_funct3(o_RD_Instr[14:12]),
        .i_funct7(o_RD_Instr[31:25]),
        .o_RegWrite(inst_RegWrite),
        .o_ImmSrc(inst_ImmSrc),
        .o_ALUSrc(inst_ALUSrc),
        .o_MemWrite(inst_MemWrite),
        .o_ResultSrc(inst_ResultSrc),
        .o_Branch(inst_Branch),
        .o_ALUControl(inst_ALUControl_Top)
    );

    Data_Memory Data_Memory(
        .i_adressMemory_dm(inst_ALUResult[6:2]),
        .i_writeData(inst_RD2_Top),
        .clk_1M0_gated(inst_clk_1M0_gated),
        .rst_sync(inst_rst_sync),
        .writeData_en(inst_MemWrite),
        .o_readData(inst_ReadData)
    );

    Mux Mux_DataMemory_to_Register(
        .i_a(inst_ALUResult),
        .i_b(inst_ReadData),
        .i_s(inst_ResultSrc),
        .o_c(inst_Result)
    );

endmodule
