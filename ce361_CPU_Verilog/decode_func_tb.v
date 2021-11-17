 module decode_func_tb();
	reg [5:0] Op, Fun;
	wire [14:0] func;
	wire RegDst;
	
	decode_func decode_func_t(Op, Fun, func, RegDst);
	
	initial
		begin
			$monitor(Op, Fun, func, RegDst);
			Op = 6'b0;
			Fun = 6'b100000
			#10
	end
 endmodule