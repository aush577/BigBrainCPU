// Branch Target Buffer
module btb 
#(parameter int BTB_INDEX=4, parameter int BTB_IDX_START=5)
(
  input clk,
  input rst,
  input logic btb_load,
  input logic br_en,
  input logic [31:0] pc_address_if,   // PC address of instruction being fetched
  input logic [31:0] pc_address_ex,   // PC address of branch that was taken
  input logic [31:0] br_address,      // Target address computed from alu_out

  output logic hit,
  output logic [31:0] predicted_pc
);

logic [31:0] data [2**BTB_INDEX] = '{default: '0};
logic pred_br [2**BTB_INDEX] = '{default: '0};
logic [31:0] tag [2**BTB_INDEX] = '{default: '0};

logic prediction_hit;
assign hit = prediction_hit;

logic [BTB_INDEX-1:0] idx_if;
logic [BTB_INDEX-1:0] idx_ex;
assign idx_if = pc_address_if[BTB_IDX_START : BTB_IDX_START-BTB_INDEX+1];
assign idx_ex = pc_address_ex[BTB_IDX_START : BTB_IDX_START-BTB_INDEX+1];

always_comb begin
  // if (btb_load && idx_if == idx_ex) begin   // Write-read pass through
  //   prediction_hit = (pc_address_if == pc_address_ex && br_en == 1'b1);  // Check tag and validity of entry
  //   predicted_pc = (prediction_hit) ? br_address : 32'hDEAD;
  // end else begin
    prediction_hit = (pc_address_if == tag[idx_if] && pred_br[idx_if] == 1'b1);  // Check tag and validity of entry
    predicted_pc = (prediction_hit) ? data[idx_if] : 32'hDEAD;
  // end
end

always_ff @(posedge clk) begin
  if (rst) begin
    for (int i=0; i < (2**BTB_INDEX); ++i) begin
      data[i] <= '0;
      tag[i] <= '0;
      pred_br[i] <= '0;
    end
  end

  else if (btb_load) begin
    data[idx_ex] <= br_address; 
    pred_br[idx_ex] <= br_en;
    tag[idx_ex] <= pc_address_ex;
  end
end

endmodule : btb
