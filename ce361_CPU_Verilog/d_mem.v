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

endmodule