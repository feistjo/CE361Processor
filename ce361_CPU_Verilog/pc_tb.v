
/*
module rw_tb;
   reg [31:0] in_tb;
   reg clk_tb;
   wire [31:0] out_tb;

   pc_register testin(.in(in_tb),
		      .clk(clk_tb),
     		      .out(out_tb));

   initial begin
      in_tb = 32'b0111;
      clk_tb = 0;
   end

   always
     #5 clk_tb = !clk_tb;

   initial
     begin
	#1;
	#100;
	in_tb = 32'b0101;
	#100;
	$finish;
     end
    
endmodule // register_tb
 */

module pc_tb;
   reg clk_tb;
   reg nPC_sel_tb;
   reg [15:0] imm16_tb;
   wire [31:0] pc_fin_tb;
   wire [31:0] rval;

   pc_clk testin(.clk(clk_tb),
		 .nPC_sel(nPC_sel_tb),
		 .imm16(imm16_tb),
		 .pc_fin(pc_fin_tb),
		 .read_val(rval));

   always
     #5 clk_tb = !clk_tb;

   initial begin
      clk_tb = 0;
      nPC_sel_tb = 0;
      imm16_tb = 16'b0100;    
      #50;
      nPC_sel_tb = 1;
      #50;
      $finish;
   end
   
   
   
endmodule // pc_tb

