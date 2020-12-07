module stack #(parameter RAS_INDEX = 3)
(
  input clk,
  input rst,
  input push,
  input pop,
  input [31:0] addr_in,
  output logic [31:0] addr_out,
  output logic empty
);

logic [31:0] target_addr [2**RAS_INDEX];
logic [RAS_INDEX:0] stack_ptr;    // ptr is one bit bigger to tell if stack is full

logic full;
assign full = stack_ptr[RAS_INDEX];
assign empty = (stack_ptr == 'b0);

always_comb begin
  if (~empty) begin
    addr_out = target_addr[stack_ptr-1];
  end else begin
    addr_out = 32'hDEAD;
  end
end

always @(posedge clk) begin
  if (rst) begin
    for (int i=0; i < 2**RAS_INDEX; ++i) begin
      target_addr[i] <= '0;
    end
    // addr_out <= '0;
    stack_ptr <= 'b0;
  end
  else begin
    if (pop & ~empty) begin
      stack_ptr <= stack_ptr - 1'b1;
      // addr_out <= target_addr[stack_ptr-1];
    end
    else if (push & ~full) begin    // TODO? if overfilled, circular shift or hold current
      target_addr[stack_ptr] <= addr_in;
      stack_ptr <= stack_ptr + 1'b1;
    end
    else if (push & pop & ~empty) begin
      target_addr[stack_ptr-1] <= addr_in;
    end
  end
end
  
endmodule : stack
