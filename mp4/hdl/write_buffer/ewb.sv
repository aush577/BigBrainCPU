module ewb
(
  input clk,
  input rst,

  // Lower level port
  input ewb_read_i,
  input ewb_write_i,
  input ewb_wdata_i,
  input ewb_address_i,
  output ewb_rdata_o,
  output ewb_resp_o,

  // Higher level port
  input ewb_rdata_i,
  input ewb_resp_i,
  output ewb_read_o,
  output ewb_write_o,
  output ewb_wdata_o,
  output ewb_address_o
);

// Control - Datapath
logic ld_data_addr;
logic ld_status;

ewb_control ewb_control
(
  .*
);

ewb_datapath ewb_datapath
(
  .*
);

endmodule : ewb
