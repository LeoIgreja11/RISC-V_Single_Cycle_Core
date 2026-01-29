module ALU(A,B,ALUControl,Result,Zero,Negative,OverFlow,Carry);
    
    input [31:0]A,B;
    input [2:0] ALUControl;
    output Carry,OverFlow,Zero,Negative;
    output [31:0] Result;

    //auxiliar variable
    wire Cout;
    wire [31:0]Sum;

    assign Sum = (ALUControl[0] == 1'b0) ? A + B : (A + (~B)+1); // define wich operation arithmetich type be realized (add or sub)
    assign {Cout,Result} = (ALUControl == 3'b000) ? Sum : //add
                           (ALUControl == 3'b001) ? Sum : //sub
                           (ALUControl == 3'b010) ? A & B : //and
                           (ALUControl == 3'b011) ? A | B : //or
                           (ALUControl == 3'b101) ? {{32{1'b0}},(Sum[31])} : //set less than (slt)
                           {33{1'b0}};

    assign OverFlow = ((Sum[31] ^ A[31]) &
                      (~(ALUControl[0] ^ B[31] ^ A[31])) &
                      (~ALUControl[1]));
    assign Carry = ((~ALUControl[1]) & Cout);
    assign Zero = &(~Result);
    assign Negative = Result[31];

endmodule
