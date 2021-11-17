`timescale 1 ns/10 ps
//`include "lib/dff.v"
//`include "lib/mux_32.v"
//`include "lib/and_gate.v"
//we use the DFF module and not DFFr because we want falling_edge(clk) function
//putting this here for testing purposes

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
	input wire clk;
	input wire RegWr;
	input wire [DATA_WIDTH-1:0] busW;
	input wire [ADDR_WIDTH-1:0] Rw;
	input wire [ADDR_WIDTH-1:0] Ra;
	input wire [ADDR_WIDTH-1:0] Rb;
	
	//~~~~~~~~~~Outputs~~~~~~~~~~
	output wire [DATA_WIDTH-1:0] busA;
	output wire [DATA_WIDTH-1:0] busB;
	
	//~~~~~~~~~~Internal Variables~~~~~~~~~~
	wire [DATA_WIDTH-1:0] mem_in [0:NUM_REGS-1];
	wire [DATA_WIDTH-1:0] mem_out [0:NUM_REGS-1];
	wire [DATA_WIDTH-1:0] decoder_out;
	wire [DATA_WIDTH-1:0] reg_wr_en;
	
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
	//decode the Rw from 5 bits to an enable bit for each register
   	dec_32 dec_32_1 (
		.sel (Rw), //which register should busW write to?
		.z (decoder_out) //set that register's bit to 1
	);
   
    //enable signal for reg mux
	//Just the result from the decoder AND'ed with the RegWr signal
	genvar j;
	generate
		for (j=0; j < NUM_REGS; j=j+1) begin
			and_gate and_gate_gen(
				.x (decoder_out[j]),
				.y (RegWr),
				.z (reg_wr_en[j])
			);
		end
	endgenerate	
   
   //muxes mem_in (value returned to reg on clock edge) 
   //value between busW and current value based on RegWr and Rw
	genvar k;
	generate
		for(k=0; k < NUM_REGS; k=k+1) begin
			mux_32 mux_32_gen(
				.sel 	({31'b0, reg_wr_en[k]}),
				.src0 	(mem_out[k]),
				.src1 	(busW),
				.z 		(mem_in[k]) 
			);
		end
	endgenerate

	//large mux for passing mem_out (reg values) to busA, busB based on Ra, Rb
	large_mux large_mux_a (
		.sel (Ra),
		.src0 (mem_out[0]), .src1 (mem_out[1]), .src2 (mem_out[2]), .src3 (mem_out[3]), .src4 (mem_out[4]), .src5 (mem_out[5]), .src6 (mem_out[6]), .src7 (mem_out[7]),
		.src8 (mem_out[8]), .src9 (mem_out[9]), .src10 (mem_out[10]), .src11 (mem_out[11]), .src12 (mem_out[12]), .src13 (mem_out[13]), .src14 (mem_out[14]), .src15 (mem_out[15]),
		.src16 (mem_out[16]), .src17 (mem_out[17]), .src18 (mem_out[18]), .src19 (mem_out[19]), .src20 (mem_out[20]), .src21 (mem_out[21]), .src22 (mem_out[22]), .src23 (mem_out[23]),
		.src24 (mem_out[24]), .src25 (mem_out[25]), .src26 (mem_out[26]), .src27 (mem_out[27]), .src28 (mem_out[28]), .src29 (mem_out[29]), .src30 (mem_out[30]), .src31 (mem_out[31]),
		.z (busA)
	);

	large_mux large_mux_b (
		.sel (Rb),
		.src0 (mem_out[0]), .src1 (mem_out[1]), .src2 (mem_out[2]), .src3 (mem_out[3]), .src4 (mem_out[4]), .src5 (mem_out[5]), .src6 (mem_out[6]), .src7 (mem_out[7]),
		.src8 (mem_out[8]), .src9 (mem_out[9]), .src10 (mem_out[10]), .src11 (mem_out[11]), .src12 (mem_out[12]), .src13 (mem_out[13]), .src14 (mem_out[14]), .src15 (mem_out[15]),
		.src16 (mem_out[16]), .src17 (mem_out[17]), .src18 (mem_out[18]), .src19 (mem_out[19]), .src20 (mem_out[20]), .src21 (mem_out[21]), .src22 (mem_out[22]), .src23 (mem_out[23]),
		.src24 (mem_out[24]), .src25 (mem_out[25]), .src26 (mem_out[26]), .src27 (mem_out[27]), .src28 (mem_out[28]), .src29 (mem_out[29]), .src30 (mem_out[30]), .src31 (mem_out[31]),
		.z (busB)
	);

endmodule

/*
module registers_tb ();

	//inputs become registers
	reg clk_tb;
	reg RegWr_tb;
	reg [31:0] busW_tb;
	reg [4:0] Rw;
	reg [4:0] Ra;
	reg [4:0] Rb;

	//outputs become wires
	wire [31:0] busA_tb;
	wire [31:0] busB_tb;

	//instantiate design under test
	registers DUT (
		.clk 	(clk_tb),
		.RegWr 	(RegWr_tb),
		.busW 	(busW_tb),
		.Rw 	(Rw_tb),
		.Ra 	(Ra_tb),
		.Rb 	(Rb_tb),
		.busA 	(busA_tb),
		.busB 	(busB_tb)
	);

	always
	begin
		clk_tb = 1'b0;
		#1;
		clk_tb = 1'b1;
		#1;	
	end

	initial 
	begin
		RegWr_tb = 1'b1;
		busW_tb = 32'h00000000;
		Rw_tb = 5'b00000;
		Ra_tb = 5'b00000;
		Rb_tb = 5'b00000;
		#10;

		RegWr_tb = 1'b1;
		busW_tb = 32'h00000000;
		Rw_tb = 5'b00001;
		Ra_tb = 5'b00001;
		Rb_tb = 5'b00000;
		#10;

		RegWr_tb = 1'b1;
		busW_tb = 32'h00000000;
		Rw_tb = 5'b00010;
		Ra_tb = 5'b00000;
		Rb_tb = 5'b00000;
	end

endmodule
*/

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
        genvar i;
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

module large_mux(
 sel,
 src0, src1, src2, src3, src4, src5, src6, src7,
 src8, src9, src10, src11, src12, src13, src14, src15,
 src16, src17, src18, src19, src20, src21, src22, src23,
 src24, src25, src26, src27, src28, src29, src30, src31,
 z
);

   input [4:0] sel;
   input [31:0] src0;
   input [31:0] src1;
   input [31:0] src2;
   input [31:0] src3;
   input [31:0] src4;
   input [31:0] src5;
   input [31:0] src6;
   input [31:0] src7;
   input [31:0] src8;
   input [31:0] src9;
   input [31:0] src10;
   input [31:0] src11;
   input [31:0] src12;
   input [31:0] src13;
   input [31:0] src14;
   input [31:0] src15;
   input [31:0] src16;
   input [31:0] src17;
   input [31:0] src18;
   input [31:0] src19;
   input [31:0] src20;
   input [31:0] src21;
   input [31:0] src22;
   input [31:0] src23;
   input [31:0] src24;
   input [31:0] src25;
   input [31:0] src26;
   input [31:0] src27;
   input [31:0] src28;
   input [31:0] src29;
   input [31:0] src30;
   input [31:0] src31;
   output [31:0] z;

   wire [31:0] 	 mux0_0;
   wire [31:0] 	 mux0_1;
   wire [31:0] 	 mux0_2;
   wire [31:0] 	 mux0_3;
   wire [31:0] 	 mux0_4;
   wire [31:0] 	 mux0_5;
   wire [31:0] 	 mux0_6;
   wire [31:0] 	 mux0_7;
   wire [31:0] 	 mux0_8;
   wire [31:0] 	 mux0_9;
   wire [31:0] 	 mux0_10;
   wire [31:0] 	 mux0_11;
   wire [31:0] 	 mux0_12;
   wire [31:0] 	 mux0_13;
   wire [31:0] 	 mux0_14;
   wire [31:0] 	 mux0_15;

   wire [31:0] 	 mux1_0;
   wire [31:0] 	 mux1_1;
   wire [31:0] 	 mux1_2;
   wire [31:0] 	 mux1_3;
   wire [31:0] 	 mux1_4;
   wire [31:0] 	 mux1_5;
   wire [31:0] 	 mux1_6;
   wire [31:0] 	 mux1_7;

   wire [31:0] 	 mux2_0;
   wire [31:0] 	 mux2_1;
   wire [31:0] 	 mux2_2;
   wire [31:0] 	 mux2_3;
   
   wire [31:0] 	 mux3_0;
   wire [31:0] 	 mux3_1;

   mux_32 m0_0 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src0),
		.src1 	(src1),
		.z 	(mux0_0)
	);

   mux_32 m0_1 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src2),
		.src1 	(src3),
		.z 	(mux0_1)
	);

   mux_32 m0_2 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src4),
		.src1 	(src5),
		.z 	(mux0_2)
	);

   mux_32 m0_3 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src6),
		.src1 	(src7),
		.z 	(mux0_3)
	);

   mux_32 m0_4 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src8),
		.src1 	(src9),
		.z 	(mux0_4)
	);

   mux_32 m0_5 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src10),
		.src1 	(src11),
		.z 	(mux0_5)
	);

   mux_32 m0_6 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src12),
		.src1 	(src13),
		.z 	(mux0_6)
	);

   mux_32 m0_7 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src14),
		.src1 	(src15),
		.z 	(mux0_7)
	);

   mux_32 m0_8 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src16),
		.src1 	(src17),
		.z 	(mux0_8)
	);

   mux_32 m0_9 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src18),
		.src1 	(src19),
		.z 	(mux0_9)
	);

   mux_32 m0_10 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src20),
		.src1 	(src21),
		.z 	(mux0_10)
	);

   mux_32 m0_11 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src22),
		.src1 	(src23),
		.z 	(mux0_11)
	);

   mux_32 m0_12 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src24),
		.src1 	(src25),
		.z 	(mux0_12)
	);

   mux_32 m0_13 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src26),
		.src1 	(src27),
		.z 	(mux0_13)
	);

   mux_32 m0_14 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src28),
		.src1 	(src29),
		.z 	(mux0_14)
	);

   mux_32 m0_15 (
		.sel 	({31'b0, sel[0]}),
		.src0 	(src30),
		.src1 	(src31),
		.z 	(mux0_15)
	);

   //second layer

   mux_32 m1_0 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_0),
		.src1 	(mux0_1),
		.z 	(mux1_0)
	);

   mux_32 m1_1 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_2),
		.src1 	(mux0_3),
		.z 	(mux1_1)
	);

   mux_32 m1_2 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_4),
		.src1 	(mux0_5),
		.z 	(mux1_2)
	);

   mux_32 m1_3 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_6),
		.src1 	(mux0_7),
		.z 	(mux1_3)
	);

   mux_32 m1_4 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_8),
		.src1 	(mux0_9),
		.z 	(mux1_4)
	);

   mux_32 m1_5 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_10),
		.src1 	(mux0_11),
		.z 	(mux1_5)
	);

   mux_32 m1_6 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_12),
		.src1 	(mux0_13),
		.z 	(mux1_6)
	);

   mux_32 m1_7 (
		.sel 	({31'b0, sel[1]}),
		.src0 	(mux0_14),
		.src1 	(mux0_15),
		.z 	(mux1_7)
	);

   //third layer

   mux_32 m2_0 (
		.sel 	({31'b0, sel[2]}),
		.src0 	(mux1_0),
		.src1 	(mux1_1),
		.z 	(mux2_0)
	);

   mux_32 m2_1 (
		.sel 	({31'b0, sel[2]}),
		.src0 	(mux1_2),
		.src1 	(mux1_3),
		.z 	(mux2_1)
	);

   mux_32 m2_2 (
		.sel 	({31'b0, sel[2]}),
		.src0 	(mux1_4),
		.src1 	(mux1_5),
		.z 	(mux2_2)
	);

   mux_32 m2_3 (
		.sel 	({31'b0, sel[2]}),
		.src0 	(mux1_6),
		.src1 	(mux1_7),
		.z 	(mux2_3)
	);

   //fourth layer

   mux_32 m3_0 (
		.sel 	({31'b0, sel[3]}),
		.src0 	(mux2_0),
		.src1 	(mux2_1),
		.z 	(mux3_0)
	);

   mux_32 m3_1 (
		.sel 	({31'b0, sel[3]}),
		.src0 	(mux2_2),
		.src1 	(mux2_3),
		.z 	(mux3_1)
	);

   //5th layer

   mux_32 m4_0 (
		.sel 	({31'b0, sel[4]}),
		.src0 	(mux3_0),
		.src1 	(mux3_1),
		.z 	(z)
		);
   
endmodule

module dec_32(sel, z);

   input [4:0] sel;
   output reg [31:0] z;

   always @(sel) begin

      case(sel)

		5'b00000: begin z=32'h00000001; end
		5'b00001: begin z=32'h00000002; end
		5'b00010: begin z=32'h00000004; end
		5'b00011: begin z=32'h00000008; end
		5'b00100: begin z=32'h00000010; end
		5'b00101: begin z=32'h00000020; end
		5'b00110: begin z=32'h00000040; end
		5'b00111: begin z=32'h00000080; end
		5'b01000: begin z=32'h00000100; end
		5'b01001: begin z=32'h00000200; end
		5'b01010: begin z=32'h00000400; end
		5'b01011: begin z=32'h00000800; end
		5'b01100: begin z=32'h00001000; end
		5'b01101: begin z=32'h00002000; end
		5'b01110: begin z=32'h00004000; end
		5'b01111: begin z=32'h00008000; end
		5'b10000: begin z=32'h00010000; end
		5'b10001: begin z=32'h00020000; end
		5'b10010: begin z=32'h00040000; end
		5'b10011: begin z=32'h00080000; end
		5'b10100: begin z=32'h00100000; end
		5'b10101: begin z=32'h00200000; end
		5'b10110: begin z=32'h00400000; end
		5'b10111: begin z=32'h00800000; end
		5'b11000: begin z=32'h01000000; end
		5'b11001: begin z=32'h02000000; end
		5'b11010: begin z=32'h04000000; end
		5'b11011: begin z=32'h08000000; end
		5'b11100: begin z=32'h10000000; end
		5'b11101: begin z=32'h20000000; end
		5'b11110: begin z=32'h40000000; end
		5'b11111: begin z=32'h80000000; end

      endcase
   end
endmodule
