//`include "lib/dff.v"
//we use the DFF module and not DFFr because we want falling_edge(clk) function
//putting this here for testing purposes
module dff (clk, d, q);
    input clk;
    input d;
    output reg q;
    
    always @(negedge clk)
      begin
         q <= d;
      end
      
endmodule 

module dff_32 (
	clk,
	d_32,
	q_32
	);
	
	//~~~~~~~~~~parameters~~~~~~~~~~
	parameter DATA_WIDTH = 32;
	
	//~~~~~~~~~~inputs~~~~~~~~~~
	input clk;
	input [DATA_WIDTH-1:0] d_32;
	
	//~~~~~~~~~~outputs~~~~~~~~~~
	output [DATA_WIDTH-1:0] q_32;
	
	//~~~~~~~~~~functionality~~~~~~~~~~
	genvar i
	generate 
		for(i = 0; i < DATA_WIDTH; i=i+1) 
		begin
			dff cust_dff (
				      .clk 	(clk),
				      .d 	(d_32[i]),
				      .q 	(q_32[i])
			);
		end
	endgenerate
	
endmodule

module registers (
	clk,
	RegWr,
	busW,
	Rw,
	Ra,
	Rb,
	busA,
	busB
);
	//~~~~~~~~~~Parameters~~~~~~~~~~
	parameter DATA_WIDTH = 32;
	parameter NUM_REGS = 32;
	parameter ADDR_WIDTH = 5;
	
	//~~~~~~~~~~Inputs~~~~~~~~~~
	input clk;
	input RegWr;
	input [DATA_WIDTH-1:0] busW;
	input [ADDR_WIDTH-1:0] Rw;
	input [ADDR_WIDTH-1:0] Ra;
	input [ADDR_WIDTH-1:0] Rb;
	
	//~~~~~~~~~~Outputs~~~~~~~~~~
	output [DATA_WIDTH-1:0] busA;
	output [DATA_WIDTH-1:0] busB;
	
	//~~~~~~~~~~Internal Variables~~~~~~~~~~
	wire [DATA_WIDTH-1:0] mem_in [0:NUM_REGS-1];
	wire [DATA_WIDTH-1:0] mem_out [0:NUM_REGS-1];
	
	//generate our register array
	genvar i;
	generate 
		for (i = 0; i < NUM_REGS; i = i+1) begin
			dff_32 cust_dff_32 (
				.clk 	(clk),
				.d_32 	(mem_in[i]),
				.q_32 	(mem_out[i])
			);
		end
	endgenerate
	
	//~~~~~~~~~~Function~~~~~~~~~~
	assign busA = mem_out[Ra];
	assign busB = mem_out[Rb];
	
	//if(RegWr) {mem[Rw] <= busW} 
	mux_32 cust_mux_32 (
		.sel 	(RegWr),
		.src0 	(mem_out[Rw]),
		.src1 	(busW),
		.z 		(mem_in[Rw])
	);

endmodule
