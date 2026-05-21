////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Data_Memory.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module Data_Memory(
    input logic clk_1M0_gated, rst_sync, writeData_en,
    input logic [4:0]   i_adressMemory_dm,
    input logic [31:0]  i_writeData,
    output logic [31:0] o_readData
);

    logic [31:0] static_mem [32]; //mem array of size 1024, each with 32-bits
    integer i;

    always_ff@(posedge clk_1M0_gated, posedge rst_sync) begin
        if(rst_sync) begin
            o_readData <= 32'b0;
            for(i=0;i<32;i=i+1) begin
                static_mem[i] <= 32'b0;
            end
        end else if(writeData_en) begin
            static_mem[i_adressMemory_dm] <= i_writeData;
        end else begin
            o_readData <= static_mem[i_adressMemory_dm];
        end
    end
endmodule
