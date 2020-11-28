module tournament_predictor 
#(parameter pc_idx_start=6, parameter pc_idx_width=4, parameter bhr_width=4)
(
  input clk,
  input rst,
  input pc,
  input pred_ld,
  input br_en,
  input meta_idx,
  
  output pred_br
);

logic global_pred_br;
logic local_pred_br;

global_branch_predictor #(.pc_idx_start(pc_idx_start), .pc_idx_width(pc_idx_width), .bhr_width(bhr_width)) 
global (
  .clk(clk),
  .rst(rst),
  .glob_pred_ld(pred_ld),
  .cpu_br_en(br_en),
  .pc(pc),
  .pred_br_out(global_pred_br)
);

pattern_history_table #(.index(pc_idx_width)) 
local (
  .clk(clk),
  .rst(rst),
  .pht_index(pc[pc_idx_start : pc_idx_start-pc_idx_width-1]),
  .cpu_br_en(br_en),
  .pht_ld(pred_ld),
  .global_predicted_branch(local_pred_br)
);

typedef enum bit [1:0]
{
  use_local1 = 2'b00,
	use_local2 = 2'b01,
  use_gloabal1 = 2'b10,
  use_gloabal2 = 2'b11
} taken_predictor;

taken_predictor meta_predictor [(2**pc_idx_width) - 1 : 0];

assign pred_br = meta_predictor[meta_idx][1];

always_ff @(posedge clk) begin  
  if (rst) begin
    for (int i=0; i < (2**pc_idx_width); ++i) begin
      meta_predictor[i] = use_local2;
    end

  end else begin
    if (pred_ld) begin
      if (cpu_br_en & (meta_predictor[meta_idx] < use_gloabal2)) begin
        meta_predictor[meta_idx] <= meta_predictor[meta_idx] + 1;
      end
      else if (~cpu_br_en & (meta_predictor[meta_idx] > use_local1)) begin
        meta_predictor[meta_idx] <= meta_predictor[meta_idx] - 1;
      end
    end
  end

end


endmodule : tournament_predictor
