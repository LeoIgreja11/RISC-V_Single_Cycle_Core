module Instruction_Memory(A,rst,RD);

    input rst;
    input [31:0]A; //input 
    output [31:0]RD; //reads the 32-bit data (instruction)

    reg [31:0] mem [1023:0]; //mem array of size 1024, each with 32-bits

    assign RD = (~rst) ? {32{1'b0}} : mem[A[31:2]];
    //if rst=0, RD = 32*1'b0, else RD = mem[A[31:2]]
    // Instructions are 32-bit (4 bytes) and must be word-aligned,
    // therefore A[1:0] are always '00' and are not used for indexing

    //put the instruction
    initial begin
        mem[0] = 32'h01400313;//add x6,x0,20
        mem[1] = 32'h00432283; //lw x5, 4(x6)
        mem[2] = 32'h406283B3;// sub x7, x5, x6
        mem[3] = 32'h00732023;//sw x7, 0(x6)

    end



endmodule