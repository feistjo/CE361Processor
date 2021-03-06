module fibonacci_tb();
	reg clk;
	reg [31:0] Inst;
	parameter n = 10;
	reg [4:0] towrite;
	integer i;
	
	cpu fib_cpu(clk, Inst);
	
	initial
		begin
			//set regs to 1
			clk = 1'b1;
			#1
			Inst = 31'b001000_00000_00001_0000000000000001; //addi $1, $0, 0x1
			clk = 1'b0;
			#1
x1			clk = 1'b1;
			#1
			Inst = 31'b001000_00000_00010_0000000000000001; //addi $2, $0, 0x1
			clk = 1'b0;
			#1
			clk = 1'b1;
			
			//fibbonacci
			for (i = 0; i < n; i = i + 1) begin
				#1
				if (i % 2 == 0)
					towrite = 5'b00001;
				else
					towrite = 5'b00010;
				Inst = {16'b000000_00001_00010, towrite, 11'b00000_100000}; //add $1, $2, $1
				clk = 1'b0;
				#1
				clk = 1'b1;
			end
			//000000_00001_00010_00001_00000_100000
			//000000_00001_00010_00010_00000_100000
			#1
			clk = 1'b0;
			#1
			clk = 1'b1;
	end
endmodule
