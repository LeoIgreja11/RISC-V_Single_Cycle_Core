////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Register_File.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module Register_File(
    input  logic clk_1M0_gated, i_writereg3_en, rst_sync,
    input  logic [4:0] i_addressreg1,i_addressreg2,i_addressreg3,
    input  logic [31:0] i_writeData3,
    output logic [31:0] o_readData1,o_readData2
);

    logic [31:0] static_reg_bank [32];
    integer i;

    assign o_readData1 = (i_addressreg1 == 5'b0) ? 32'b0 : static_reg_bank[i_addressreg1];
    assign o_readData2 = (i_addressreg2 == 5'b0) ? 32'b0 : static_reg_bank[i_addressreg2];

    always_ff @(posedge clk_1M0_gated, posedge rst_sync) begin
        if(rst_sync) begin
            for(i=0;i<32;i=i+1) begin
                static_reg_bank[i] <= 32'b0;
            end
        end
        else if((i_writereg3_en) && (i_addressreg3 != 5'b0)) begin
            static_reg_bank[i_addressreg3] <= i_writeData3;
        end
    end

    /*initial begin
        for(int i=0;i<32;i=i+1) begin
            static_reg_bank[i] = 32'h0;
            static_reg_bank[5] = 32'h0000000F;    // set initial value for x5
        end
    end*/

endmodule
