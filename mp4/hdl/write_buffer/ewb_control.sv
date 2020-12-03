module ewb_control
(
  input clk,
  input rst,

  // Lower level port
  input ewb_read_i,
  input ewb_write_i,
  output ewb_resp_o,

  // Higher level port
  input ewb_resp_i,
  output ewb_read_o,
  output ewb_write_o,

  // Datapath
  input hit,
  output logic ld_data_addr,
  output logic ld_status,
  output logic rdata_o_sel,
  output logic status_reg_in
);


enum int unsigned {
  idle,
  empty_buffer,
  read_hit,
  read_miss
} state, next_state;

function void set_defaults();
	ld_data_addr = 1'b0;
  ld_status = 1'b0;
  rdata_o_sel = 1'b0;
  status_reg_in = 1'b0;
endfunction

// State outputs
always_comb
begin
	set_defaults();
	unique case (state)
		idle: begin
      if (ewb_write_i) begin  // 1 cycle write resp
        ld_data_addr = 1'b1;
        status_reg_in = 1'b1;
        ld_status = 1'b1;
        ewb_resp_o = 1'b1;
      end else if (ewb_read_i && hit) begin   // 1 cycle read hit resp
        rdata_o_sel = 1'b1;
        ewb_resp_o = 1'b1;
      end
		end
    
    empty_buffer: begin
      ewb_write_o = 1'b1;
    end

    read_hit: begin

    end
    
    read_miss: begin

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
        if (ewb_write_i) begin
          next_state = empty_buffer;
        end else if (ewb_read_i && hit) begin
          next_state = read_hit;
        end else if (ewb_read_i && !hit) begin
          next_state = read_miss;
        end else begin
          next_state = idle;
        end
		  end
    
      empty_buffer: begin
        if (ewb_resp_i) begin
          next_state = idle;
        end else begin
          next_state = empty_buffer;
        end
      end

      read_hit: begin

      end
      
      read_miss: begin

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
