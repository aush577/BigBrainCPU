module pattern_history_table #(parameter int index=4) (
  input clk,
  input [index-1:0] pht_index,
  input curr_state,
  input check_predictor,
  input cpu_br_en,
  input mem_stall,
  output predicted_branch
);


typedef enum bit [1:0]
{
    SNT = 2'b00,
	WNT = 2'b01,
    WT = 2'b10,
    ST = 2'b11
} pht_br_state;

pht_br_state state;
pht_br_state next_state;
pht_br_state pattern_history_table [(2**index) - 1];

always_comb @(posedge clk) begin
  if (check_predictor == 1'b1 && ~mem_stall) begin
    predicted_branch = 1'b0;

    if (rst) begin
      for (int i=0; i < (2**index); i++) 
        pattern_history_table[i] = WNT;
        next_state = WNT;
    end

    unique case (state)
      SNT: begin
        if (cpu_br_en) begin 
          pattern_history_table[pht_index] = WNT;
          next_state = WNT;
        end
        else next_state = SNT;
      end

      WNT: begin
        if (cpu_br_en) begin
          pattern_history_table[pht_index] = WT;
          predicted_branch = 1'b1;
          next_state = WT;
        end
        else next_state = SNT;
      end

      WT: begin
        if (cpu_br_en) begin
          pattern_history_table[pht_index] = ST;
          predicted_branch = 1'b1;
          next_state = ST;
        end
        else next_state = WNT;
      end

      ST: begin
        if (cpu_br_en) begin 
          pattern_history_table[pht_index] = ST;
          predicted_branch = 1'b1;
          next_state = ST;
        end
        else next_state = WT;
      end
    endcase
  end
end

always_ff @(posedge clk) begin
    if (rst) begin
        state <= WNT;
    end
    state <= next_state;
end

endmodule: pattern_history_table