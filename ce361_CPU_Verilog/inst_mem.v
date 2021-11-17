`include "branch_pc.v"
`include "lib/sram.v"

module fetch_inst(clk, inst);
   input clk;
   output [31:0] inst;
   wire [31:0] 	 pc_addr;
   wire [31:0] 	 dump;
   

   // Get pc first
   pc_clk rpc(.clk(clk),
	      .nPC_sel(1'b0),
	      .imm16(16'b0),
	      .pc_fin(pc_addr),
	      .read_val(dump));

   // question: we should never be writing to instruction memory right?
 sram sram_get(.cs(1'b1),
	       .oe(1'b1),
	       .we(1'b0),
	       .addr(pc_addr),
	       .din(32'hFFFFFFFF),
	       .dout(inst));
   defparam sram_get.mem_file = "data/bills_branch.dat";
   
   


endmodule // fetch_mem
