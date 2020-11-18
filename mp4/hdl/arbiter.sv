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
  /*else begin
    unique case (state)

      do_nothing: begin
        unique casex({arb_icache_read, arb_dcache_read, arb_dcache_write, arb_mem_resp})
          4'b100X: next_state = icache_read;
          4'b010X: next_state = dcache_read;
          4'b001X: next_state = dcache_write;
          default: next_state = do_nothing;
        endcase
      end

      dcache_read: begin
        unique casex({arb_icache_read, arb_dcache_read, arb_dcache_write, arb_mem_resp})
          4'bX1X0: next_state = dcache_read;
          4'bXXX1: next_state = do_nothing;
          default: next_state = do_nothing;
        endcase
      end

      dcache_write: begin
        unique casex({arb_icache_read, arb_dcache_read, arb_dcache_write, arb_mem_resp}) 
          4'bXX10: next_state = dcache_write;
          4'bXXX1: next_state = do_nothing;
          default: next_state = do_nothing;
        endcase
      end

      icache_read: begin
        unique casex({arb_icache_read, arb_dcache_read, arb_dcache_write, arb_mem_resp})
          4'b1XX0: next_state = icache_read;
          4'bXXX1: next_state = do_nothing;
          default: next_state = do_nothing;
        endcase
      end
      default: next_state = do_nothing;
    endcase
  end
  */
end

always_ff @(posedge clk) begin 
  if (rst) begin
    state <= do_nothing;
  end
  else begin
    state <= next_state;
  end
end

endmodule : arbiter
