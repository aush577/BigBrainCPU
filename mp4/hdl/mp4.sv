module mp4(
  input clk,
  input rst,

  // I-Cache
  // input logic icache_resp,
  // input logic [31:0] icache_rdata,
  // output logic [31:0] icache_address,
  // output logic icache_read,

  // D-Cache
  // input logic dcache_resp,
  // input logic [31:0] dcache_rdata,
  // output logic [31:0] dcache_address,
  // output logic dcache_read,
  // output logic dcache_write,
  // output logic [31:0] dcache_wdata,
  // output logic [3:0] dcache_mbe

  // Memory
  input mem_resp,
  input [63:0] mem_rdata,
  output logic mem_read,
  output logic mem_write,
  output [31:0] mem_address,
  output [63:0] mem_wdata
);

// I-Cache <-> CPU
logic icache_resp;
logic [31:0] icache_rdata;
logic [31:0] icache_address;
logic icache_read;

// D-Cache <-> CPU
logic dcache_resp;
logic [31:0] dcache_rdata;
logic [31:0] dcache_address;
logic dcache_read;
logic dcache_write;
logic [31:0] dcache_wdata;
logic [3:0] dcache_mbe;

// I-Cache <-> Arbiter
logic arb_icache_resp;
logic [255:0] arb_icache_rdata;
logic [31:0] arb_icache_address;
logic arb_icache_read;
logic arb_icache_write;
logic [255:0] arb_icache_wdata;
      
// D-Cache <-> Arbiter
logic arb_dcache_resp;
logic [255:0] arb_dcache_rdata;
logic [31:0] arb_dcache_address;
logic arb_dcache_read;
logic arb_dcache_write;
logic [255:0] arb_dcache_wdata;

// Arbiter <-> Cacheline
logic arb_mem_resp;
logic [255:0] arb_mem_rdata;
logic [31:0] arb_mem_address;
logic arb_mem_read;
logic arb_mem_write;
logic [255:0] arb_mem_wdata;

datapath dp (
  .*
);

cache icache (
  .clk(clk),

  // Arbiter
  .pmem_resp(arb_icache_resp),
  .pmem_rdata(arb_icache_rdata),
  .pmem_address(arb_icache_address),
  .pmem_wdata(arb_icache_wdata),
  .pmem_read(arb_icache_read),
  .pmem_write(arb_icache_write),

  // CPU
  .mem_read(icache_read),
  .mem_write(1'b0),
  .mem_byte_enable_cpu(4'b0),
  .mem_address(icache_address),
  .mem_wdata_cpu(32'b0),
  .mem_resp(icache_resp),
  .mem_rdata_cpu(icache_rdata)
);

cache dcache (
  .clk(clk),

  // Arbiter
  .pmem_resp(arb_dcache_resp),
  .pmem_rdata(arb_dcache_rdata),
  .pmem_address(arb_dcache_address),
  .pmem_wdata(arb_dcache_wdata),
  .pmem_read(arb_dcache_read),
  .pmem_write(arb_dcache_write),

  // CPU
  .mem_read(dcache_read),
  .mem_write(dcache_write),
  .mem_byte_enable_cpu(dcache_mbe),
  .mem_address(dcache_address),
  .mem_wdata_cpu(dcache_wdata),
  .mem_resp(dcache_resp),
  .mem_rdata_cpu(dcache_rdata)
);

arbiter arbiter (
  .*
);

cacheline_adaptor cacheline_adaptor (
  .clk(clk),
	.reset_n(~rst),

	// Arbiter
	.line_i(arb_mem_wdata),
	.line_o(arb_mem_rdata),
	.address_i(arb_mem_address),
	.read_i(arb_mem_read),
	.write_i(arb_mem_write),
	.resp_o(arb_mem_resp),

	// Memory
	.burst_i(mem_rdata),
	.burst_o(mem_wdata),
	.address_o(mem_address),
	.read_o(mem_read),
	.write_o(mem_write),
	.resp_i(mem_resp)
);

endmodule : mp4
