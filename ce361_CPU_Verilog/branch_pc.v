// do shit here idk man
// needs adders, mux, extender
`include "extend.v"
`include "lib/mux_32.v"

module pc_clk(clk, nPC_sel, imm16, pc_fin, read_val);
   input clk;
   input nPC_sel;
   input [15:0] imm16;
   output [31:0] pc_fin;
   output [31:0] read_val; // also for debug
   wire [31:0] 	 temp_pc;
   wire [31:0] 	 prev_pc;	 

   // read pc and store in prev
   pc_register pc(.in(prev_pc),
		  .clk(clk),
		  .out(temp_pc));

   assign read_val = temp_pc;
   assign pc_fin = temp_pc;

   /*
   // perform op
   pc_branch fuct(.pc_in(prev_pc),
		  .imm16(imm16),
		  .nPC_sel(nPC_sel),
		  .pc_out(temp_pc));
    */
       
endmodule // pc_branch_dff

// register for the pc. if rw = 0 read, if rw = 1 write
module pc_register(in, clk,  out);
   input [31:0] in;
   input 	clk;
   output reg [31:0] out;
   reg [31:0] 	     pc = 32'h00400020;	     
   initial begin
      out <= 32'h00400020;
   end
   
   always @(negedge clk)
     begin
	out <= pc;
	pc <= in;
     end // always @ (negedge clk)
   
endmodule // pc_register


module pc_branch(pc_in, imm16, nPC_sel, pc_out);
   input [31:0] pc_in;
   input [15:0] imm16;
   input 	nPC_sel;
   output reg [31:0] pc_out;
   wire [31:0] 	 imm16ext;
   wire [31:0] 	 pc_next;
   wire [31:0] 	 branch_next;
   
   // start by extending
   extender immext(.in(imm16), .ext(1'b1), .out(imm16ext));

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

