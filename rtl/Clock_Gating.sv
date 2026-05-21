////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Clock_Gating.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module Clock_Gating(
    input logic clk_en,
    input logic clk_1M0,
    output logic clk_1M0_gated
);
    logic static_ff_clk;

    always_ff@(negedge clk_1M0) begin
        static_ff_clk <= clk_en;
    end

    assign clk_1M0_gated = static_ff_clk & clk_1M0;

endmodule
