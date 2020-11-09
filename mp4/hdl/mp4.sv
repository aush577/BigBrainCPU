module mp4(
  input clk,
  input rst,

  // I-Cache
  input logic icache_resp,
  input logic [31:0] icache_rdata,
  output logic [31:0] icache_address,
  output logic icache_read,

  // D-Cache
  input logic dcache_resp,
  input logic [31:0] dcache_rdata,
  output logic [31:0] dcache_address,
  output logic dcache_read,
  output logic dcache_write,
  output logic [31:0] dcache_wdata,
  output logic [3:0] dcache_mbe
);

datapath dp (
  .*
);

endmodule : mp4
