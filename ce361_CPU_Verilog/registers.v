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
	reg [DATA_WIDTH-1:0] mem [0:NUM_REGS-1];
	
	//~~~~~~~~~~Function~~~~~~~~~~
	
	//busA <= mem[Ra];
	//busB <= mem[Rb];
	//if(rising_edge(clk){
	//	if(RegWr){mem[Rw] <= busW} end if;
	//}

endmodule