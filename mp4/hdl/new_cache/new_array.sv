module new_array #(
  parameter s_index = 3,
  parameter width = 1
)
(
  clk,
  rst,
  read,
  load,
  rindex,
  windex,
  datain,
  dataout
);

localparam num_sets = 2**s_index;

input clk;
input rst;
input read;
input load;
input [s_index-1:0] rindex;
input [s_index-1:0] windex;
input [width-1:0] datain;
output logic [width-1:0] dataout;

logic [width-1:0] data [num_sets-1:0] /* synthesis ramstyle = "logic" */;
logic [width-1:0] _dataout;
assign dataout = _dataout;

always_comb begin
  // _dataout = (load & (rindex == windex)) ? datain : data[rindex];
  _dataout = data[rindex];
end

always_ff @(posedge clk)
begin
  if (rst) begin
    for (int i = 0; i < num_sets; ++i) begin
      data[i] <= '0;
    end
  end
  else begin
    if (load) begin
      data[windex] <= datain;
    end
  end
end

endmodule : new_array