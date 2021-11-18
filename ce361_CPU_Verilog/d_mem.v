//make sure to compile a syncram.v at some point before compiling this
`include "lib/syncram.v"


module d_mem(
    clk, //falling edge triggered
    data_in,
    data_out,
    adr,
    WrEn
);

    //~~~~~~~~~~Parameters~~~~~~~~~~
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;

    //~~~~~~~~~~Inputs~~~~~~~~~~
    input clk;
    input WrEn;
    input [DATA_WIDTH-1:0] data_in;
    input [ADDR_WIDTH-1:0] adr;

    //~~~~~~~~~~Outputs~~~~~~~~~~
    output [DATA_WIDTH-1:0] data_out;

    //~~~~~~~~~~Functions~~~~~~~~~~
    syncram syncram_1 (
        .clk (clk),
        .cs (1'b1),
        .oe (1'b1),
        .we (WrEn),
        .addr (adr),
        .din (data_in),
        .dout (data_out)
    );

    defparam syncram_1.mem_file = "penis.dat";

endmodule