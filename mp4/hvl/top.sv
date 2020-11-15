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

assign rvfi.commit = 0; // Set high when a valid instruction is modifying regfile or PC

logic halt;
logic halt_temp;
logic halt_temp2;
assign halt = (dut.dp.pcmux_out == dut.dp.idex_pcreg_out);
always_ff @(posedge clk) begin
    halt_temp <= halt;
    halt_temp2 <= halt_temp;
end
assign rvfi.halt = halt_temp2;
// assign rvfi.halt = (dut.dp.pcmux_out == dut.dp.exmem_pcreg_out);   // Set high when you detect an infinite loop

initial rvfi.order = 0;
always @(posedge itf.clk iff rvfi.commit) rvfi.order <= rvfi.order + 1; // Modify for OoO

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

    .icache_resp(itf.inst_resp),
    .icache_rdata(itf.inst_rdata),
    .icache_address(itf.inst_addr),
    .icache_read(itf.inst_read),

    .dcache_resp(itf.data_resp),
    .dcache_rdata(itf.data_rdata),
    .dcache_address(itf.data_addr),
    .dcache_read(itf.data_read),
    .dcache_write(itf.data_write),
    .dcache_wdata(itf.data_wdata),
    .dcache_mbe(itf.data_mbe)
);

/***************************** End Instantiation *****************************/

endmodule