module control_tb();
	reg [5:0] Op, Fun;
	reg equal, sign;
	wire nPC_sel, RegWr, RegDst, ExtOp, MemWr, ALUSrc, MemToReg;
	wire [2:0] ALUctr;
	
	control controls(.Op(Op), .Fun(Fun), .equal(equal), .sign(sign), .nPC_sel(nPC_sel), .RegWr(RegWr), .RegDst(RegDst), .ExtOp(ExtOp), .ALUSrc(ALUSrc), .ALUctr(ALUctr), .MemWr(MemWr), .MemtoReg(MemToReg));
	
	initial
		begin
			Op = 6'b0;
			Fun = 6'b100000;
			#10
			Op = 6'b000100;
			equal = 1'b1;
			#10
			Op = 6'b000100;
			equal = 1'b1;
	end
 endmodule