// sign and zero extend.
//`include "lib/and_gate.v" included by ALU
//`timescale 1ns/10ps

module extender(in, ext, out);
   input [15:0] in;
   input 	ext;
   output [31:0] out;
   wire 	 sign;

   and_gate si(.x(ext), .y(in[15]), .z(sign));
   assign out = {{16{sign}},{in[15:0]}};

endmodule // extender
