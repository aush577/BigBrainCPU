module new_cache_control
(
	input clk,
	input rst,
	
	// CPU
	input logic mem_read,
	input logic mem_write,
	output logic mem_resp,
	
	// Cacheline Adapter
	input logic pmem_resp,
	output logic pmem_read,
	output logic pmem_write,
	
	// Datapath
	input logic dirty_out,
	input logic miss,
	input logic way,
	
	output logic data_in_sel,
	output logic pmem_addr_sel,
	output logic [1:0] wr_en_data_0_sel,
	output logic [1:0] wr_en_data_1_sel,

	output logic dirty_in,
	output logic valid_in,

	output logic ld_dirty_0,
	output logic ld_dirty_1,
	output logic ld_valid_0,
	output logic ld_valid_1,
	output logic ld_tag_0,
	output logic ld_tag_1,
	output logic ld_lru
);

// States
enum int unsigned {
	// idle = 0,
	checkHit = 1,
	read = 2,
	writeback = 3
} state, next_state;

function void set_defaults();
	mem_resp = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	data_in_sel = 1'b1;
	pmem_addr_sel = 1'b1;
	wr_en_data_0_sel = 2'b00;
	wr_en_data_1_sel = 2'b00;
	dirty_in = 1'b0;
	valid_in = 1'b0;
	ld_dirty_0 = 1'b0;
	ld_dirty_1 = 1'b0;
	ld_valid_0 = 1'b0;
	ld_valid_1 = 1'b0;
	ld_tag_0 = 1'b0;
	ld_tag_1 = 1'b0;
	ld_lru = 1'b0;
endfunction


// State Output Signals
always_comb
begin
	set_defaults();
	unique case (state)
	
		// idle: begin
		// 	// None
		// end
		
		checkHit: begin
			if (~miss & mem_read) begin
				ld_lru = 1'b1;
				mem_resp = 1'b1;
			end
			if (~miss & mem_write) begin
				data_in_sel = 1'b1;
				if (way) begin wr_en_data_1_sel = 2'b10; end else begin wr_en_data_0_sel = 2'b10; end
				dirty_in = 1'b1;
				if (way) begin ld_dirty_1 = 1'b1; end else begin ld_dirty_0 = 1'b1; end
				ld_lru = 1'b1;
				mem_resp = 1'b1;
			end
		end
		
		read: begin
			data_in_sel = 1'b0;
			pmem_addr_sel = 1'b1;
			pmem_read = 1'b1;
			if (pmem_resp) begin
				if (way) begin wr_en_data_1_sel = 2'b01; end else begin wr_en_data_0_sel = 2'b01; end
				if (way) begin ld_tag_1 = 1'b1; end else begin ld_tag_0 = 1'b1; end
				valid_in = 1'b1;
				if (way) begin ld_valid_1 = 1'b1; end else begin ld_valid_0 = 1'b1; end
			end
		end
		
		writeback: begin
			pmem_addr_sel = 1'b0;
			pmem_write = 1'b1;
			dirty_in = 1'b0;
			if (way) begin ld_dirty_1 = 1'b1; end else begin ld_dirty_0 = 1'b1; end
		end
		
		default: begin
			set_defaults();
		end
		
	endcase
end


// Next State Logic
always_comb
begin
	if (rst) begin
		// next_state <= idle;
		next_state <= checkHit;
	end else begin
		unique case (state)
		
			// idle: begin
			// 	if (mem_read | mem_write) begin
			// 		next_state <= checkHit;
			// 	end else begin
			// 		next_state <= idle;
			// 	end
			// end
			
			checkHit: begin
				if (mem_read | mem_write) begin
					if (~miss) begin
						// next_state <= idle;
						next_state <= checkHit;
					end else begin
						if (miss & ~dirty_out) begin
							next_state <= read;
						end else begin	// miss & dirty_out
							next_state <= writeback;
						end
					end
				end else begin
					next_state <= checkHit;
				end
			end
			
			read: begin
				if (pmem_resp) begin
					next_state <= checkHit;
				end else begin
					next_state <= read;
				end
			end
			
			writeback: begin
				if (pmem_resp) begin
					next_state <= read;
				end else begin
					next_state <= writeback;
				end
			end
			
			default: begin
				// next_state <= idle;
				next_state <= checkHit;
			end
			
		endcase
	end
end

// State transition
always_ff @(posedge clk)
begin
	state <= next_state;
end

endmodule : new_cache_control
