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


// module new_array #(
//   parameter s_index = 3,
//   parameter width = 1
// )
// (
//   input clk,
//   input read,
//   input logic load,
//   input logic [s_index-1:0] rindex,
//   input logic [s_index-1:0] windex,
//   input logic [width-1:0] datain,
//   output logic [width-1:0] dataout
// );

// localparam num_sets = 2**s_index;

// //logic [width-1:0] data [2:0] = '{default: '0};
// logic [width-1:0] data [num_sets];
// initial begin
//   if (num_sets == 8) begin
//     data[0] = 0;
//     data[1] = 0;
//     data[2] = 0;
//     data[3] = 0;
//     data[4] = 0;
//     data[5] = 0;
//     data[6] = 0;
//     data[7] = 0;
//   end else begin
//     data[0] = 0;
//     data[1] = 0;
//     data[2] = 0;
//     data[3] = 0;
//     data[4] = 0;
//     data[5] = 0;
//     data[6] = 0;
//     data[7] = 0;
//     data[8] = 0;
//     data[9] = 0;
//     data[10] = 0;
//     data[11] = 0;
//     data[12] = 0;
//     data[13] = 0;
//     data[14] = 0;
//     data[15] = 0;
//   end
// end

// always_comb begin
//   dataout = (load  & (rindex == windex)) ? datain : data[rindex];
// end

// always_ff @(posedge clk)
// begin
//     if(load)
//         data[windex] <= datain;
// end

// endmodule : new_array
