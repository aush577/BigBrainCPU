module ewb_control
(
  input clk,
  input rst,

  // Lower level port
  input ewb_read_i
  input ewb_write_i,
  output ewb_resp_o,

  // Higher level port
  input ewb_resp_i,
  output ewb_read_o,
  output ewb_write_o,

  // Datapath
  output logic ld_data_addr,
  output logic ld_status
);


enum int unsigned {
  idle
} state, next_state;

function void set_defaults();
	ld_data_addr = 1'b0;
  ld_status = 1'b0;
endfunction

// State outputs
always_comb
begin
	set_defaults();
	unique case (state)
		idle: begin
			;
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
        ;
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
