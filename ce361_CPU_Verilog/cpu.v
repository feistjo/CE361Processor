//`include "lib/mux.v"
//`include "lib/mux_32.v"
//`include "lib/not_gate.v"
//`include "ece361_alu_verilog/ALU.v"
//`include "registers.v"
//`include "extend.v"
`include  "d_mem.v"
`include "stall.v"

`include "inst_mem.v"

module cpu(clk);
	input clk;

	wire IFstall, IDstall;
	/* ~~~~~~~~~~ pipeline data registers ~~~~~~~~~~ */
	//Instruction 
	wire [31:0] IFInst, IDInst;
	reg [31:0] IFIDInst;
	assign IDInst = IFIDInst;
	//Imm16
	wire [15:0] IDImm16, EXImm16;
	reg [15:0] IDEXImm16;
	assign EXImm16 = IDEXImm16;
	//ALUctr
	wire [2:0] IDALUctr, EXALUctr;
	reg [2:0] IDEXALUctr;
	assign EXALUctr = IDEXALUctr;
	//

	/* ~~~~~~~~~~ pipeline control registers ~~~~~~~~~~ */
	//ExtOp
	wire IDExtOp, EXExtOp;
	reg IDEXExtOp;
	assign EXExtOp = IDEXExtOp;
	//ALUSrc
	wire IDALUSrc, EXALUSrc;
	reg IDEXALUSrc;
	assign EXALUSrc = IDEXALUSrc;
	//ALUOp - NOT USED
	//RegDst
	wire IDRegDst, EXRegDst;
	reg IDEXRegDst;
	assign EXRegDst = IDEXRegDst;
	//MemWr
	wire IDMemWr, EXMemWr, MemMemWr;
	reg IDEXMemWr, EXMemMemWr;
	assign EXMemWr = IDEXMemWr;
	assign MemMemWr = EXMemMemWr;
	//Branch
	wire IDnPC_sel, EXnPC_sel;
	reg IDEXnPC_sel;
	assign EXnPC_sel = IDEXnPC_sel;
	//MemToReg
	wire IDMemToReg, EXMemToReg, MemMemToReg, WrMemToReg;
	reg IDEXMemToReg, EXMemMemToReg, MemWrMemToReg;
	assign EXMemToReg = IDEXMemToReg;
	assign MemMemToReg = EXMemMemToReg;
	assign WrMemToReg = MemWrMemToReg;
	//RegWr
	wire IDRegWr, EXRegWr, MemRegWr, WrRegWr;
	reg IDEXRegWr, EXMemRegWr, MemWrRegWr;
	assign EXRegWr = IDEXRegWr;
	assign MemRegWr = EXMemRegWr;
	assign WrRegWr = MemWrRegWr;

	/* ~~~~~~~~~~ Logic Implementation ~~~~~~~~~~ */
	
	wire zero, sign;
	fetch_inst instmem(.clk(clk), .imm16(EXImm16), .nPC_sel(EXnPC_sel), .inst(IFInst)); //probably has to change
	wire [4:0] Rs, IDRt, IDRd;
	reg [4:0] IDEXRt, IDEXRd;
	assign IDRt = IDInst[20:16];
	assign Rs = IDInst[25:21];
	assign IDRd = IDInst[15:11];
	assign IDImm16 = IDInst[15:0];
	wire [4:0] IDshamt;
	reg [4:0] IDEXshamt;
	assign IDshamt = IDInst[10:6];
	wire [14:0] IDfunc, EXfunc;
	reg [14:0] IDEXfunc;
	assign EXfunc = IDEXfunc;
   
	control controls(.Op(IDInst[31:26]), .Fun(IDInst[5:0]), .equal(zero), .sign(sign), .RegWr(IDRegWr), .RegDst(IDRegDst), 
		.ExtOp(IDExtOp), .ALUSrc(IDALUSrc), .ALUctr(IDALUctr), .MemWr(IDMemWr), .MemtoReg(MemToReg), .func(IDfunc));

	wire [4:0] EXRt, EXRd;
	assign EXRt = IDEXRt;
	assign EXRd = IDEXRd;
	wire [31:0] WrbusW, IDbusA, IDbusB;
	reg [31:0] IDEXbusA, IDEXbusB;
	wire [4:0] EXRw, MemRw, WrRw;
	reg [4:0] EXMemRw, MemWrRw;
	assign WrRw = MemWrRw;
	assign MemRw = EXMemRw;
	mux_5 mux_rw(EXRegDst, EXRt, EXRd, EXRw);
	
	reg [31:0] EXMemALUout;
	wire [31:0] MemALUout;
	assign MemALUout = EXMemALUout;
	reg [31:0] MemWrALUout;
	wire [31:0] WrALUout;
	assign WrALUout = MemWrALUout;
	
	registers datareg(.clk(clk), .RegWr(WrRegWr), .busW(WrALUout), .Rw(WrRw), .Ra(Rs), .Rb(IDRt), .busA(IDbusA), .busB(IDbusB));
	
	wire [31:0] Imm32;
	extender immext(.in(EXImm16), .ext(EXExtOp), .out(Imm32));
	
	wire [31:0] EXbusA, EXbusB;
	assign EXbusA = IDEXbusA;
	assign EXbusB = IDEXbusB;
	reg [31:0] EXMemBusB;
	wire [31:0] ALUIn2;
	mux_32 muxb({31'b0, EXALUSrc}, EXbusB, Imm32, ALUIn2);
	
	wire [31:0] ALUout;
	wire [4:0] EXshamt;
	wire EXzero;
	reg EXMemzero;
	wire ovf, cout;
	ALU alu1(.ctrl(EXALUctr), .A(EXbusA), .B(ALUIn2), .shamt(EXshamt), .cout(cout), .ovf(ovf), .ze(EXzero), .R(ALUout));
   
    get_branched br(.func(EXfunc), .equal(EXzero), .nPC_sel(IDnPC_sel));

	assign sign = ALUout[31];
	
	wire [4:0] MemRegRw;
	reg [4:0] MemWrRegRw;
	
	//Data Memory DataIn=busB, WrEn=MemWr, adr=ALUout, clk=clk, dout=DataOut
	wire [31:0] DataOut;
	reg [31:0] MemWrDataOut;
	wire [31:0] WrDataOut;
	assign WrDataOut = MemWrDataOut;
	//read_0 testread(DataOut);
	d_mem datamem(.clk(clk), .data_in(busB), .data_out(DataOut), .adr(ALUout), .WrEn(MemMemWr));
	
	mux_32 datamux({31'b0, WrMemToReg}, WrALUout, WrDataOut, busW);
	stall st (.IDfunc(IDfunc), .EXfunc(EXfunc), .IDRegWr(IDRegWr), .MemRegWr(MemRegWr), .EXRegWr(EXRegWr), 
	.WrRegWr(WrRegWr), .EXrw(EXRw), .Memrw(MemRw), .Wrrw(WrRw), .Rs(Rs), .IDRt(IDRt), .IFstall(IFstall), .IDstall(IDstall));

	initial begin
		IFIDInst <= 15'b0;

		//Imm16
		IDEXImm16 <= 16'b0;
		//ALUctr
		IDEXALUctr <= 3'b0;
		
		IDEXbusA <= 32'b0;
		IDEXbusB <= 32'b0;
		IDEXRt <= 5'b0;
		IDEXRd <= 5'b0;
		// IDStall
	    
	  	   
		//EX/MEM Pipeline 
		//PC+4
		EXMemzero <= 1'b0;
		EXMemALUout <= 32'b0;
		EXMemRw <= 5'b0;
		EXMemBusB <= 32'b0;

		//MEM/WR Pipeline 
		MemWrRegRw <= 5'b0;
		MemWrRw <= 5'b0;
		MemWrALUout <= 32'b0;
		MemWrDataOut <= 32'b0;

		/* ~~~~~~~~~~ Pipeline Control Registers ~~~~~~~~~~ */
		//ExtOp
		IDEXExtOp <= 1'b0;
		//ALUSrc
		IDEXALUSrc <= 1'b0;
		//ALUOp - NOT USED
		//RegDst
		IDEXRegDst <= 1'b0;
		//MemWr
		IDEXMemWr <= 1'b0;
		EXMemMemWr <= 1'b0;
		//Branch
		IDEXnPC_sel <= 1'b0;
	    IDEXfunc <= 15'b0;
		//MemtoReg
		IDEXMemToReg <= 1'b0;
		EXMemMemToReg <= 1'b0;
		MemWrMemToReg <= 1'b0;
		//RegWr
		IDEXRegWr <= 1'b0;
		EXMemRegWr <= 1'b0;
		MemWrRegWr <= 1'b0;
	end

	always @(negedge clk)
	begin

		/* ~~~~~~~~~~ Pipeline Data Registers ~~~~~~~~~~ */
		//Instruction
		if (!IFstall) begin
			IFIDInst <= IFInst;
		end

		if (!IDstall) 
		begin
			//Imm16
			IDEXImm16 <= IDImm16;
			//ALUctr
			IDEXALUctr <= IDALUctr;
		
			IDEXbusA <= IDbusA;
			IDEXbusB <= IDbusB;
			IDEXRt <= IDRt;
			IDEXRd <= IDRd;
		end // IDStall
	    
	  	   
		//EX/MEM Pipeline 
		//PC+4
		EXMemzero <= EXzero;
		EXMemALUout <= ALUout;
		EXMemRw <= EXRw;
		EXMemBusB <= EXbusB;

		//MEM/WR Pipeline 
		//MemWrRegRw <= MemRegRw;
		MemWrRw <= MemRw;
		MemWrALUout <= MemALUout;
		MemWrDataOut <= DataOut;

		/* ~~~~~~~~~~ Pipeline Control Registers ~~~~~~~~~~ */

		
		//ExtOp
		IDEXExtOp <= IDExtOp;
		//ALUSrc
		IDEXALUSrc <= IDALUSrc;
		//ALUOp - NOT USED
		//RegDst
		IDEXRegDst <= IDRegDst;
		//MemWr
		IDEXMemWr <= IDMemWr;
		EXMemMemWr <= EXMemWr;
		//Branch
		IDEXnPC_sel <= IDnPC_sel;
	    IDEXfunc <= IDfunc;
		//MemtoReg
		IDEXMemToReg <= IDMemToReg;
		EXMemMemToReg <= EXMemToReg;
		MemWrMemToReg <= MemMemToReg;
		//RegWr
		IDEXRegWr <= IDRegWr;
		EXMemRegWr <= EXRegWr;
		MemWrRegWr <= MemRegWr;
	end

endmodule

module read_0(dout);
	output [31:0] dout;
	assign dout = 31'b0;
endmodule

module mux_5(sel, src0, src1, z);
	input sel;
	input [4:0] src0, src1;
	output [4:0] z;
	genvar i;
	generate
	for (i = 0; i < 5; i = i + 1) begin
		mux mux_5_n(sel, src0[i], src1[i], z[i]);
	end
	endgenerate
endmodule

module control(Op, Fun, equal, sign, RegWr, RegDst, ExtOp, ALUSrc, ALUctr, MemWr, MemtoReg, func);
	input [5:0] Op;
	input [5:0] Fun;
	input equal, sign;
	output RegWr, RegDst, ALUSrc, MemWr, MemtoReg;
	output ExtOp;
	output [2:0] ALUctr;	
	output [14:0] func; //[add, addi, addu, sub, subu, and, or, sll, lw, sw, beq, bne, bgtz, slt, sltu]

	decode_func getfunc(.Op(Op), .Fun(Fun), .func(func), .RegDst(RegDst));
	get_ALUctr getaluctr(.func(func), .ALUctr(ALUctr));
       
	
	//RegWr: add, addi, addu, sub, subu, and, or, sll, lw, slt, sltu (not sw, bew, bne, bgtz)
	wire [2:0] reg_wr_mid;
	or_gate regor1(func[2], func[3], reg_wr_mid[1]);
	or_gate regor2(func[4], func[5], reg_wr_mid[0]);
	or_gate regor3(reg_wr_mid[0], reg_wr_mid[1], reg_wr_mid[2]);
	not_gate regwrnot(reg_wr_mid[2], RegWr);
	
	//ExtOp: addi = 1, lw, sw = 1
	wire extop_mid;
	or_gate extopor1(func[5], func[6], extop_mid);
	or_gate extopor2(extop_mid, func[13], ExtOp);
	
	//ALUSrc (immediate?): not RegDst
	not_gate alusrcnot(RegDst, ALUSrc);
	
	//MemWr: only on sw
	assign MemWr = func[5];
	
	//MemToReg: only on lw
	assign MemtoReg = func[6];
endmodule

module get_ALUctr(func, ALUctr);
	input [14:0] func;
	output [2:0] ALUctr;
	//maybe figure out how to use ALUCU?
	//ALU ALUctr 0=and, 1=or, 2=fa, 3=slt_signed, 4=fa_u, 5=sll, 6=sub, 7=slt
	//ALU(ctrl, A,B,shamt,cout,ovf,ze,R)
	
	//ALU and (000): and
	wire alu_and;
	assign alu_and = func[9];
	
	//ALU or (001): or
	wire alu_or;
	assign alu_or = func[8];
	
	//ALU fa (010): add, addi, lw, sw
	wire alu_fa;
	wire [1:0] alu_fa_or;
	or_gate orfa1(func[6], func[5], alu_fa_or[1]);
	or_gate orfa2(func[14], func[13], alu_fa_or[0]);
	or_gate orfa(alu_fa_or[0], alu_fa_or[1], alu_fa);
	
	//ALU slt_signed (011): slt
	wire alu_slt;
	assign alu_slt = func[1];
	
	//ALU fa_u (100): addu, lw, sw
	wire alu_fau, alu_fau_or1;
	assign alu_fau = func[12];
	
	//ALU sll (101): sll
	wire alu_sll;
	assign alu_sll = func[7];
	
	//ALU sub (110): sub, subu, beq, bne, bgtz
	wire alu_sub;
	wire [2:0] alu_sub_mid;
	or_gate orsub1(func[11], func[10], alu_sub_mid[2]);
	or_gate orsub2(func[4], func[3], alu_sub_mid[1]);
	or_gate orsub3(func[2], alu_sub_mid[2], alu_sub_mid[0]);
	or_gate orsub4(alu_sub_mid[1], alu_sub_mid[0], alu_sub);
	
	//ALU slt (111): sltu
	wire alu_sltu;
	assign alu_sltu = func[0];
	
	//encode
	wire [1:0] or_wires_1;
	or_gate orenc1(alu_or, alu_slt, or_wires_1[1]);
	or_gate orenc2(alu_sll, alu_sltu, or_wires_1[0]);
	or_gate orenc3(or_wires_1[1], or_wires_1[0], ALUctr[0]);
	
	wire [1:0] or_wires_2;
	or_gate orenc4(alu_fa, alu_slt, or_wires_2[1]);
	or_gate orenc5(alu_sub, alu_slt, or_wires_2[0]);
	or_gate orenc6(or_wires_2[1], or_wires_2[0], ALUctr[1]);
	
	wire [1:0] or_wires_3;
	or_gate orenc7(alu_fau, alu_sll, or_wires_3[1]);
	or_gate orenc8(alu_sub, alu_sltu, or_wires_3[0]);
	or_gate orenc9(or_wires_3[1], or_wires_3[0], ALUctr[2]);
endmodule

module decode_func(Op, Fun, func, RegDst);
	input [5:0] Op;
	input [5:0] Fun;
	output [14:0] func; //[add, addi, addu, sub, subu, and, or, sll, lw, sw, beq, bne, bgtz, slt, sltu]
	output RegDst;
	
	wire r_type;
	set_if_eq setr(Op, 6'b000000, r_type);
	
	wire [8:0] r_func; //[add, addu, sub, subu, and, or, sll, slt, sltu]
	set_if_eq addr(Fun, 6'b100000, r_func[8]);
	set_if_eq addur(Fun, 6'b100001, r_func[7]);
	set_if_eq subr(Fun, 6'b100010, r_func[6]);
	set_if_eq subur(Fun, 6'b100011, r_func[5]);
	set_if_eq andr(Fun, 6'b100100, r_func[4]);
	set_if_eq orr(Fun, 6'b100101, r_func[3]);
	set_if_eq sllr(Fun, 6'b000000, r_func[2]);
	set_if_eq sltr(Fun, 6'b101010, r_func[1]);
	set_if_eq sltur(Fun, 6'b101011, r_func[0]);
	
	mux addmux(r_type, 1'b0, r_func[8], func[14]);
	set_if_eq addif(Op, 6'b001000, func[13]);
	mux addumux(r_type, 1'b0, r_func[7], func[12]);
	mux submux(r_type, 1'b0, r_func[6], func[11]);
	mux subumux(r_type, 1'b0, r_func[5], func[10]);
	mux andmux(r_type, 1'b0, r_func[4], func[9]);
	mux ormux(r_type, 1'b0, r_func[3], func[8]);
	mux sllmux(r_type, 1'b0, r_func[2], func[7]);
	set_if_eq lwf(Op, 6'b100011, func[6]);
	set_if_eq swf(Op, 6'b101011, func[5]);
	set_if_eq beqf(Op, 6'b000100, func[4]);
	set_if_eq bnef(Op, 6'b000101, func[3]);
	set_if_eq bgtzf(Op, 6'b000111, func[2]);
	mux sltmux(r_type, 1'b0, r_func[1], func[1]);
	mux sltumux(r_type, 1'b0, r_func[0], func[0]);
	
	wire [1:0] branchors;
	or_gate orb1(func[4], func[3], branchors[1]);
	or_gate orb2(func[2], branchors[1], branchors[0]);
	or_gate ordst(r_type, branchors[0], RegDst);
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


module get_branched(func, equal, nPC_sel);
   input [14:0] func;
   input 	equal;
   output 	nPC_sel;
   
   //nPC_sel branches
   wire 	beq_t;
   and_gate beqand(func[4], equal, beq_t);
   wire 	bne_t,not_equal;
   not_gate noteq(equal, not_equal);
   and_gate bneand(func[3], not_equal, bne_t);
   wire 	bgtz_t, ltorz, not_ltorz;
   or_gate orltorz(equal, sign, ltorz);
   not_gate notltorz(ltorz, not_ltorz);
   and_gate bgtzand(func[2], not_ltorz, bgtz_t);
   wire 	branch_or1;
   or_gate branchor1(beq_t, bne_t, branch_or1);
   or_gate branchor2(branch_or1, bgtz_t, nPC_sel);

endmodule // get_branched


module hazard_detected(hazard);
   output hazard;
   

   
endmodule // hazard_detected

