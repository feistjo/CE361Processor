// do shit here idk man
// needs adders, mux, extender
`include "extend.v"
`include "lib/sram.v"
`include "lib/syncram.v"
`include "lib/mux_32.v"
`include "ece361_alu_verilog/full_adder_32bit.v"

module pc_branch(pc_in, imm16, nPC_sel, pc_out);
   input [31:0] pc_in;
   input [15:0] imm16;
   input 	nPC_sel;
   output [31:0] pc_out;
   wire [31:0] 	 imm16ext;
   wire [31:0] 	 pc_next;
   wire [31:0] 	 branch_next;
   //wire [31:0] 	 temp_pc_in;
   //wire [31:0] 	 temp_pc_out;

   // start by extending
   extender immext(.in(imm16), .ext(1), .out(imm16ext));

   // PC + 4
   full_adder_32bit nextadd(.x(pc_in),
			    .y(32'b0100),
			    .cin(0), 
			    .z(pc_next), 
			    .cout, 
			    .ovf);
   // PC + 4 (from last add) + imm16 extended
   full_adder_32bit branchadd(.x(pc_next),
			      .y(imm16ext), 
			      .cin(0), 
			      .z(branch_next), 
			      .cout, 
			      .ovf);
   // selects between incrementing pc and branching based on imm16
   mux_32 nPC(.sel({31'b0,nPC_sel}),
	      .src0(pc_next),
	      .src1(branch_next),
	      .z(pc_out));
   
endmodule // fuck_around
