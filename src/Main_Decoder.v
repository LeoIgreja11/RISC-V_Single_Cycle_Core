module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp);
    input [6:0]Op; //opcode
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch; //control signals
    output [1:0]ImmSrc,ALUOp; //control signals-2bits

    assign RegWrite = (Op == 7'b0000011 || Op == 7'b0110011 || Op == 7'b0010011) ? 
                                                                    1'b1 : 1'b0;
    //if      opcode = 0000011 or 0110011, RegWrite = 1
    //else if opcode = 0100011 or 1100011, RegWrite = 0

    //op == 7'b0000011 --> lw
    //op == 7'b0110011 --> add
    //op == 7'b0010011 --> addi

    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 : 
                    (Op == 7'b1100011) ? 2'b10 :    
                                         2'b00 ;
    //if      opcode = 0100011, ImmSrc = 01
    //else if opcode = 1100011, ImmSrc = 10
    //else    opcode = 0000011 or 0110011, ImmSrc = 00 

    assign ALUSrc = (Op == 7'b0000011 || Op == 7'b0100011 || Op == 7'b0010011) ? 
                                                                    1'b1 : 1'b0;

    //if      opcode = 0000011 or 0100011 or 0010011, ALUSrc = 1
    //else    opcode = 0110011 or 1100011, ALUSrc = 0

    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :
                                           1'b0 ;
    //if      opcode = 0100011, MemWrite = 1
    //else    opcode = 0000011 or 0110011 or 1100011, MemWrite = 0

    assign ResultSrc = (Op == 7'b0000011) ? 1'b1 :
                                            1'b0 ;
    //if      opcode = 0000011, ResultSrc = 1
    //else    opcode = 0100011 or 0110011 or 1100011, ResultSrc = 0

    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;
    //if      opcode = 1100011, Branch = 1
    //else    opcode = 0000011 or 0100011 or 0110011, Branch = 0

    assign ALUOp = (Op == 7'b0110011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 :
                                        2'b00 ;
    //if      opcode = 0110011, ALUOp = 10
    //else if opcode = 1100011, ALUOp = 01
    //else    opcode = 0000011 or 0100011, ALUOp = 00

endmodule