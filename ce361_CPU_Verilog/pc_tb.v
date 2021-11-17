
module pc_tb;
   reg clk_tb;
   reg nPC_sel_tb;
   reg [15:0] imm16_tb;
   wire [31:0] pc_fin_tb;

   pc_clk testin(.clk(clk_tb),
		 .nPC_sel(nPC_sel_tb),
		 .imm16(imm16_tb),
		 .pc_fin(pc_fin_tb));

   initial begin
      clk_tb = 0;
      nPC_sel_tb = 0;
      imm16_tb = 16'b0100;
   end

   always
     #5 clk_tb = !clk_tb;

   initial
     #100 $finish;
   
   
endmodule // pc_tb
