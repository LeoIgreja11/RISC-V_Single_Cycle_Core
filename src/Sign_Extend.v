module Sign_Extend(In,Imm_Ext,ImmSrc);

    input [31:0]In;
    input [1:0]ImmSrc; //00 - I-type, 01 - S-type, 10 = B-type
    output reg [31:0]Imm_Ext;

    always @(*) begin
        case (ImmSrc)
            2'b00: Imm_Ext = {{20{In[31]}},In[31:20]}; // --> I-type
            2'b01: Imm_Ext = ({{20{In[31]}},In[31:25],In[11:7]}); // --> S-type
            2'b10: Imm_Ext = {{19{In[31]}},In[31],In[7],In[30:25],In[11:8],1'b0}; // --> B-type
            default: Imm_Ext = 32'b0;
        endcase
    end
    
    /*assign Imm_Ext = (ImmSrc == 2'b1) ? ({{20{In[31]}},In[31:25],In[11:7]}):
                                        {{20{In[31]}},In[31:20]};*/ //REMOVER DEPOIS
endmodule//aaaa aaaa aaaa aaaa aaaa xxxx xxxy yyyy

//the register that contains the base address for a load instruction: Inst[19:15]
//destionation register for the load instruction: Inst[11:7]