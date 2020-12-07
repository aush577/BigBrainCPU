module new_data_array #(
  parameter s_offset = 5,
  parameter s_index = 3
)
(
  clk,
  rst,
  read,
  write_en,
  rindex,
  windex,
  datain,
  dataout
);

localparam s_mask   = 2**s_offset;
localparam s_line   = 8*s_mask;
localparam num_sets = 2**s_index;

input clk;
input rst;
input read;
input [s_mask-1:0] write_en;
input [s_index-1:0] rindex;
input [s_index-1:0] windex;
input [s_line-1:0] datain;
output logic [s_line-1:0] dataout;

logic [s_line-1:0] data [num_sets-1:0] /* synthesis ramstyle = "logic" */;
logic [s_line-1:0] _dataout;
assign dataout = _dataout;

always_comb begin
  // for (int i = 0; i < 32; i++) begin
  //   _dataout[8*i +: 8] = (write_en[i] & (rindex == windex)) ? datain[8*i +: 8] : data[rindex][8*i +: 8];
  // end
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
    for (int i = 0; i < s_mask; i++) begin
      data[windex][8*i +: 8] <= write_en[i] ? datain[8*i +: 8] : data[windex][8*i +: 8];
    end
  end
end

endmodule : new_data_array


// module new_data_array  #(
//   parameter s_offset = 5,
//   parameter s_index = 3
// )
// (
//   input clk,
//   input read,
//   input logic [(2**s_offset)-1:0] write_en,
//   input logic [s_index-1:0] rindex,
//   input logic [s_index-1:0] windex,
//   input logic [255:0] datain,
//   output logic [255:0] dataout
// );

// logic [255:0] data [2**s_index] = '{default: '0};

// always_comb begin
//   for (int i = 0; i < (2**s_offset); i++) begin
//       dataout[8*i +: 8] = (write_en[i] & (rindex == windex)) ? datain[8*i +: 8] : data[rindex][8*i +: 8];
//   end
// end

// always_ff @(posedge clk) begin
//     for (int i = 0; i < 2**s_offset; i++) begin
// 		  data[windex][8*i +: 8] <= write_en[i] ? datain[8*i +: 8] : data[windex][8*i +: 8];
//     end
// end

// endmodule : new_data_array
