////////////////////////////////////////////////////////////////////////////////
// 32-bits RISC-V Single Cycle Core in SystemVerilog
// Module: ALU.sv
// Author: Leonardo Igreja Bezerra
// 05/21/2026
////////////////////////////////////////////////////////////////////////////////

module ALU(
    input logic [31:0] i_A,
    input logic [31:0] i_B,
    input logic [2:0] i_ALUControl,
    output logic o_Carry, o_OverFlow, o_Zero, o_Negative,
    output logic [31:0] o_Result
);

    //auxiliar variable
    logic        static_Cout;
    logic [32:0] static_Sum;

    always_comb begin
        //Sum
        if(i_ALUControl[0] == 1'b0)
            static_Sum = i_A + i_B;
        else
            static_Sum = i_A + (~i_B) + 1'b1;

        static_Cout = 1'b0;

        case (i_ALUControl)
            3'b000:  begin o_Result = static_Sum[31:0]; static_Cout = static_Sum[32]; end
            3'b001:  begin o_Result = static_Sum[31:0]; static_Cout = static_Sum[32]; end
            3'b010:  o_Result = i_A & i_B;
            3'b011:  o_Result = i_A | i_B;
            3'b101:  o_Result = {31'b0, static_Sum[31]};
            default: o_Result = 32'b0;
        endcase

        //OverFlow
        o_OverFlow = ((static_Sum[31] ^ i_A[31]) &
        (~(i_ALUControl[0] ^ i_B[31] ^ i_A[31])) & (~i_ALUControl[1]));
        //Carry
        o_Carry = ((~i_ALUControl[1]) & static_Cout);
        //Zero
        o_Zero = &(~o_Result);
        //Negative
        o_Negative = o_Result[31];
    end

endmodule
