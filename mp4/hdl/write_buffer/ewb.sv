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
logic addr_o_sel;

ewb_control ewb_control
(
  .*
);

ewb_datapath ewb_datapath
(
  .*
);

// assign ewb_rdata_o = ewb_rdata_i;
// assign ewb_resp_o = ewb_resp_i;
// assign ewb_read_o = ewb_read_i;
// assign ewb_write_o = ewb_write_i;
// assign ewb_wdata_o = ewb_wdata_i;
// assign ewb_address_o = ewb_address_i;

endmodule : ewb
