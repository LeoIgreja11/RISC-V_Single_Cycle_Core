module ALU_Decoder(ALUOp,funct3,funct7,op,ALUControl);

    input [1:0]ALUOp; 
    input [2:0]funct3;
    input [6:0]funct7,op; //function 7 and operation code(7bits) 
    output [2:0]ALUControl; //variable used to control the ALU module

    //ALUOp signal in conjunction with the funct field and opcode bit to cumpute ALUControl
    assign ALUControl = (ALUOp == 2'b00) ? 3'b000 : //add
                        (ALUOp == 2'b01) ? 3'b001 : //sub
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} == 2'b11)) ? 3'b001 : //sub
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} != 2'b11)) ? 3'b000 : //add
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : //set less than
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : //or
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : //and
                                                                  3'b000 ; //add
endmodule