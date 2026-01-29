module Register_File(A1,A2,A3,WD3,WE3,clk,rst,RD1,RD2);

input clk,rst,WE3;
input [4:0] A1,A2,A3;
input [31:0] WD3;
output [31:0] RD1,RD2;

// creation of memory
reg [31:0] Register [31:0];

// read functionality
assign RD1 = (~rst) ? 32'd0 : Register[A1];
assign RD2 = (~rst) ? 32'd0 : Register[A2];

always @(posedge clk) 
begin
    if(WE3)
        Register[A3] <= WD3;
end

initial begin
    Register[5] = 32'h00000006;
    Register[6] = 32'h0000000A;
    
end

endmodule
