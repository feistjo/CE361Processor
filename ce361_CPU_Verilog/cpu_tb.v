<<<<<<< HEAD
module unsigned_sum_tb();
=======

module sort_corrected_branch_tb();
>>>>>>> pipeline
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

<<<<<<< HEAD
module bills_branch_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
	
	defparam cpu1.instmem.sram_get.mem_file = "data/bills_branch.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "data/bills_branch.dat";
=======
/*
module unsigned_sum_tb();
	reg clk;
	
	cpu cpu1(clk);
	
	defparam cpu1.instmem.sram_get.mem_file = "data/unsigned_sum.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "data/unsigned_sum.dat";
>>>>>>> pipeline
	
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

<<<<<<< HEAD
module nostalls_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
	
	defparam cpu1.instmem.sram_get.mem_file = "no_stall.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "no_stall.dat";
=======
module bills_branch_tb();
	reg clk;
	
	cpu cpu1(clk);
	
	defparam cpu1.instmem.sram_get.mem_file = "data/bills_branch.dat";
	defparam cpu1.datamem.syncram_1.mem_file = "data/bills_branch.dat";
>>>>>>> pipeline
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;	
	end
	
	initial
		begin
<<<<<<< HEAD
			#1000
=======
			#5000
>>>>>>> pipeline
			$finish;
	end
endmodule

<<<<<<< HEAD
module onestall_tb();
	reg clk;
	
	cpu cpu1(.clk(clk));
=======
module one_stall_tb();
	reg clk;
	
	cpu cpu1(clk);
>>>>>>> pipeline
	
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
<<<<<<< HEAD
			#1000
			$finish;
	end
endmodule
=======
			#5000
			$finish;
	end
endmodule
*/
>>>>>>> pipeline
