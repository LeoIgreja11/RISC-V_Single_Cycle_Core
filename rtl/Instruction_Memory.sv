////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Instruction_Memory.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module Instruction_Memory(
    input  logic        clk_1M0_gated,
    input  logic        wrmem_en,
    input  logic        rst_sync,
    input  logic        i_step_program_en,
    input  logic [4:0] i_adressMemory_im,
    input  logic [31:0] i_wd_instrmem,
    output logic [31:0] o_readData
);
    logic [31:0] static_mem [32];
    logic  [4:0] i;

    always_ff@(posedge i_step_program_en, posedge rst_sync) begin: manual_programming_interface
            if(rst_sync)
                i <= 4'b0;
            else if(wrmem_en) begin
                i <= i + 1'b1;
            end
    end: manual_programming_interface

    always_ff@(posedge i_step_program_en) begin: instruction_to_memory
            if(wrmem_en) begin
                static_mem[i] <= i_wd_instrmem;
            end
    end: instruction_to_memory

    always_ff@(posedge clk_1M0_gated, posedge rst_sync) begin: run_core
        if(rst_sync)
            o_readData <= 32'b0;
        else
            o_readData <= static_mem[i_adressMemory_im];
    end: run_core

endmodule
