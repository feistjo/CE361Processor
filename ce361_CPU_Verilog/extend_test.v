
module ext_tb;
   reg [15:0] in_tb;
   reg 	      sel_tb;
   wire [31:0] out_tb;

   extender test(.in(in_tb),
		 .ext(sel_tb),
		 .out(out_tb));

   initial
     begin
	in_tb = 17;
	sel_tb = 0;
	#10;
	sel_tb = 1;
	#10;
     end

endmodule // ext_tb
