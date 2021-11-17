module inst_tb;
   reg clk_tb;
   wire [31:0] inst_tb;

   fetch_inst testb(.clk(clk_tb),
		    .inst(inst_tb));

   always
     #5 clk_tb = !clk_tb;

   initial begin
      clk_tb = 0;
      #50 $finish;
   end
   
endmodule // inst_tb
