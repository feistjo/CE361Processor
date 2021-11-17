
module pc_tb;
   reg [31:0] pc_intb;
   reg [15:0] imm16tb;
   reg 	      nPC_seltb;
   wire [31:0] pc_outtb;

   pc_branch testin(.pc_in(pc_intb),
		    .imm16(imm16tb),
		    .nPC_sel(nPC_seltb),
		    .pc_out(pc_outtb));

   initial begin
      pc_intb = 32'b0;
      imm16tb = 32'b0111;
      nPC_seltb = 0;
      #10;
      pc_intb = 32'b0100;
      imm16tb = 32'b0111;
      nPC_seltb = 1;
      #10;
   end
   
endmodule // pc_tb
