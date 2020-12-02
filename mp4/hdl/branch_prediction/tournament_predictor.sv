module tournament_predictor 
#(parameter pc_idx_start=6, parameter idx_width=4)
(
  input clk,
  input rst,
  input stall,
  input [31:0] read_pc,
  input [31:0] write_pc,
  input pred_ld,
  input cpu_br_en,
  input [6:0] read_opcode,
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
  .read_pc(read_pc),
  .write_pc(write_pc),
  .read_opcode(read_opcode),
  .predicted_br(global_pred_br)
);

pattern_history_table #(.index(idx_width)) 
local_pred (
  .clk(clk),
  .rst(rst),
  .pht_rindex(read_pc[pc_idx_start : pc_idx_start-idx_width+1]),
  .pht_windex(write_pc[pc_idx_start : pc_idx_start-idx_width+1]),
  .cpu_br_en(cpu_br_en),
  .read_opcode(read_opcode),
  .pht_ld(pred_ld),
  .predicted_br(local_pred_br)
);

typedef enum bit [1:0]
{
  strong_local = 2'b00,
	weak_local = 2'b01,
  weak_global = 2'b10,
  strong_global = 2'b11
} taken_predictor;

taken_predictor meta_predictor;

assign pred_br = (meta_predictor[1]) ? global_pred_br : local_pred_br;

// Buffering br predicitons from IF to EX for loading tournament in EX
logic local_pred_br_buffer1;
logic local_pred_br_buffer2;
logic global_pred_br_buffer1;
logic global_pred_br_buffer2;

always_ff @(posedge clk) begin
  if (~stall) begin
    local_pred_br_buffer1 <= local_pred_br;
    local_pred_br_buffer2 <= local_pred_br_buffer1;
    
    global_pred_br_buffer1 <= global_pred_br;
    global_pred_br_buffer2 <= global_pred_br_buffer1;
  end
end

always_ff @(posedge clk) begin  
  if (rst) begin
    meta_predictor = weak_local;
  end else begin
    
    if (pred_ld) begin
      unique case ({local_pred_br_buffer2, global_pred_br_buffer2})
        2'b00: begin
          // Both predicted not taken - Do nothing
        end

        2'b01: begin
          if (cpu_br_en && meta_predictor < strong_global)  // Global correct taken
            meta_predictor <= taken_predictor'(meta_predictor + 1);
          else if (~cpu_br_en && meta_predictor > strong_local)   // Local correct not taken
            meta_predictor <= taken_predictor'(meta_predictor - 1);
        end
        
        2'b10: begin
          if (cpu_br_en && meta_predictor > strong_local)  // Local correct taken
            meta_predictor <=  taken_predictor'(meta_predictor - 1);
          else if (~cpu_br_en && meta_predictor < strong_global)   // Global correct not taken
            meta_predictor <=  taken_predictor'(meta_predictor + 1);
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
