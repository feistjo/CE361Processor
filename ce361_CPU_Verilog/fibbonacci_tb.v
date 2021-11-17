module fibbonacci_tb();
	reg clk;
	reg [31:0] Inst;
	parameter n = 10;
	
	cpu fib_cpu(clk, Inst);
	
	initial
		begin
			//set regs to 1
			clk = 1'b1;
			#1
			Inst = 31'b001000_00000_00001_0000000000000001; //addi $1, $0, 0x1
			clk = 1'b0;
			#1
			clk = 1'b1;
			#1
			Inst = 31'b001000_00000_00010_0000000000000001; //addi $2, $0, 0x1
			clk = 1'b0;
			#1
			clk = 1'b1;
			#1
			
			//fibbonacci
			integer i;
			for (i = 0; i < n; i = i + 1) begin
				reg [4:0] towrite;
				if (i % 2 == 0) begin
					assign towrite = 5'b00001;
				end else begin
					assign towrite = 5'b00010;
				end
				assign Inst = {16'b000000_00001_00001, towrite, 11'b00000_100000}; //add $1, $1, $1
				assign clk = 1'b0;
				#1
				assign clk = 1'b1;
				#1
			end
			clk = 1'b0;
			#1
			clk = 1'b1;
	end
endmodule