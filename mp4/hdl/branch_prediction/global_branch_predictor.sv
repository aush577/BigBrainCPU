module branch_history_reg 
#(parameter int width = 4)
(
  input clk,
  input rst,
  input bhr_ld,
  input bhr_in,
  
  output [width-1:0] bhr_out
);

logic [(width-1):0] data;
assign bhr_out = data;

always_ff @(posedge clk) begin
  if (rst) begin
    data <= '0;
  end else begin
    if (bhr_ld) begin
      data <= data << 1;
      data[0] <= bhr_in;
    end else begin
      data <= data;
    end
  end
end

endmodule : branch_history_reg


module global_branch_predictor 
#(parameter pc_idx_start=6, parameter pc_idx_width=4, parameter bhr_width=4) 
(
  input clk,
  input rst,
  input glob_pred_ld,
  input cpu_br_en,
  input [31:0] pc,
  
  output predicted_br
);

logic [(bhr_width-1):0] bhr_out;

pattern_history_table #(.index(pc_idx_width))
pht (
  .clk(clk),
  .rst(rst),
  .pht_index(pc[pc_idx_start : pc_idx_start-pc_idx_width+1] ^ bhr_out),
  .pht_ld(glob_pred_ld),
  .cpu_br_en(cpu_br_en),
  .predicted_br(predicted_br)
);

branch_history_reg #(.width(bhr_width))
bhr (
  .clk(clk),
  .rst(rst),
  .bhr_ld(glob_pred_ld),
  .bhr_in(cpu_br_en),
  .bhr_out(bhr_out)
);

endmodule : global_branch_predictor
