////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: Sign_Extend.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////
module Sign_Extend(
    input logic [31:0] i_instruc,
    input logic [1:0] i_ImmSrc, //00 - I-type, 01 - S-type, 10 = B-type
    output logic [31:0] o_Imm_Ext
);

    always_comb begin
        case (i_ImmSrc)
            2'b00:   o_Imm_Ext = {{20{i_instruc[31]}},i_instruc[31:20]}; // --> I-type
            2'b01:   o_Imm_Ext = ({{20{i_instruc[31]}},i_instruc[31:25],i_instruc[11:7]});
            2'b10:   o_Imm_Ext = {{19{i_instruc[31]}},i_instruc[31],i_instruc[7],
                     i_instruc[30:25],i_instruc[11:8],1'b0};// --> B-type
            default: o_Imm_Ext = 32'b0;
        endcase
    end

endmodule

//the register that contains the base address for a load instruction: Inst[19:15]
//destionation register for the load instruction: Inst[11:7]
