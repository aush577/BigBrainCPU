module new_cache #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
	input clk,
	input rst,

	// CPU / Bus Adapter
	input mem_read,
	input mem_write,
	input [31:0] mem_wdata_cpu,
	input [3:0] mem_byte_enable_cpu,
	input [31:0] mem_address,
	output [31:0] mem_rdata_cpu,
	output mem_resp,

	// Cacheline Adapter
	input [255:0] pmem_rdata,
	input pmem_resp,
	output pmem_read,
	output pmem_write,
	output [255:0] pmem_wdata,
	output [31:0] pmem_address
);


// Bus Adapter - Cache
logic [255:0] mem_wdata256;
logic [255:0] mem_rdata256;
logic [31:0] mem_byte_enable256;

// Control - Datapath;
logic dirty_out;
logic miss;
logic way;
logic [1:0] data_in_sel;
logic pmem_addr_sel;
logic [1:0] wr_en_data_0_sel;
logic [1:0] wr_en_data_1_sel;
logic dirty_in;
logic valid_in;
logic ld_dirty_0;
logic ld_dirty_1;
logic ld_valid_0;
logic ld_valid_1;
logic ld_tag_0;
logic ld_tag_1;
logic ld_lru;

//Prefetching
logic index_sel;

new_cache_control control
(
	.*
);

new_cache_datapath datapath
(
	.*
);

new_bus_adapter bus_adapter
(
	.*,
  .mem_wdata(mem_wdata_cpu),
  .mem_rdata(mem_rdata_cpu),
  .mem_byte_enable(mem_byte_enable_cpu),
	.address(mem_address)
);

endmodule : new_cache
