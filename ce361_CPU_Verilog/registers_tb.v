module registers_tb ();

	//inputs become registers
	reg clk_tb;
	reg RegWr_tb;
	reg [31:0] busW_tb;
	reg [4:0] Rw_tb;
	reg [4:0] Ra_tb;
	reg [4:0] Rb_tb;

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
	   #10;
	   $finish; // lance added this
	  
	end

endmodule
