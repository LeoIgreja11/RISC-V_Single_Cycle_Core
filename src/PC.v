module PC_Module(PC_NEXT,PC,rst,clk);

    input [31:0] PC_NEXT;
    input rst, clk;

    output reg [31:0] PC;

    always @( posedge clk) 
    begin
        if (~rst)
            PC <= {32{1'b0}};
        else
            PC <= PC_NEXT;
    end

endmodule
