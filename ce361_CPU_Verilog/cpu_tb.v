module unsigned_sum_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
	
	defparam cpu1.instmem.sram_get.mem_file = "data/unsigned_sum.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "data/unsigned_sum.dat";
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;	
	end
	
	initial
		begin
			#1000
			$finish;
	end
endmodule

module sort_correct_branch_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
	
	defparam cpu1.instmem.sram_get.mem_file = "data/sort_corrected_branch.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "data/sort_corrected_branch.dat";
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;	
	end
	
	initial
		begin
			#1000
			$finish;
	end
endmodule

module bills_branch_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
	
	defparam cpu1.instmem.sram_get.mem_file = "data/bills_branch.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "data/bills_branch.dat";
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;	
	end
	
	initial
		begin
			#1000
			$finish;
	end
endmodule

module nostalls_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
	
	defparam cpu1.instmem.sram_get.mem_file = "no_stall.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "no_stall.dat";
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;	
	end
	
	initial
		begin
			#1000
			$finish;
	end
endmodule

module onestall_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
	
	defparam cpu1.instmem.sram_get.mem_file = "one_stall.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "one_stall.dat";
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;	
	end
	
	initial
		begin
			#1000
			$finish;
	end
endmodule