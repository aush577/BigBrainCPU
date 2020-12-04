module prefetcher(
    input clk,
    input rst,
    input logic prefetch_start,
    input logic [31:0] cacheline_address,
    input logic cache_way,

    output logic [255:0] prefetch_rdata,
    output logic prefetch_ready,
    output logic [31:0] pf_cline_address,
    output logic pf_cache_way,

    output logic pf_read,
    output logic [31:0] pf_address,
    input logic [255:0] pf_rdata,
    input logic pf_resp
);
    //goal is simple: we get address from memory, 
    //transfer the data to the arbiter ports, 
    //then once we get the output, transfer it back to the cache
    logic prefetch_busy;
    always_ff @ (posedge clk) begin
        prefetch_ready <= '0;
        if (rst) begin
            pf_read <= '0;
            prefetch_ready <= '0;
            prefetch_rdata <= '0;
            pf_address <= '0;
            pf_cline_address <= '0;
            prefetch_busy = '0;
        end
        else if (pf_resp) begin
            prefetch_ready <= '1;
            pf_read <= '0;
            prefetch_rdata <= pf_rdata;
            prefetch_busy <= '0;
        end
        //In beginning: set the outputs
        else if (prefetch_start && ~prefetch_busy) begin
            pf_address <= cacheline_address + 32'd32;
            pf_cline_address <= cacheline_address + 32'd32;
            pf_read <= '1;
            pf_cache_way <= cache_way;
            prefetch_busy <= '1;
        end
    end
endmodule: prefetcher
