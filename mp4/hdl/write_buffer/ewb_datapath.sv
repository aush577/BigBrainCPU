module ewb_datapath
(
  input clk,
  input rst,
  
  // Lower level port
  input ewb_wdata_i,
  input ewb_address_i,
  output ewb_rdata_o,

  // Higher level port
  input ewb_rdata_i,
  output ewb_wdata_o,
  output ewb_address_o

  // Control
  input ld_data_addr,
  input ld_status
);

register #(.width(32)) 
addr_reg (
  .*,
  .load(ld_data_addr),
  .in(),
  .out()
);

register #(.width(256)) 
data_reg (
  .*,
  .load(ld_data_addr),
  .in(),
  .out()
);

register #(.width(1)) 
status_reg (    // 0 = already written back or invalid, 1 = need to writeback
  .*,
  .load(ld_status),
  .in(),
  .out()
);

endmodule : ewb_datapath
