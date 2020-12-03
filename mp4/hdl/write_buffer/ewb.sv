module ewb
(
  input clk,
  input rst,

  // Lower level port
  input ewb_read_i,
  input ewb_write_i,
  input [255:0] ewb_wdata_i,
  input [31:0] ewb_address_i,
  output [255:0] ewb_rdata_o,
  output ewb_resp_o,

  // Higher level port
  input [255:0] ewb_rdata_i,
  input ewb_resp_i,
  output ewb_read_o,
  output ewb_write_o,
  output [255:0] ewb_wdata_o,
  output [31:0] ewb_address_o
);

// Control - Datapath
logic hit;
logic ld_data_addr;
logic ld_status;
logic rdata_o_sel;
logic status_reg_in;

ewb_control ewb_control
(
  .*
);

ewb_datapath ewb_datapath
(
  .*
);

endmodule : ewb
