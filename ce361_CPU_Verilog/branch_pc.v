// do shit here idk man
// needs adders, mux, extender
`include "extend.v"
//`include "registers.v"
`include "lib/sram.v"
//`include "lib/syncram.v"
`include "lib/mux_32.v"
//`include "ece361_alu_verilog/adder_32.v"
//`include "ece361_alu_verilog/ALU_noincludes.v"

module pc_branch_dff(clk);
   input clk;
   // call pc_branch here with clock
   
endmodule // pc_branch_dff


module pc_branch(pc_in, imm16, nPC_sel, pc_out);
   input [31:0] pc_in;
   input [15:0] imm16;
   input 	nPC_sel;
   output [31:0] pc_out;
   wire [31:0] 	 imm16ext;
   wire [31:0] 	 pc_next;
   wire [31:0] 	 branch_next;
   
   // start by extending
   extender immext(.in(imm16), .ext(1), .out(imm16ext));

   // PC + 4
   assign pc_next = pc_in + 32'b0100;

   // structural code:
   /*
   adder_32 nextadd(.a(pc_in),
		    .b(32'b0100), 
		    .z(pc_next));
    */
   // PC + 4 (from last add) + imm16 extended
   assign branch_next = pc_next + imm16ext;

   // structural code:
   /*
   adder_32 branchadd(.a(pc_next),
		      .b(imm16ext),  
		      .z(branch_next));
    */
   
   // selects between incrementing pc and branching based on imm16
   mux_32 nPC(.sel({31'b0,nPC_sel}),
	      .src0(pc_next),
	      .src1(branch_next),
	      .z(pc_out));
   
endmodule // branch_pc
