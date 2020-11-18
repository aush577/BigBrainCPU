module arbiter (
    input clk,
    input rst,

    // iCache
    output logic arb_icache_resp,
    output logic [255:0] arb_icache_rdata,
    input logic [31:0] arb_icache_address,
    input logic arb_icache_read,
  
    // dCache
    output logic arb_dcache_resp,
    output logic [255:0] arb_dcache_rdata,
    input logic [31:0] arb_dcache_address,
    input logic arb_dcache_read,
    input logic arb_dcache_write,
    input logic [255:0] arb_dcache_wdata,

    // Cacheline adapter
    input logic arb_mem_resp,
    input logic [255:0] arb_mem_rdata,
    output logic [31:0] arb_mem_address,
    output logic arb_mem_read,
    output logic arb_mem_write,
    output logic [255:0] arb_mem_wdata
);

assign arb_mem_wdata = arb_dcache_wdata;

enum int unsigned {
  do_nothing = 0,
  dcache_read = 1,
  dcache_write = 2,
  icache_read = 3
} state, next_state;

function void set_defaults();
  arb_mem_read = '0;
  arb_mem_write = '0;
  arb_dcache_resp = '0;
  arb_icache_resp = '0;
  arb_icache_rdata = '0;
  arb_dcache_rdata = '0;
  arb_mem_address = '0;
endfunction

always_comb 
begin : state_actions
  set_defaults();
  unique case (state)
    
    do_nothing: begin
    end
    
    dcache_read: begin
      arb_mem_read = 1;
      arb_mem_address = arb_dcache_address;
      arb_dcache_rdata = arb_mem_rdata;
      arb_dcache_resp = arb_mem_resp;
    end
    
    dcache_write: begin
      arb_mem_write = 1;
      arb_mem_address = arb_dcache_address;
      arb_dcache_rdata = arb_mem_rdata;
      arb_dcache_resp = arb_mem_resp;
    end
    
    icache_read: begin
      arb_mem_read = 1;
      arb_mem_address = arb_icache_address;
      arb_icache_rdata = arb_mem_rdata;
      arb_icache_resp = arb_mem_resp;
    end
    default: set_defaults();
  endcase
end

always_comb
begin : next_state_logic

  unique case (state)
    do_nothing: begin
      if (arb_icache_read) begin
        next_state = icache_read;
      end else if (arb_dcache_read) begin
        next_state = dcache_read;
      end else if (arb_dcache_write) begin
        next_state = dcache_write;
      end else begin
        next_state = do_nothing;
      end
    end
    
    dcache_read: begin
      if (arb_mem_resp == 1'b0) begin
        next_state = dcache_read;
      end else begin
        next_state = do_nothing;
      end
    end

    dcache_write: begin
      if (arb_mem_resp == 1'b0) begin
        next_state = dcache_write;
      end else begin
        next_state = do_nothing;
      end
    end

    icache_read: begin
      if (arb_mem_resp == 1'b0) begin
        next_state = icache_read;
      end else begin
        next_state = do_nothing;
      end
    end
  endcase
end

always_ff @(posedge clk) begin 
  if (rst) begin
    state <= do_nothing;
  end
  else begin
    state <= next_state;
  end
end

// Resp logic
// always_ff @(posedge clk) begin
//   arb_icache_resp <= '0;
//   arb_dcache_resp <= '0;
//   if (arb_mem_resp) begin
//     if (state == icache_read) begin
//         arb_icache_resp <= '1;
//     end else if (state == dcache_read || state == dcache_write) begin
//         arb_dcache_resp <= '1;
//     end
//   end
// end

endmodule : arbiter
