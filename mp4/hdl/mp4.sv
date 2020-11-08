module mp4(
  input clk,
  input rst,

  // I-Cache
  input icache_resp,
  input icache_rdata,
  output [31:0] icache_address,
  output icache_read,
  output icache_write,
  output [31:0] icache_wdata,
  output [3:0] icache_mbe,

  // D-Cache
  input dcache_resp,
  input dcache_rdata,
  output [31:0] dcache_address,
  output dcache_read,
  output dcache_write,
  output [31:0] dcache_wdata,
  output [3:0] dcache_mbe
);

datapath dp (
  .*
);

endmodule : mp4
