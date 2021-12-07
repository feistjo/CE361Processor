// do shit here idk man
// needs adders, mux, extender
`include "extend.v"
`include "lib/mux_32.v"

module pc_clk(clk, nPC_sel, imm16, pc_fin, steve, read_val);
   input clk;
   input nPC_sel;
   input [15:0] imm16;
   input         steve;
   output [31:0] pc_fin;
   output [31:0] read_val; // also for debug
   wire [31:0] 	 temp_pc;
   wire [31:0] 	 prev_pc;
   wire [31:0] 	 imm16ext;

   // start by extending
   extender18 immext(.in({imm16, 2'b0}), .ext(1'b1), .out(imm16ext));
   
   // read pc and store in prev
   pc_register pc(.in(prev_pc),
		  .clk(clk),
		  .nPC_sel(nPC_sel),
        .steve(steve),
		  .imm16(imm16ext),
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
       
endmodule // pc_clk

module extender18(in, ext, out);
   input [17:0] in;
   input 	ext;
   output [31:0] out;
   wire 	 sign;

   and_gate si(.x(ext), .y(in[17]), .z(sign));
   assign out = {{14{sign}},{in[17:0]}};

endmodule // extender

// register for the pc. if rw = 0 read, if rw = 1 write
module pc_register(in, clk, nPC_sel, steve, imm16, out);
   input [31:0] in;
   input 	nPC_sel;
   input [31:0] imm16;
   input 	clk;
   input steve;
   output reg [31:0] out;
   reg [31:0] pc = 32'h00400020;
     
   initial begin
      out <= 32'h00400020;
   end
   
   always @(negedge clk)
     begin  
        if (steve) 
        begin
            if (nPC_sel == 0) begin
	            pc <= pc + 4;
	            out <= pc + 4;
	         end
	      else begin
	         if (nPC_sel == 1) begin
	            pc <= pc - 4 + imm16;
	            out <= pc - 4 + imm16;
	         end	   
	      end
        end
        else if (!steve)
        begin
          out <= pc; 
        end
     end // always @ (negedge clk)
   
endmodule // pc_register


module pc_branch(pc_in, imm16, nPC_sel, pc_out);
   input [31:0] pc_in;
   input [15:0] imm16;
   input 	nPC_sel;
   output [31:0] pc_out;
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

