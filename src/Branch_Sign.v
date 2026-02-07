module Branch_Sign(Branch,Zero,PCSrc);

    input Branch,Zero;
    output PCSrc;

    assign PCSrc = ((Zero) & (Branch)) ? 1'b1 : 1'b0; 

endmodule