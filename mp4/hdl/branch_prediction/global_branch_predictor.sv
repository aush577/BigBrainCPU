module branch_history_reg #(parameter int width = 8)
  input clk,
  input check_predictor,
  input new_branch_val,
  output [width-1:0] bhr_out
);

always_ff @(posedge clk) begin
  if (check_predictor) begin
    bhr_out = bhr_out << 1;
    bhr_out[0] = new_branch_val; 
  end
end

endmodule : branch_history_reg

module global_branch_predictor #(parameter pc_width=3, parameter bhr_width=8) (
  input clk,
  input [(pc_width-1):0] pcreg_out,
);

pattern_history_table pht #(.index(pc_width + bhr_width ))
branch_history_reg bhr #(.width(bhr_width))


endmodule : global_branch_predictor



