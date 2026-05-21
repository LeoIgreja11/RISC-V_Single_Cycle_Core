////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Mux.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module Mux(
    input logic [31:0] i_a,i_b,
    input logic i_s,
    output logic [31:0] o_c
);
    always_comb begin
        if(~i_s)
            o_c = i_a;
        else
            o_c = i_b;
    end
endmodule
