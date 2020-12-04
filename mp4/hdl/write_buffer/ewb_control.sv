module ewb_control
(
  input clk,
  input rst,

  // Lower level port
  input ewb_read_i,
  input ewb_write_i,
  output logic ewb_resp_o,

  // Higher level port
  input ewb_resp_i,
  output logic ewb_read_o,
  output logic ewb_write_o,

  // Datapath
  input hit,
  output logic ld_data_addr,
  output logic ld_status,
  output logic rdata_o_sel,
  output logic addr_o_sel
);

enum int unsigned {
  idle,           // There is nothing in buffer or its allready been written back
  buffer_loaded,  // There is data in buffer and needs to be written back
  empty_buffer,   // Buffer is being written back to memory
  read_miss_wb,   // Buffer needs to be written back but there is a read request first
  read_miss       // Read request needs to be passed through
} state, next_state;

function void set_defaults();
  ewb_resp_o = 1'b0;
  ewb_read_o = 1'b0;
  ewb_write_o = 1'b0;
	ld_data_addr = 1'b0;
  ld_status = 1'b0;
  rdata_o_sel = 1'b0;
  addr_o_sel = 1'b0;
endfunction

// State outputs
always_comb
begin
	set_defaults();
	unique case (state)
		idle: begin
      if (ewb_write_i) begin  // 1 cycle buffer load resp
        ld_data_addr = 1'b1;
        ld_status = 1'b1;
        ewb_resp_o = 1'b1;
      end else if (ewb_read_i && hit) begin   // 1 cycle buffer read hit resp
        rdata_o_sel = 1'b1;
        ewb_resp_o = 1'b1;
      end
		end

    buffer_loaded: begin
      if (ewb_read_i && hit) begin
        rdata_o_sel = 1'b1;
        ewb_resp_o = 1'b1;
      end
    end
    
    empty_buffer: begin
      addr_o_sel = 1'b1;
      ewb_write_o = 1'b1;
    end
    
    read_miss_wb: begin
      addr_o_sel = 1'b0;
      rdata_o_sel = 1'b0;
      ewb_read_o = 1'b1;
      if (ewb_resp_i) begin
        ewb_resp_o = 1'b1;
      end
    end

    read_miss: begin
      addr_o_sel = 1'b0;
      rdata_o_sel = 1'b0;
      ewb_read_o = 1'b1;
      if (ewb_resp_i) begin
        ewb_resp_o = 1'b1;
      end
    end
		
		default: begin
			set_defaults();
		end
	endcase
end

// Next state logic
always_comb begin
	if (rst) begin
    next_state = idle;
  end else begin
    unique case(state)
      idle: begin
        if (ewb_write_i) begin    // New data loaded into buffer (idle), then try to write back (buffer_loaded)
          next_state = buffer_loaded;
        end else if (ewb_read_i && hit) begin   // Serve read hit (idle)
          next_state = idle;
        end else if (ewb_read_i && !hit) begin  // Serve read miss pass through (read_miss)
          next_state = read_miss;
        end else begin
          next_state = idle;
        end
		  end
    
      buffer_loaded: begin      // (1) write - buffer is loaded
        if (ewb_write_i) begin  // (2) write - need to write back current buffer (empty_buffer), then load new data (idle)
          next_state = empty_buffer;
        end else if (ewb_read_i && hit) begin   // (2) read hit - serve buffer read hit (buffer_loaded) first then write back (empty_buffer)
          next_state = empty_buffer;
        end else if (ewb_read_i && !hit) begin  // (2) read miss - serve pass through read (read_miss_wb) first then write back (empty_buffer)
          next_state = read_miss_wb;
        end else begin
          next_state = empty_buffer;
        end
      end

      empty_buffer: begin
        if (ewb_resp_i) begin
          next_state = idle;
        end else begin
          next_state = empty_buffer;
        end
      end
      
      read_miss_wb: begin
        if (ewb_resp_i) begin
          next_state = empty_buffer;
        end else begin
          next_state = read_miss_wb;
        end
      end

      read_miss: begin
        if (ewb_resp_i) begin
          next_state = idle;
        end else begin
          next_state = read_miss;
        end
      end

      default: begin
        next_state = idle;
      end
    endcase
  end
end

// State transition
always_ff @(posedge clk) begin
	 state <= next_state;
end

endmodule : ewb_control
