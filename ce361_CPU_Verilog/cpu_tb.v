module cpu_tb();
	reg clk;
	reg [31:0] Inst;
	
	cpu test_cpu(clk, Inst);
	
	initial
		begin
			clk = 1'b1;
			#1
			Inst = 31'b100011_
	end
endmodule