module mp4_tb;
`timescale 1ns/10ps

/********************* Do not touch for proper compilation *******************/
// Instantiate Interfaces
tb_itf itf();
rvfi_itf rvfi(itf.clk, itf.rst);

// Instantiate Testbench
source_tb tb(
    .magic_mem_itf(itf),
    .mem_itf(itf),
    .sm_itf(itf),
    .tb_itf(itf),
    .rvfi(rvfi)
);

// For local simulation, add signal for Modelsim to display by default
// Note that this signal does nothing and is not used for anything
// bit f;

/****************************** End do not touch *****************************/

// Waves to show at start
logic clk;
logic rst; 
assign clk = itf.clk;
assign rst = itf.rst;

/************************ Signals necessary for monitor **********************/
// This section not required until CP2

// Set high when a valid instruction is modifying regfile or PC
// assign rvfi.commit = 0;
assign rvfi.commit = ~dut.dp.dcache_stall & ~dut.dp.icache_stall & dut.dp.memwb_ireg_out.opcode != 0;

// assign rvfi.halt = 1'b0;   // Set high when you detect an infinite loop
assign rvfi.halt = rvfi.pc_rdata == rvfi.pc_wdata;

initial rvfi.order = 0;
always @(posedge itf.clk iff rvfi.commit) rvfi.order <= rvfi.order + 1; // Modify for OoO


// Carrying forward RVFI signals from previous stages
logic [31:0] rs1_data_delay1;
logic [31:0] rs1_data_delay2;

logic [31:0] rs2_data_delay1;

logic [31:0] dcache_address_delay;
logic [3:0] rmask_delay;
logic [3:0] wmask_delay;
logic [31:0] mem_wdata_delay;

always_ff @(posedge clk) begin
    if (~dut.dp.dcache_stall & ~dut.dp.icache_stall) begin
        rs1_data_delay1 <= dut.dp.forwardmux1_out;
        rs1_data_delay2 <= rs1_data_delay1; 

        rs2_data_delay1 <= dut.dp.mem_forwardmux2_out;

        dcache_address_delay <= dut.dp.dcache_address;

        rmask_delay <= (dut.dp.dcache_read ? dut.dcache_mbe : '0);
        wmask_delay <= (dut.dp.dcache_write ? dut.dcache_mbe : '0);

        mem_wdata_delay <= dut.dp.dcache_wdata;
    end
end

/*
The following signals need to be set:
Instruction and trap:
    rvfi.inst
    rvfi.trap

Regfile:
    rvfi.rs1_addr
    rvfi.rs2_add
    rvfi.rs1_rdata
    rvfi.rs2_rdata
    rvfi.load_regfile
    rvfi.rd_addr
    rvfi.rd_wdata

PC:
    rvfi.pc_rdata
    rvfi.pc_wdata

Memory:
    rvfi.mem_addr
    rvfi.mem_rmask
    rvfi.mem_wmask
    rvfi.mem_rdata
    rvfi.mem_wdata

Please refer to rvfi_itf.sv for more information.
*/

assign rvfi.inst         = {dut.dp.memwb_ireg_out.funct7, dut.dp.memwb_ireg_out.rs2, dut.dp.memwb_ireg_out.rs1, 
                           dut.dp.memwb_ireg_out.funct3, dut.dp.memwb_ireg_out.rd, dut.dp.memwb_ireg_out.opcode};
assign rvfi.trap         = 1'b0;
assign rvfi.rs1_addr     = dut.dp.memwb_ireg_out.rs1;
assign rvfi.rs2_addr     = dut.dp.memwb_ireg_out.rs2;
assign rvfi.rs1_rdata    = rs1_data_delay2;
assign rvfi.rs2_rdata    = rs2_data_delay1;
assign rvfi.load_regfile = dut.dp.memwb_ctrlreg_out.regfile_ld;
assign rvfi.rd_addr      = dut.dp.memwb_ireg_out.rd;
assign rvfi.rd_wdata     = (dut.dp.memwb_ireg_out.rd == '0) ? 0 : dut.dp.regfilemux_out;
assign rvfi.pc_rdata     = dut.dp.memwb_pcreg_out;
assign rvfi.pc_wdata     = (dut.dp.memwb_brreg_out) ? {dut.dp.memwb_alureg_out[31:2], 2'b00} : dut.dp.memwb_pcreg_out + 4;

assign rvfi.mem_addr     = dcache_address_delay;
assign rvfi.mem_rmask    = rmask_delay;
assign rvfi.mem_wmask    = wmask_delay;
assign rvfi.mem_rdata    = dut.dp.memwb_memdatareg_out;
assign rvfi.mem_wdata    = mem_wdata_delay;

/**************************** End RVFIMON signals ****************************/

/********************* Assign Shadow Memory Signals Here *********************/
// This section not required until CP2
/*
The following signals need to be set:
icache signals:
    itf.inst_read
    itf.inst_addr
    itf.inst_resp
    itf.inst_rdata

dcache signals:
    itf.data_read
    itf.data_write
    itf.data_mbe
    itf.data_addr
    itf.data_wdata
    itf.data_resp
    itf.data_rdata

Please refer to tb_itf.sv for more information.
*/

assign itf.inst_read =  dut.dp.icache_read;
assign itf.inst_addr =  dut.dp.icache_address;
assign itf.inst_resp =  dut.dp.icache_resp;
assign itf.inst_rdata = dut.dp.icache_rdata;

assign itf.data_read =  dut.dp.dcache_read;
assign itf.data_write = dut.dp.dcache_write;
assign itf.data_mbe =   dut.dp.dcache_mbe;
assign itf.data_addr =  dut.dp.dcache_address;
assign itf.data_wdata = dut.dp.dcache_wdata;
assign itf.data_resp =  dut.dp.dcache_resp;
assign itf.data_rdata = dut.dp.dcache_rdata;

/*********************** End Shadow Memory Assignments ***********************/

// Set this to the proper value
assign itf.registers = dut.dp.rf.data;  //'{default: '0};

/*********************** Instantiate your design here ************************/
/*
The following signals need to be connected to your top level:
Clock and reset signals:
    itf.clk
    itf.rst

Burst Memory Ports:
    itf.mem_read
    itf.mem_write
    itf.mem_wdata
    itf.mem_rdata
    itf.mem_addr
    itf.mem_resp

Please refer to tb_itf.sv for more information.
*/

mp4 dut(
    .clk(itf.clk),
    .rst(itf.rst),

    // .icache_resp(itf.inst_resp),
    // .icache_rdata(itf.inst_rdata),
    // .icache_address(itf.inst_addr),
    // .icache_read(itf.inst_read),

    // .dcache_resp(itf.data_resp),
    // .dcache_rdata(itf.data_rdata),
    // .dcache_address(itf.data_addr),
    // .dcache_read(itf.data_read),
    // .dcache_write(itf.data_write),
    // .dcache_wdata(itf.data_wdata),
    // .dcache_mbe(itf.data_mbe)

    .mem_resp(itf.mem_resp),
    .mem_rdata(itf.mem_rdata),
    .mem_read(itf.mem_read),
    .mem_write(itf.mem_write),
    .mem_address(itf.mem_addr),
    .mem_wdata(itf.mem_wdata)
);

/***************************** End Instantiation *****************************/


/********** Counter Stuff **********/
int tourn_br_pred_correct = 0;
int tourn_br_pred_incorrect = 0;
int total_br = 0;
int num_flushes = 0;

//buffers for counters
logic tournament_pred_delay1;
logic tournament_pred_delay2;

always_ff @(posedge clk) begin
    if (~dut.dp.dcache_stall & ~dut.dp.icache_stall) begin
        tournament_pred_delay1 <= dut.dp.tournament.pred_br;
        tournament_pred_delay2 <= tournament_pred_delay1;
    end
end

always_ff @(posedge clk) begin
    if ((dut.dp.idex_ireg_out.opcode == 7'b1100011) || (dut.dp.idex_ireg_out.opcode == 7'b1101111)) begin //|| (dut.dp.idex_ireg_out.opcode == 7'b1100111)) begin
        total_br += 1;
        if (dut.dp.br_en == tournament_pred_delay2) begin
            tourn_br_pred_correct += 1;
        end
        if (dut.dp.br_en != tournament_pred_delay2) begin
            tourn_br_pred_incorrect += 1;
        end
    end
    
    if (dut.dp.flush_sig) begin
        num_flushes += 1;
    end
end


endmodule
