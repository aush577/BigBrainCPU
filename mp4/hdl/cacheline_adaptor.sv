module cacheline_adaptor
(
    input clk,
    input reset_n,

    // Port to LLC (Lowest Level Cache)
    input logic [255:0] line_i,
    output logic [255:0] line_o,
    input logic [31:0] address_i,
    input read_i,
    input write_i,
    output logic resp_o,

    // Port to memory
    input logic [63:0] burst_i,
    output logic [63:0] burst_o,
    output logic [31:0] address_o,
    output logic read_o,
    output logic write_o,
    input resp_i
);
//We need to support two modes: read and write
//When read signal given, clock cycle must be read

logic read_state, read_finished;
logic write_state, write_finished;
logic read_mem, write_mem;
logic [1:0] control_bits; //to figure out at what bit we need to start the value


always_comb begin
    if (read_mem == 1'b1) begin
        read_o = 1'b1;
    end
    else begin
        read_o = 1'b0;
    end

    if (write_mem == 1'b1) begin
        write_o = 1'b1;
    end
    else begin
        write_o = 1'b0;
    end   
end

always_ff @ (posedge clk) begin
    //Reset state
    if (reset_n == 1'b0) begin
        read_mem <= 1'b0;
        write_mem <= 1'b0;
        resp_o <= 1'b0;
        read_finished <= 1'b0;
        read_state <= 1'b0;
        write_state <= 1'b0;
        write_finished <= 1'b0;
    end

    //Start reading
    if (read_i == 1'b1) begin
        read_mem <= 1'b1;
        address_o <= address_i;
        control_bits <= 2'b00;
        write_mem <= 1'b0;
        read_finished <= 1'b0;
        read_state <= 1'b1;
    end

    //Start writing
    if (write_i == 1'b1) begin
        write_mem <= 1'b1;
        read_mem <= 1'b0;
        address_o <= address_i;
        control_bits <= 2'b00;
        burst_o <= line_i [63:0]; //Set initial burst already since we already start writing by now
        write_state <= 1'b1;
        write_finished <= 1'b0;
    end
    //an extra delay to hopefully get the right burst value
    // if (load_from_cache == 1'b1) begin
    //     load_from_cache <= 1'b0;
    //     write_state <= 1'b1;
    //     write_finished <= 1'b0;
    // end


    if (resp_i == 1'b1) begin
        if(read_state == 1'b1) begin
            if(control_bits == 2'b00) begin
                line_o [63:0] <= burst_i;
                resp_o <= 1'b0;
            end
            if(control_bits == 2'b01) begin
                line_o [127:64] <= burst_i;
                resp_o <= 1'b0;
            end
            if(control_bits == 2'b10) begin
                line_o [191:128] <= burst_i;
                resp_o <= 1'b0;
            end
            if(control_bits == 2'b11) begin
                line_o [255:192] <= burst_i;
                read_finished <= 1'b1;
                read_mem <= 1'b0;
                resp_o <= 1'b0;
            end
            control_bits <= control_bits + 2'b01;
        end

        if (write_state == 1'b1) begin
            //we are loading the value to be loaded next
            if(control_bits == 2'b00) begin
                burst_o <= line_i [127:64]; 
            end
            if(control_bits == 2'b01) begin
                burst_o <= line_i [191:128];
            end
            if(control_bits == 2'b10) begin
                burst_o <= line_i [255:192];
            end
            if(control_bits == 2'b11) begin
                write_finished <= 1'b1;
                write_mem <= 1'b0;
            end
            control_bits <= control_bits + 2'b01;
        end
    end

    if (read_finished) begin
        resp_o <= 1'b1;
        read_mem <= 1'b0;
        read_finished <= 1'b0;
        write_mem <= 1'b0;
        read_state <= 1'b0;
    end

    if (write_finished) begin
        resp_o <= 1'b1;
        read_mem <= 1'b0;
        write_finished <= 1'b0;
        write_mem <= 1'b0;
        write_state <= 1'b0;
    end

    if (resp_o == 1'b1) begin
        resp_o <= 1'b0;
        read_mem <= 1'b0;
        write_mem <= 1'b0;
    end

end
endmodule : cacheline_adaptor
