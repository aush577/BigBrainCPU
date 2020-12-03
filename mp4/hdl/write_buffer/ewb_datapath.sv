module ewb_datapath
(
  input clk,
  input rst,
  
  // Lower level port
  input [255:0] ewb_wdata_i,
  input [31:0] ewb_address_i,
  output [255:0] ewb_rdata_o,

  // Higher level port
  input [255:0] ewb_rdata_i,
  output [255:0] ewb_wdata_o,
  output [31:0] ewb_address_o,

  // Control
  input ld_data_addr,
  input ld_status,
  input rdata_o_sel,
  input status_reg_in,
  output logic hit
);

logic [31:0] addr_reg_out;
logic [255:0] data_reg_out;
logic status_reg_out;

assign hit = (addr_reg_out == ewb_address_i) & status_reg_out;
assign ewb_rdata_o = (rdata_o_sel) ? data_reg_out : ewb_rdata_i;
assign ewb_wdata_o = data_reg_out;
assign ewb_address_o = addr_reg_out;

register #(.width(32)) 
addr_reg (
  .*,
  .load(ld_data_addr),
  .in(ewb_address_i),
  .out(addr_reg_out)
);

register #(.width(256)) 
data_reg (
  .*,
  .load(ld_data_addr),
  .in(ewb_wdata_i),
  .out(data_reg_out)
);

register #(.width(1)) 
status_reg (    // 0 = invalid, 1 = valid
  .*,
  .load(ld_status),
  .in(status_reg_in),
  .out(status_reg_out)
);

endmodule : ewb_datapath
