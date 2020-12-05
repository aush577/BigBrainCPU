module l2_cache #(
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

	// Cacheline Adapter
	input mem_read,
	input mem_write,
	input [s_line-1:0] mem_wdata256,
	input [31:0] mem_address,
	output [s_line-1:0] mem_rdata256,
	output mem_resp,

	// EWB
	input [s_line-1:0] pmem_rdata,
	input pmem_resp,
	output pmem_read,
	output pmem_write,
	output [s_line-1:0] pmem_wdata,
	output [31:0] pmem_address
);

// Control - Datapath;
logic dirty_out;
logic miss;
logic way;
logic data_in_sel;
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

logic [31:0] mem_byte_enable256;
assign mem_byte_enable256 = 32'hFFFFFFFF;

new_cache_control control
(
	.*
);

new_cache_datapath #(.s_index(s_index)) datapath
(
	.*
);

endmodule : l2_cache
