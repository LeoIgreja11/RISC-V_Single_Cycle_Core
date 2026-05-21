////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: riscv_tb.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module riscv_tb;
    timeunit 1ns; timeprecision 1ns;

    logic                clk_1M0;
    logic                rst;
    logic                step_program;
    logic                wrmem_en;
    logic [31:0]         i_wd_instrmem;
    logic [31:0]         o_RD_Instr;

    default clocking cb @(posedge clk_1M0);
    endclocking

    riscv dut (
        .clk_1M0(clk_1M0),
        .step_program(step_program),
        .rst(rst),
        .i_wd_instrmem(i_wd_instrmem),
        .wrmem_en(wrmem_en),
        .o_RD_Instr(o_RD_Instr)
    );

    always #10 clk_1M0 = ~clk_1M0;

    initial begin : initialization
        clk_1M0       = '0;
        rst           = '1;
        wrmem_en      = '1;
        i_wd_instrmem = '0;
        step_program  = '0;
    end : initialization

    initial begin : instructions
        ##1  rst = 0;
        repeat(2) @(posedge clk_1M0);

        // addi x5, x0, 15
        ##2 i_wd_instrmem  = 32'h00F00293;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // addi x6, x0, 15 (0x00F00313)
        ##1 i_wd_instrmem = 32'h00F00313;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // sw x6, 0(x5) (0x0062A023)
        ##1 i_wd_instrmem = 32'h0062A023;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // add x7, x5, x6 (0x006283B3)
        ##1 i_wd_instrmem = 32'h006283B3;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // sub x28, x7, x5 (40538E33)
        ##1 i_wd_instrmem = 32'h40538E33;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // andi x30, x28, 7 (0x007E7F13)
        ##1 i_wd_instrmem = 32'h007E7F13;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // or x30, x30, x5 (0x005F6F33)
        ##1 i_wd_instrmem = 32'h005F6F33;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // beq x5, x6, 4 (0x00628263) - jump to PC+4 if t0 == t1
        ##1 i_wd_instrmem = 32'h00628263;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // addi x0, x0, 0 (0x00000013)
        ##1 i_wd_instrmem = 32'h00000013;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        // ebreak (0x00100073)
        ##1 i_wd_instrmem = 32'h00100073;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        ##1 i_wd_instrmem = 32'h0;
            step_program = 1'b1;
        ##1 step_program = 1'b0;

        ##1 rst = 1;
        ##2  rst = 0;
        repeat(2) @(posedge clk_1M0);
        ##1  wrmem_en = 0;

        ##20 rst = 1;

     $finish;
    end: instructions

endmodule : riscv_tb
