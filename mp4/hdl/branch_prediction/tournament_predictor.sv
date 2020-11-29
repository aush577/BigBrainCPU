module tournament_predictor 
#(parameter pc_idx_start=6, parameter idx_width=4)
(
  input clk,
  input rst,
  input [31:0] pc,
  input pred_ld,
  input cpu_br_en,
  // input [idx_width-1:0] meta_idx,
  
  output pred_br
);

logic global_pred_br;
logic local_pred_br;

global_branch_predictor #(.pc_idx_start(pc_idx_start), .pc_idx_width(idx_width), .bhr_width(idx_width)) 
global_pred (
  .clk(clk),
  .rst(rst),
  .glob_pred_ld(pred_ld),
  .cpu_br_en(cpu_br_en),
  .pc(pc),
  .pred_br_out(global_pred_br)
);

pattern_history_table #(.index(idx_width)) 
local_pred (
  .clk(clk),
  .rst(rst),
  .pht_index(pc[pc_idx_start : pc_idx_start-idx_width+1]),
  .cpu_br_en(cpu_br_en),
  .pht_ld(pred_ld),
  .predicted_br(local_pred_br)
);

typedef enum bit [1:0]
{
  use_local1 = 2'b00,
	use_local2 = 2'b01,
  use_global1 = 2'b10,
  use_global2 = 2'b11
} taken_predictor;

taken_predictor meta_predictor;

assign pred_br = (meta_predictor[1]) ? global_pred_br : local_pred_br;

always_ff @(posedge clk) begin  
  if (rst) begin
    meta_predictor = use_local2;
  end else begin
    
    if (pred_ld) begin
      unique case ({local_pred_br, global_pred_br})
        2'b00: begin
          // Both predicted not taken - Do nothing
        end

        2'b01: begin
          if (cpu_br_en && meta_predictor < use_global2)  // Global correct taken
            meta_predictor <= meta_predictor + 1;
          else if (~cpu_br_en && meta_predictor > use_local1)   // Local correct not taken
            meta_predictor <= meta_predictor - 1;
        end
        
        2'b10: begin
          if (cpu_br_en && meta_predictor > use_local1)  // Local correct taken
            meta_predictor <= meta_predictor - 1;
          else if (~cpu_br_en && meta_predictor < use_global2)   // Global correct not taken
            meta_predictor <= meta_predictor + 1;
        end

        2'b11: begin 
           //Both predicted taken - Do nothing
        end

        default: begin
          meta_predictor <= meta_predictor;
        end
      endcase
    end
  end

end


endmodule : tournament_predictor
