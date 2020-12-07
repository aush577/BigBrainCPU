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

// L2 Cache <-> EWB
logic ewb_read_i;
logic ewb_write_i;
logic [255:0] ewb_wdata_i;
logic [31:0] ewb_address_i;
logic [255:0] ewb_rdata_o;
logic ewb_resp_o;

// EWB <-> Cacheline Adapter
logic [255:0] ewb_rdata_i;
logic ewb_resp_i;
logic ewb_read_o;
logic ewb_write_o;
logic [255:0] ewb_wdata_o;
logic [31:0] ewb_address_o;


logic l2_pmem_resp;
logic [255:0] l2_pmem_rdata;
logic [31:0] l2_pmem_address;
logic [255:0] l2_pmem_wdata;
logic l2_pmem_read;
logic l2_pmem_write;

//buffer signals from L2 <-> Arbiter
logic arb_mem_read_buf;
logic arb_mem_write_buf;
logic [31:0] arb_mem_address_buf;
logic [255:0] arb_mem_wdata_buf;
logic arb_mem_resp_buf;
logic [255:0] arb_mem_rdata_buf;

datapath dp (
  .*
);

l2_cache #(.s_offset(5), .s_index(4)) l2_cache (
  .*,

  // cacheline
  .pmem_resp(l2_pmem_resp),
  .pmem_rdata(l2_pmem_rdata),
  .pmem_address(l2_pmem_address),
  .pmem_wdata(l2_pmem_wdata),
  .pmem_read(l2_pmem_read),
  .pmem_write(l2_pmem_write),

  // arb
  .mem_read(arb_mem_read_buf),
  .mem_write(arb_mem_write_buf),
  .mem_address(arb_mem_address_buf),
  .mem_wdata256(arb_mem_wdata_buf),
  .mem_resp(arb_mem_resp_buf),
  .mem_rdata256(arb_mem_rdata_buf)
);


always_ff @(posedge clk) begin
  arb_mem_read_buf <= arb_mem_read;
  arb_mem_write_buf <= arb_mem_write;
  arb_mem_address_buf <= arb_mem_address;
  arb_mem_wdata_buf <= arb_mem_wdata;
end
assign arb_mem_resp = arb_mem_resp_buf;
assign arb_mem_rdata = arb_mem_rdata_buf;

// ewb ewb (
//   .*, 
//   .ewb_rdata_i(arb_dcache_rdata),
//   .ewb_resp_i(arb_dcache_resp),
//   .ewb_read_o(arb_dcache_read),
//   .ewb_write_o(arb_dcache_write),
//   .ewb_wdata_o(arb_dcache_wdata),
//   .ewb_address_o(arb_dcache_address)
// );

new_cache icache (
  .*,

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

new_cache dcache (
  .*,

  // Arbiter
  .pmem_resp(arb_dcache_resp),
  .pmem_rdata(arb_dcache_rdata),
  .pmem_address(arb_dcache_address),
  .pmem_wdata(arb_dcache_wdata),
  .pmem_read(arb_dcache_read),
  .pmem_write(arb_dcache_write),

  // //EWB
  // .pmem_resp(ewb_resp_o),
  // .pmem_rdata(ewb_rdata_o),
  // .pmem_address(ewb_address_i),
  // .pmem_wdata(ewb_wdata_i),
  // .pmem_read(ewb_read_i),
  // .pmem_write(ewb_write_i),

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

	// l2
	.line_i(l2_pmem_wdata),
	.line_o(l2_pmem_rdata),
	.address_i(l2_pmem_address),
	.read_i(l2_pmem_read),
	.write_i(l2_pmem_write),
	.resp_o(l2_pmem_resp),

	// Memory
	.burst_i(mem_rdata),
	.burst_o(mem_wdata),
	.address_o(mem_address),
	.read_o(mem_read),
	.write_o(mem_write),
	.resp_i(mem_resp)
);

endmodule : mp4
