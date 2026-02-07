module PC_Module(PC_NEXT,PC,rst,clk);

    input [31:0] PC_NEXT; //program counter next indicates the adress of the next instruction
    input rst, clk; //reset e clock

    output reg [31:0] PC; ////program counter indicates to the current instruction

    always @( posedge clk) 
    begin
        if (~rst) //if rst=0
            PC <= {32{1'b0}}; //PC = 32*1'b0
        else
            PC <= PC_NEXT;   //PC = next instruction
    end

endmodule