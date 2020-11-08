module mp4(
  input clk,
  input rst,

  // I-Cache
  input icache_resp,
  input icache_rdata,
  output icache_address,
  output icache_read,
  output icache_write,
  output icache_wdata,
  output icache_mbe,

  // D-Cache
  input dcache_resp,
  input dcache_rdata,
  output dcache_address,
  output dcache_read,
  output dcache_write,
  output dcache_wdata,
  output dcache_mbe

);

datapath dp (
  .*
);

endmodule : mp4
