module Branch_Adder(PC_Top,SignImm,PCBranch);

    input [31:0] PC_Top,SignImm;
    output [31:0] PCBranch;

    assign PCBranch = PC_Top + SignImm;

endmodule