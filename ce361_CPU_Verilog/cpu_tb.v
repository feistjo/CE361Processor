module cpu_tb();
	reg clk;
	reg [31:0] Inst;
	
	cpu test_cpu(clk, Inst);
	
	initial
		begin
			clk = 1'b1;
			#1
			Inst = 31'b000000_00000_00000_00001_00000_100000; //add $1, $0, $0
			clk = 1'b0;
			#1
			clk = 1'b1;
	end
endmodule