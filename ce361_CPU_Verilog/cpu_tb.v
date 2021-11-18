module cpu_tb();
	reg clk;
	
	cpu cpu1(clk);
	
	defparam cpu1.instmem.sram_get.mem_file = "data/sort_corrected_branch.bat";
	defparam cpu1.datamem.syncram_1.mem_file = "data/sort_corrected_branch.bat";
	
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