module cpu_tb();
	reg clk;
	reg [31:0] Inst;
	
	cpu cpu1(clk);
	
	defparam cpu1.instmem.sram_get.mem_file = "data/bills_branch.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "bbout.dat";
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;	
	end
endmodule