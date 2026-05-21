////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Reset_Sync.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module Reset_Sync(
    input  logic rst,
    input  logic clk_1M0,
    output logic rst_sync
);
    logic out_ff1;

    always_ff@(posedge clk_1M0, posedge rst) begin
        if(rst) begin
            out_ff1  <= 1'b1;
            rst_sync <= 1'b1;
        end else begin
            out_ff1  <= 1'b0;
            rst_sync <= out_ff1;
        end
    end

endmodule
