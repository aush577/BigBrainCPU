module new_cache_datapath #(
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

	// Bus Adapter / CPU
	input logic [31:0] mem_address,
	input logic [s_line-1:0] mem_wdata256,
	input logic [31:0] mem_byte_enable256,
	output logic [s_line-1:0] mem_rdata256,
	
	// Cacheline Adapter
	input logic [s_line-1:0] pmem_rdata,
	output logic [31:0] pmem_address,
	output logic [s_line-1:0] pmem_wdata,
	
	// Control
	input logic data_in_sel,
	input logic pmem_addr_sel,
	input logic [1:0] wr_en_data_0_sel,
	input logic [1:0] wr_en_data_1_sel,
	
	input logic dirty_in,
	input logic valid_in,
	
	input logic ld_dirty_0,
	input logic ld_dirty_1,
	input logic ld_valid_0,
	input logic ld_valid_1,
	input logic ld_tag_0,
	input logic ld_tag_1,
	input logic ld_lru,
	
	output logic dirty_out,
	output logic miss,
	output logic way
);

logic [s_index-1:0] index_in;
assign index_in = mem_address[(s_offset + s_index - 1):s_offset];

logic [s_tag-1:0] tag_in;
assign tag_in = mem_address[31:(s_offset + s_index)];

logic dirty_0_out, dirty_1_out;

logic valid_0_out, valid_1_out;

logic [s_tag-1:0] tag_0_out, tag_1_out;
logic [s_tag-1:0] tag_out;

logic lru_out;

logic [s_line-1:0] data_in;
logic [s_line-1:0] data_0_out, data_1_out;
logic [s_line-1:0] data_out;
assign pmem_wdata = data_out;
assign mem_rdata256 = data_out;

logic [31:0] wr_en_data_0;
logic [31:0] wr_en_data_1;

logic hit_0, hit_1;
assign hit_0 = ((tag_0_out == tag_in) & valid_0_out);
assign hit_1 = ((tag_1_out == tag_in) & valid_1_out);
assign miss = ~(hit_0 | hit_1);

new_array #(.s_index(s_index), .width(1)) dirty_array_0 (
	.*,
	.read(1'b1),
	.load(ld_dirty_0),
	.rindex(index_in),
	.windex(index_in),
	.datain(dirty_in),
	.dataout(dirty_0_out)
);

new_array #(.s_index(s_index), .width(1)) dirty_array_1 (
	.*,
	.read(1'b1),
	.load(ld_dirty_1),
	.rindex(index_in),
	.windex(index_in),
	.datain(dirty_in),
	.dataout(dirty_1_out)
);

new_array #(.s_index(s_index), .width(1)) valid_array_0 (
	.*,
	.read(1'b1),
	.load(ld_valid_0),
	.rindex(index_in),
	.windex(index_in),
	.datain(valid_in),
	.dataout(valid_0_out)
);

new_array #(.s_index(s_index), .width(1)) valid_array_1 (
	.*,
	.read(1'b1),
	.load(ld_valid_1),
	.rindex(index_in),
	.windex(index_in),
	.datain(valid_in),
	.dataout(valid_1_out)
);

new_array #(.s_index(s_index), .width(s_tag)) tag_array_0 (
	.*,
	.read(1'b1),
	.load(ld_tag_0),
	.rindex(index_in),
	.windex(index_in),
	.datain(tag_in),
	.dataout(tag_0_out)
);

new_array #(.s_index(s_index), .width(s_tag)) tag_array_1 (
	.*,
	.read(1'b1),
	.load(ld_tag_1),
	.rindex(index_in),
	.windex(index_in),
	.datain(tag_in),
	.dataout(tag_1_out)
);

new_array #(.s_index(s_index), .width(1)) lru_array (
	.*,
	.read(1'b1),
	.load(ld_lru),
	.rindex(index_in),
	.windex(index_in),
	.datain(~way),
	.dataout(lru_out)
);

new_data_array #(.s_offset(s_offset), .s_index(s_index)) data_array_0 (
	.*,
  .read(1'b1),
  .write_en(wr_en_data_0),
  .rindex(index_in),
  .windex(index_in),
	.datain(data_in),
	.dataout(data_0_out)
);

new_data_array #(.s_offset(s_offset), .s_index(s_index)) data_array_1 (
	.*,
  .read(1'b1),
  .write_en(wr_en_data_1),
  .rindex(index_in),
  .windex(index_in),
	.datain(data_in),
	.dataout(data_1_out)
);


always_comb begin
	
	// way mux
	unique case (miss)
		1'b0:	way = hit_1;		// Way that has hit
		1'b1:	way = lru_out;	// Way to replace
		default:	way = hit_1;
	endcase
	
	// dirty_out mux
	unique case (way)
		1'b0:	dirty_out = dirty_0_out;
		1'b1:	dirty_out = dirty_1_out;
		default:	dirty_out = dirty_0_out;
	endcase
	
	// tag_out mux
	unique case (way)
		1'b0:	tag_out = tag_0_out;
		1'b1:	tag_out = tag_1_out;
		default:	tag_out = tag_0_out;
	endcase
	
	// data_out mux
	unique case (way)
		1'b0:	data_out = data_0_out;
		1'b1:	data_out = data_1_out;
		default:	data_out = data_0_out;
	endcase
	
	// data_in mux
	unique case (data_in_sel)
		1'b0:	data_in = pmem_rdata;			// Load from pmem
		1'b1:	data_in = mem_wdata256;		// Load from cpu
		default:	data_in = pmem_rdata;
	endcase
	
	// pmem_address mux
	unique case (pmem_addr_sel)
		1'b0:	pmem_address = {tag_out, index_in, 5'b0};		// Writeback address
		1'b1:	pmem_address = {tag_in, index_in, 5'b0};		// CPU address
		default:	pmem_address = {tag_out, index_in, 5'b0};
	endcase
	
	// write enable data 0 mux
	unique case (wr_en_data_0_sel)
		2'b00:	wr_en_data_0 = 32'h00000000;
		2'b01:	wr_en_data_0 = 32'hFFFFFFFF;
		2'b10:	wr_en_data_0 = mem_byte_enable256;
		default:	wr_en_data_0 = 32'h00000000;
	endcase
	
	// write enable data 1 mux
	unique case (wr_en_data_1_sel)
		2'b00:	wr_en_data_1 = 32'h00000000;
		2'b01:	wr_en_data_1 = 32'hFFFFFFFF;
		2'b10:	wr_en_data_1 = mem_byte_enable256;
		default:	wr_en_data_1 = 32'h00000000;
	endcase
	
end

endmodule : new_cache_datapath
