////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: PC.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module PC(
    input  logic clk_1M0_gated,
    input  logic rst_sync, //clock e reset
    input  logic i_zero,
    input  logic i_branch,
    input  logic wrmem_pc_en,
    input  logic [31:0] i_imm_ext_reg,
    output logic [31:0] o_pc_reg //PC
);
//////////////////////////////////////////////////////////////////////////////////////////
// ---- PARAMETERS ---- //
//////////////////////////////////////////////////////////////////////////////////////////
    logic        static_PCSrc;
    logic        static_sel_pc_comb;
    logic [31:0] static_pc_plus4_comb;
    logic [31:0] static_pc_target_comb;
    logic [31:0] static_next_pc; //NEXT_PC

//////////////////////////////////////////////////////////////////////////////////////////
// ---- COMBINATIONAL BLOCK ---- //
//////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin: branch_sign
        if((i_zero) & (i_branch))
            static_PCSrc = 1'b1;
        else
            static_PCSrc = 1'b0;
    end: branch_sign

    assign static_sel_pc_comb = (wrmem_pc_en == 1'b1) ? 0 : static_PCSrc;

    always_comb begin: branch_adder
        static_pc_target_comb = o_pc_reg + i_imm_ext_reg;
    end: branch_adder

    always_comb begin: counter_plus_4
        static_pc_plus4_comb = o_pc_reg + 32'd4;

        if(static_sel_pc_comb)
            static_next_pc = static_pc_target_comb;
        else
            static_next_pc = static_pc_plus4_comb;
    end: counter_plus_4
//////////////////////////////////////////////////////////////////////////////////////////
// ---- SEQUENTIAL BLOCK ---- //
//////////////////////////////////////////////////////////////////////////////////////////
    always_ff @(posedge clk_1M0_gated, posedge rst_sync) begin
        if(rst_sync)
            o_pc_reg <=32'b0;
        else
            o_pc_reg <= static_next_pc;   //PC = next program
    end

endmodule
