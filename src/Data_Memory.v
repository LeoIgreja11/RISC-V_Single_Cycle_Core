module Data_Memory(A,WD,clk,rst,WE,RD);

    input clk,rst,WE;
    input [31:0]A,WD;
    output [31:0]RD;

    reg [31:0] mem [1023:0]; //mem array of size 1024, each with 32-bits

    always @ (posedge clk)
    begin
        if(WE) 
            mem[A[31:2]] <= WD; //if WE = 1, enable write and mem[A] = WD
    end

    assign RD = (~rst) ? 32'd0 : mem[A[31:2]]; //if rst=1, RD = mem[A]

    initial begin
        mem[6] = 32'h00000030;
    end


endmodule