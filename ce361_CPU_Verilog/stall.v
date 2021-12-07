module stall (IDfunc, EXfunc, IDRegWr, MemRegWr, EXRegWr, WrRegWr, EXrw, Memrw, Wrrw, Rs, IDRt, IFstall, IDstall);
	input [14:0] IDfunc, EXfunc;
	input IDRegWr, MemRegWr, EXRegWr, WrRegWr, Rs, IDRt;
	input [4:0] EXrw, Memrw, Wrrw;
	output IFstall, IDstall;
	
	//IFstall if branch
	wire beq, bne, bgtz;
	or_gate orbeq (.x(IDfunc[4]), .y(EXfunc[4]), .z(beq));
	or_gate orbne (.x(IDfunc[3]), .y(EXfunc[3]), .z(bne));
	or_gate orbgtz (.x(IDfunc[2]), .y(EXfunc[2]), .z(bgtz));
	wire branch_mid;
	or_gate or_branch_mid (.x(beq), .y(bne), .z(branch_mid));
	or_gate or_IFstall (.x(branch_mid), .y(bgtz), .z(IFstall));
	
	//IDstall if EX or Wr will write needed value
	wire [3:0] dhaz;//[RsEX, RsWr, RtEX, RtWr]
	set_if_eq eqRsEX (.x(Rs), .y(EXrw), .z(dhaz[3]));
	set_if_eq eqRsWr (.x(Rs), .y(Wrrw), .z(dhaz[2]));
	set_if_eq eqRtEX (.x(IDRt), .y(EXrw), .z(dhaz[1]));
	set_if_eq eqRtWr (.x(IDRt), .y(Wrrw), .z(dhaz[0]));
	wire [3:0] dhaz2;
	and_gate and1 (.x(dhaz[3]), .y(EXRegWr), .z(dhaz2[3]));
	and_gate and2 (.x(dhaz[2]), .y(WrRegWr), .z(dhaz2[2]));
	and_gate and3 (.x(dhaz[1]), .y(EXRegWr), .z(dhaz2[1]));
	and_gate and4 (.x(dhaz[0]), .y(WrRegWr), .z(dhaz2[0]));
	
	wire [1:0] IDstallOr;
	or_gate or1 (.x(dhaz2[3]), .y(dhaz2[2]), .z(IDstallOr[1]));
	or_gate or2 (.x(dhaz2[1]), .y(dhaz2[0]), .z(IDstallOr[0]));
	or_gate orIDstall (.x(IDstallOr[1]), .y(IDstallOr[0]), .z(IDstall));
endmodule

module set_if_eq(x, y, z);
	input [5:0] x;
	input [5:0] y;
	output z;
	wire [5:0] xored;
	
	genvar i;
	generate
	for (i = 0; i < 6; i = i + 1) begin
		xor_gate xorl(x[i], y[i], xored[i]);
	end
	endgenerate
	
	wire [4:0] ored;
	or_gate or1(xored[0], xored[1], ored[0]);
	or_gate or2(xored[2], xored[3], ored[1]);
	or_gate or3(xored[4], xored[5], ored[2]);
	or_gate or4(ored[0], ored[1], ored[3]);
	or_gate or5(ored[2], ored[3], ored[4]);
	
	not_gate not1(ored[4], z);
endmodule // set_if_eq