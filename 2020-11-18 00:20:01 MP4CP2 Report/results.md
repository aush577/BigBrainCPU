# AG Report Generated 2020-11-18 00:20
This is a report about mp4cp2 generated for BigBrainCPU at 2020-11-18 00:20. The autograder used commit ``f7f90c33015a`` as a starting point. If you have any questions about this report, please contact the TAs on Piazza.
### Quick Results:
 - Compilation: YES
 - Targeted: 0/2 (0.0%)
### Compilation ![Success][success]
You succesfully compiled. Your report is below.
<details>
<summary>Compilation Report</summary>

```
Info: *******************************************************************
Info: Running Quartus Prime Analysis & Synthesis
    Info: Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition
    Info: Copyright (C) 2018  Intel Corporation. All rights reserved.
    Info: Your use of Intel Corporation's design tools, logic functions 
    Info: and other software and tools, and its AMPP partner logic 
    Info: functions, and any output files from any of the foregoing 
    Info: (including device programming or simulation files), and any 
    Info: associated documentation or information are expressly subject 
    Info: to the terms and conditions of the Intel Program License 
    Info: Subscription Agreement, the Intel Quartus Prime License Agreement,
    Info: the Intel FPGA IP License Agreement, or other applicable license
    Info: agreement, including, without limitation, that your use is for
    Info: the sole purpose of programming logic devices manufactured by
    Info: Intel and sold by Intel or its authorized distributors.  Please
    Info: refer to the applicable agreement for further details.
    Info: Processing started: Wed Nov 18 06:19:12 2020
Info: Command: quartus_map mp4 -c mp4
Warning (18236): Number of processors has not been specified which may cause overloading on shared machines.  Set the global assignment NUM_PARALLEL_PROCESSORS in your QSF to an appropriate value for best performance.
Info (20029): Only one processor detected - disabling parallel compilation
Info (12021): Found 1 design units, including 1 entities, in source file hdl/cacheline_adaptor.sv
    Info (12023): Found entity 1: cacheline_adaptor File: /job/student/hdl/cacheline_adaptor.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/arbiter.sv
    Info (12023): Found entity 1: arbiter File: /job/student/hdl/arbiter.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/given_cache/line_adapter.sv
    Info (12023): Found entity 1: line_adapter File: /job/student/hdl/given_cache/line_adapter.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/given_cache/data_array.sv
    Info (12023): Found entity 1: data_array File: /job/student/hdl/given_cache/data_array.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/given_cache/cache_datapath.sv
    Info (12023): Found entity 1: cache_datapath File: /job/student/hdl/given_cache/cache_datapath.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/given_cache/cache_control.sv
    Info (12023): Found entity 1: cache_control File: /job/student/hdl/given_cache/cache_control.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/given_cache/cache.sv
    Info (12023): Found entity 1: cache File: /job/student/hdl/given_cache/cache.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/given_cache/array.sv
    Info (12023): Found entity 1: array File: /job/student/hdl/given_cache/array.sv Line: 2
Info (12021): Found 2 design units, including 2 entities, in source file hdl/forwarding_unit.sv
    Info (12023): Found entity 1: forwarding_unit File: /job/student/hdl/forwarding_unit.sv Line: 4
    Info (12023): Found entity 2: mem_forwarding_unit File: /job/student/hdl/forwarding_unit.sv Line: 76
Info (12021): Found 1 design units, including 0 entities, in source file hdl/types.sv
    Info (12022): Found design unit 1: types (SystemVerilog) File: /job/student/hdl/types.sv Line: 1
Info (12021): Found 1 design units, including 0 entities, in source file hdl/rv32i_types.sv
    Info (12022): Found design unit 1: rv32i_types (SystemVerilog) File: /job/student/hdl/rv32i_types.sv Line: 1
Info (12021): Found 8 design units, including 0 entities, in source file hdl/rv32i_mux_types.sv
    Info (12022): Found design unit 1: pcmux (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 1
    Info (12022): Found design unit 2: marmux (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 8
    Info (12022): Found design unit 3: cmpmux (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 15
    Info (12022): Found design unit 4: alumux (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 22
    Info (12022): Found design unit 5: regfilemux (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 38
    Info (12022): Found design unit 6: forwardmux1 (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 52
    Info (12022): Found design unit 7: forwardmux2 (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 61
    Info (12022): Found design unit 8: mem_forwardmux2 (SystemVerilog) File: /job/student/hdl/rv32i_mux_types.sv Line: 70
Info (12021): Found 1 design units, including 1 entities, in source file hdl/register.sv
    Info (12023): Found entity 1: register File: /job/student/hdl/register.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/regfile.sv
    Info (12023): Found entity 1: regfile File: /job/student/hdl/regfile.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/pc_register.sv
    Info (12023): Found entity 1: pc_register File: /job/student/hdl/pc_register.sv Line: 3
Info (12021): Found 1 design units, including 1 entities, in source file hdl/datapath.sv
    Info (12023): Found entity 1: datapath File: /job/student/hdl/datapath.sv Line: 6
Info (12021): Found 1 design units, including 1 entities, in source file hdl/ctrl_rom.sv
    Info (12023): Found entity 1: ctrl_rom File: /job/student/hdl/ctrl_rom.sv Line: 5
Info (12021): Found 1 design units, including 1 entities, in source file hdl/cmp.sv
    Info (12023): Found entity 1: cmp File: /job/student/hdl/cmp.sv Line: 3
Info (12021): Found 1 design units, including 1 entities, in source file hdl/alu.sv
    Info (12023): Found entity 1: alu File: /job/student/hdl/alu.sv Line: 3
Info (12021): Found 1 design units, including 1 entities, in source file hdl/mp4.sv
    Info (12023): Found entity 1: mp4 File: /job/student/hdl/mp4.sv Line: 1
Info (12127): Elaborating entity "mp4" for the top level hierarchy
Info (12128): Elaborating entity "datapath" for hierarchy "datapath:dp" File: /job/student/hdl/mp4.sv Line: 70
Info (12128): Elaborating entity "pc_register" for hierarchy "datapath:dp|pc_register:pcreg" File: /job/student/hdl/datapath.sv Line: 168
Info (12128): Elaborating entity "regfile" for hierarchy "datapath:dp|regfile:rf" File: /job/student/hdl/datapath.sv Line: 181
Info (12128): Elaborating entity "ctrl_rom" for hierarchy "datapath:dp|ctrl_rom:ctrl_rom" File: /job/student/hdl/datapath.sv Line: 188
Info (12128): Elaborating entity "forwarding_unit" for hierarchy "datapath:dp|forwarding_unit:forw_unit" File: /job/student/hdl/datapath.sv Line: 237
Info (12128): Elaborating entity "cmp" for hierarchy "datapath:dp|cmp:cmp" File: /job/student/hdl/datapath.sv Line: 245
Info (12128): Elaborating entity "alu" for hierarchy "datapath:dp|alu:alu" File: /job/student/hdl/datapath.sv Line: 252
Info (12128): Elaborating entity "mem_forwarding_unit" for hierarchy "datapath:dp|mem_forwarding_unit:mem_forw_unit" File: /job/student/hdl/datapath.sv Line: 266
Info (12128): Elaborating entity "register" for hierarchy "datapath:dp|register:ifid_ireg" File: /job/student/hdl/datapath.sv Line: 377
Info (12128): Elaborating entity "register" for hierarchy "datapath:dp|register:ifid_pcreg" File: /job/student/hdl/datapath.sv Line: 386
Info (12128): Elaborating entity "register" for hierarchy "datapath:dp|register:idex_ctrlreg" File: /job/student/hdl/datapath.sv Line: 433
Info (12128): Elaborating entity "register" for hierarchy "datapath:dp|register:exmem_brreg" File: /job/student/hdl/datapath.sv Line: 490
Info (12128): Elaborating entity "cache" for hierarchy "cache:icache" File: /job/student/hdl/mp4.sv Line: 91
Info (12128): Elaborating entity "cache_control" for hierarchy "cache:icache|cache_control:control" File: /job/student/hdl/given_cache/cache.sv Line: 35
Info (12128): Elaborating entity "cache_datapath" for hierarchy "cache:icache|cache_datapath:datapath" File: /job/student/hdl/given_cache/cache.sv Line: 36
Info (12128): Elaborating entity "data_array" for hierarchy "cache:icache|cache_datapath:datapath|data_array:DM_cache" File: /job/student/hdl/given_cache/cache_datapath.sv Line: 56
Info (12128): Elaborating entity "array" for hierarchy "cache:icache|cache_datapath:datapath|array:tag" File: /job/student/hdl/given_cache/cache_datapath.sv Line: 57
Info (12128): Elaborating entity "array" for hierarchy "cache:icache|cache_datapath:datapath|array:valid" File: /job/student/hdl/given_cache/cache_datapath.sv Line: 58
Info (12128): Elaborating entity "line_adapter" for hierarchy "cache:icache|line_adapter:bus" File: /job/student/hdl/given_cache/cache.sv Line: 46
Info (12128): Elaborating entity "arbiter" for hierarchy "arbiter:arbiter" File: /job/student/hdl/mp4.sv Line: 116
Info (12128): Elaborating entity "cacheline_adaptor" for hierarchy "cacheline_adaptor:cacheline_adaptor" File: /job/student/hdl/mp4.sv Line: 137
Warning (276020): Inferred RAM node "cache:dcache|cache_datapath:datapath|array:tag|data_rtl_0" from synchronous design logic.  Pass-through logic has been added to match the read-during-write behavior of the original design.
Warning (276020): Inferred RAM node "cache:icache|cache_datapath:datapath|array:tag|data_rtl_0" from synchronous design logic.  Pass-through logic has been added to match the read-during-write behavior of the original design.
Info (276014): Found 4 instances of uninferred RAM logic
    Info (276004): RAM logic "cache:dcache|cache_datapath:datapath|array:dirty|data" is uninferred due to inappropriate RAM size File: /job/student/hdl/given_cache/array.sv Line: 13
    Info (276004): RAM logic "cache:dcache|cache_datapath:datapath|array:valid|data" is uninferred due to inappropriate RAM size File: /job/student/hdl/given_cache/array.sv Line: 13
    Info (276004): RAM logic "cache:icache|cache_datapath:datapath|array:dirty|data" is uninferred due to inappropriate RAM size File: /job/student/hdl/given_cache/array.sv Line: 13
    Info (276004): RAM logic "cache:icache|cache_datapath:datapath|array:valid|data" is uninferred due to inappropriate RAM size File: /job/student/hdl/given_cache/array.sv Line: 13
Info (19000): Inferred 2 megafunctions from design logic
    Info (276029): Inferred altsyncram megafunction from the following design logic: "cache:dcache|cache_datapath:datapath|array:tag|data_rtl_0" 
        Info (286033): Parameter OPERATION_MODE set to DUAL_PORT
        Info (286033): Parameter WIDTH_A set to 24
        Info (286033): Parameter WIDTHAD_A set to 3
        Info (286033): Parameter NUMWORDS_A set to 8
        Info (286033): Parameter WIDTH_B set to 24
        Info (286033): Parameter WIDTHAD_B set to 3
        Info (286033): Parameter NUMWORDS_B set to 8
        Info (286033): Parameter ADDRESS_ACLR_A set to NONE
        Info (286033): Parameter OUTDATA_REG_B set to UNREGISTERED
        Info (286033): Parameter ADDRESS_ACLR_B set to NONE
        Info (286033): Parameter OUTDATA_ACLR_B set to NONE
        Info (286033): Parameter ADDRESS_REG_B set to CLOCK0
        Info (286033): Parameter INDATA_ACLR_A set to NONE
        Info (286033): Parameter WRCONTROL_ACLR_A set to NONE
        Info (286033): Parameter INIT_FILE set to db/mp4.ram0_array_32a7bb4d.hdl.mif
    Info (276029): Inferred altsyncram megafunction from the following design logic: "cache:icache|cache_datapath:datapath|array:tag|data_rtl_0" 
        Info (286033): Parameter OPERATION_MODE set to DUAL_PORT
        Info (286033): Parameter WIDTH_A set to 24
        Info (286033): Parameter WIDTHAD_A set to 3
        Info (286033): Parameter NUMWORDS_A set to 8
        Info (286033): Parameter WIDTH_B set to 24
        Info (286033): Parameter WIDTHAD_B set to 3
        Info (286033): Parameter NUMWORDS_B set to 8
        Info (286033): Parameter ADDRESS_ACLR_A set to NONE
        Info (286033): Parameter OUTDATA_REG_B set to UNREGISTERED
        Info (286033): Parameter ADDRESS_ACLR_B set to NONE
        Info (286033): Parameter OUTDATA_ACLR_B set to NONE
        Info (286033): Parameter ADDRESS_REG_B set to CLOCK0
        Info (286033): Parameter INDATA_ACLR_A set to NONE
        Info (286033): Parameter WRCONTROL_ACLR_A set to NONE
        Info (286033): Parameter INIT_FILE set to db/mp4.ram0_array_32a7bb4d.hdl.mif
Info (12130): Elaborated megafunction instantiation "cache:dcache|cache_datapath:datapath|array:tag|altsyncram:data_rtl_0"
Info (12133): Instantiated megafunction "cache:dcache|cache_datapath:datapath|array:tag|altsyncram:data_rtl_0" with the following parameter:
    Info (12134): Parameter "OPERATION_MODE" = "DUAL_PORT"
    Info (12134): Parameter "WIDTH_A" = "24"
    Info (12134): Parameter "WIDTHAD_A" = "3"
    Info (12134): Parameter "NUMWORDS_A" = "8"
    Info (12134): Parameter "WIDTH_B" = "24"
    Info (12134): Parameter "WIDTHAD_B" = "3"
    Info (12134): Parameter "NUMWORDS_B" = "8"
    Info (12134): Parameter "ADDRESS_ACLR_A" = "NONE"
    Info (12134): Parameter "OUTDATA_REG_B" = "UNREGISTERED"
    Info (12134): Parameter "ADDRESS_ACLR_B" = "NONE"
    Info (12134): Parameter "OUTDATA_ACLR_B" = "NONE"
    Info (12134): Parameter "ADDRESS_REG_B" = "CLOCK0"
    Info (12134): Parameter "INDATA_ACLR_A" = "NONE"
    Info (12134): Parameter "WRCONTROL_ACLR_A" = "NONE"
    Info (12134): Parameter "INIT_FILE" = "db/mp4.ram0_array_32a7bb4d.hdl.mif"
Info (12021): Found 1 design units, including 1 entities, in source file db/altsyncram_5km1.tdf
    Info (12023): Found entity 1: altsyncram_5km1 File: /job/student/db/altsyncram_5km1.tdf Line: 27
Warning (13024): Output pins are stuck at VCC or GND
    Warning (13410): Pin "mem_address[0]" is stuck at GND File: /job/student/hdl/mp4.sv Line: 25
    Warning (13410): Pin "mem_address[1]" is stuck at GND File: /job/student/hdl/mp4.sv Line: 25
Info (286030): Timing-Driven Synthesis is running
Info (17049): 94 registers lost all their fanouts during netlist optimizations.
Info (16010): Generating hard_block partition "hard_block:auto_generated_inst"
    Info (16011): Adding 0 node(s), including 0 DDIO, 0 PLL, 0 transceiver and 0 LCELL
Info (21057): Implemented 10114 device resources after synthesis - the final resource count might be different
    Info (21058): Implemented 67 input pins
    Info (21059): Implemented 98 output pins
    Info (21061): Implemented 9901 logic cells
    Info (21064): Implemented 48 RAM segments
Info: Quartus Prime Analysis & Synthesis was successful. 0 errors, 6 warnings
    Info: Peak virtual memory: 1240 megabytes
    Info: Processing ended: Wed Nov 18 06:19:54 2020
    Info: Elapsed time: 00:00:42
    Info: Total CPU time (on all processors): 00:00:40
Info: *******************************************************************
Info: Running Quartus Prime Shell
    Info: Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition
    Info: Copyright (C) 2018  Intel Corporation. All rights reserved.
    Info: Your use of Intel Corporation's design tools, logic functions 
    Info: and other software and tools, and its AMPP partner logic 
    Info: functions, and any output files from any of the foregoing 
    Info: (including device programming or simulation files), and any 
    Info: associated documentation or information are expressly subject 
    Info: to the terms and conditions of the Intel Program License 
    Info: Subscription Agreement, the Intel Quartus Prime License Agreement,
    Info: the Intel FPGA IP License Agreement, or other applicable license
    Info: agreement, including, without limitation, that your use is for
    Info: the sole purpose of programming logic devices manufactured by
    Info: Intel and sold by Intel or its authorized distributors.  Please
    Info: refer to the applicable agreement for further details.
    Info: Processing started: Wed Nov 18 06:19:54 2020
Info: Command: quartus_sh -t /opt/altera/quartus/common/tcl/internal/nativelink/qnativesim.tcl --gen_script --rtl_sim mp4 mp4
Info: Quartus(args): --gen_script --rtl_sim mp4 mp4
Info: Info: Start Nativelink Simulation process
Info: Info: NativeLink has detected Verilog design -- Verilog simulation models will be used
Info: Info: Starting NativeLink simulation with ModelSim-Altera software
Info: Info: Generated ModelSim-Altera script file /job/student/simulation/modelsim/mp4_run_msim_rtl_verilog.do File: /job/student/simulation/modelsim/mp4_run_msim_rtl_verilog.do Line: 0
Info: Info: NativeLink simulation flow was successful
Info: Info: For messages from NativeLink scripts, check the file /job/student/mp4_nativelink_simulation.rpt File: /job/student/mp4_nativelink_simulation.rpt Line: 0
Info (23030): Evaluation of Tcl script /opt/altera/quartus/common/tcl/internal/nativelink/qnativesim.tcl was successful
Info: Quartus Prime Shell was successful. 0 errors, 0 warnings
    Info: Peak virtual memory: 798 megabytes
    Info: Processing ended: Wed Nov 18 06:19:55 2020
    Info: Elapsed time: 00:00:01
    Info: Total CPU time (on all processors): 00:00:00
Reading pref.tcl

# 10.5b

ModelSim> transcript on
ModelSim> > > if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
ModelSim> vlib rtl_work
ModelSim> vmap work rtl_work
# Model Technology ModelSim - Intel FPGA Edition vmap 10.5b Lib Mapping Utility 2016.10 Oct  5 2016
# vmap work rtl_work 
# Modifying /opt/altera/modelsim_ase/linuxaloem/../modelsim.ini
ModelSim> 
> 
vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/cacheline_adaptor.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:55 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/cacheline_adaptor.sv 
# -- Compiling module cacheline_adaptor
# 
# Top level modules:
# 	cacheline_adaptor
# End time: 06:19:55 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/arbiter.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:55 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/arbiter.sv 
# -- Compiling module arbiter
# 
# Top level modules:
# 	arbiter
# End time: 06:19:55 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl/given_cache {/job/student/hdl/given_cache/line_adapter.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:55 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl/given_cache" /job/student/hdl/given_cache/line_adapter.sv 
# -- Compiling module line_adapter
# 
# Top level modules:
# 	line_adapter
# End time: 06:19:55 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl/given_cache {/job/student/hdl/given_cache/data_array.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:55 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl/given_cache" /job/student/hdl/given_cache/data_array.sv 
# -- Compiling module data_array
# 
# Top level modules:
# 	data_array
# End time: 06:19:55 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl/given_cache {/job/student/hdl/given_cache/cache_datapath.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:55 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl/given_cache" /job/student/hdl/given_cache/cache_datapath.sv 
# -- Compiling module cache_datapath
# 
# Top level modules:
# 	cache_datapath
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:01
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl/given_cache {/job/student/hdl/given_cache/cache_control.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl/given_cache" /job/student/hdl/given_cache/cache_control.sv 
# -- Compiling module cache_control
# 
# Top level modules:
# 	cache_control
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl/given_cache {/job/student/hdl/given_cache/array.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl/given_cache" /job/student/hdl/given_cache/array.sv 
# -- Compiling module array
# 
# Top level modules:
# 	array
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/rv32i_mux_types.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/rv32i_mux_types.sv 
# -- Compiling package pcmux
# -- Compiling package marmux
# -- Compiling package cmpmux
# -- Compiling package alumux
# -- Compiling package regfilemux
# -- Compiling package forwardmux1
# -- Compiling package forwardmux2
# -- Compiling package mem_forwardmux2
# 
# Top level modules:
# 	--none--
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/register.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/register.sv 
# -- Compiling module register
# 
# Top level modules:
# 	register
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/regfile.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/regfile.sv 
# -- Compiling module regfile
# 
# Top level modules:
# 	regfile
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/pc_register.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/pc_register.sv 
# -- Compiling module pc_register
# 
# Top level modules:
# 	pc_register
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl/given_cache {/job/student/hdl/given_cache/cache.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl/given_cache" /job/student/hdl/given_cache/cache.sv 
# -- Compiling module cache
# 
# Top level modules:
# 	cache
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/rv32i_types.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/rv32i_types.sv 
# -- Compiling package rv32i_types
# -- Importing package pcmux
# -- Importing package marmux
# -- Importing package cmpmux
# -- Importing package alumux
# -- Importing package regfilemux
# -- Importing package forwardmux1
# -- Importing package forwardmux2
# -- Importing package mem_forwardmux2
# 
# Top level modules:
# 	--none--
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/types.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/types.sv 
# -- Compiling package types
# -- Importing package rv32i_types
# -- Importing package pcmux
# -- Importing package marmux
# -- Importing package cmpmux
# -- Importing package alumux
# -- Importing package regfilemux
# -- Importing package forwardmux1
# -- Importing package forwardmux2
# -- Importing package mem_forwardmux2
# 
# Top level modules:
# 	--none--
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/cmp.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/cmp.sv 
# -- Compiling package cmp_sv_unit
# -- Importing package rv32i_types
# -- Importing package pcmux
# -- Importing package marmux
# -- Importing package cmpmux
# -- Importing package alumux
# -- Importing package regfilemux
# -- Importing package forwardmux1
# -- Importing package forwardmux2
# -- Importing package mem_forwardmux2
# -- Compiling module cmp
# 
# Top level modules:
# 	cmp
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/alu.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/alu.sv 
# -- Compiling package alu_sv_unit
# -- Importing package rv32i_types
# -- Importing package pcmux
# -- Importing package marmux
# -- Importing package cmpmux
# -- Importing package alumux
# -- Importing package regfilemux
# -- Importing package forwardmux1
# -- Importing package forwardmux2
# -- Importing package mem_forwardmux2
# -- Compiling module alu
# 
# Top level modules:
# 	alu
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/forwarding_unit.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/forwarding_unit.sv 
# -- Compiling package forwarding_unit_sv_unit
# -- Importing package rv32i_types
# -- Importing package pcmux
# -- Importing package marmux
# -- Importing package cmpmux
# -- Importing package alumux
# -- Importing package regfilemux
# -- Importing package forwardmux1
# -- Importing package forwardmux2
# -- Importing package mem_forwardmux2
# -- Importing package types
# -- Compiling module forwarding_unit
# -- Compiling module mem_forwarding_unit
# 
# Top level modules:
# 	forwarding_unit
# 	mem_forwarding_unit
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/ctrl_rom.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/ctrl_rom.sv 
# -- Compiling package ctrl_rom_sv_unit
# -- Importing package rv32i_types
# -- Importing package pcmux
# -- Importing package marmux
# -- Importing package cmpmux
# -- Importing package alumux
# -- Importing package regfilemux
# -- Importing package forwardmux1
# -- Importing package forwardmux2
# -- Importing package mem_forwardmux2
# -- Importing package types
# -- Compiling module ctrl_rom
# 
# Top level modules:
# 	ctrl_rom
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/datapath.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/datapath.sv 
# -- Compiling package datapath_sv_unit
# -- Importing package rv32i_types
# -- Importing package pcmux
# -- Importing package marmux
# -- Importing package cmpmux
# -- Importing package alumux
# -- Importing package regfilemux
# -- Importing package forwardmux1
# -- Importing package forwardmux2
# -- Importing package mem_forwardmux2
# -- Importing package types
# -- Compiling module datapath
# 
# Top level modules:
# 	datapath
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hdl {/job/student/hdl/mp4.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hdl" /job/student/hdl/mp4.sv 
# -- Compiling module mp4
# 
# Top level modules:
# 	mp4
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> 
> 
vlog -vlog01compat -work work +incdir+/job/student/hvl {/job/student/hvl/rvfimon.v}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -vlog01compat -work work "+incdir+/job/student/hvl" /job/student/hvl/rvfimon.v 
# -- Compiling module riscv_formal_monitor_rv32imc
# -- Compiling module riscv_formal_monitor_rv32imc_rob
# -- Compiling module riscv_formal_monitor_rv32imc_isa_spec
# -- Compiling module riscv_formal_monitor_rv32imc_insn_add
# -- Compiling module riscv_formal_monitor_rv32imc_insn_addi
# -- Compiling module riscv_formal_monitor_rv32imc_insn_and
# -- Compiling module riscv_formal_monitor_rv32imc_insn_andi
# -- Compiling module riscv_formal_monitor_rv32imc_insn_auipc
# -- Compiling module riscv_formal_monitor_rv32imc_insn_beq
# -- Compiling module riscv_formal_monitor_rv32imc_insn_bge
# -- Compiling module riscv_formal_monitor_rv32imc_insn_bgeu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_blt
# -- Compiling module riscv_formal_monitor_rv32imc_insn_bltu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_bne
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_add
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_addi
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_addi16sp
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_addi4spn
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_and
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_andi
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_beqz
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_bnez
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_j
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_jal
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_jalr
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_jr
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_li
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_lui
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_lw
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_lwsp
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_mv
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_or
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_slli
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_srai
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_srli
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_sub
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_sw
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_swsp
# -- Compiling module riscv_formal_monitor_rv32imc_insn_c_xor
# -- Compiling module riscv_formal_monitor_rv32imc_insn_div
# -- Compiling module riscv_formal_monitor_rv32imc_insn_divu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_jal
# -- Compiling module riscv_formal_monitor_rv32imc_insn_jalr
# -- Compiling module riscv_formal_monitor_rv32imc_insn_lb
# -- Compiling module riscv_formal_monitor_rv32imc_insn_lbu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_lh
# -- Compiling module riscv_formal_monitor_rv32imc_insn_lhu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_lui
# -- Compiling module riscv_formal_monitor_rv32imc_insn_lw
# -- Compiling module riscv_formal_monitor_rv32imc_insn_mul
# -- Compiling module riscv_formal_monitor_rv32imc_insn_mulh
# -- Compiling module riscv_formal_monitor_rv32imc_insn_mulhsu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_mulhu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_or
# -- Compiling module riscv_formal_monitor_rv32imc_insn_ori
# -- Compiling module riscv_formal_monitor_rv32imc_insn_rem
# -- Compiling module riscv_formal_monitor_rv32imc_insn_remu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sb
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sh
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sll
# -- Compiling module riscv_formal_monitor_rv32imc_insn_slli
# -- Compiling module riscv_formal_monitor_rv32imc_insn_slt
# -- Compiling module riscv_formal_monitor_rv32imc_insn_slti
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sltiu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sltu
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sra
# -- Compiling module riscv_formal_monitor_rv32imc_insn_srai
# -- Compiling module riscv_formal_monitor_rv32imc_insn_srl
# -- Compiling module riscv_formal_monitor_rv32imc_insn_srli
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sub
# -- Compiling module riscv_formal_monitor_rv32imc_insn_sw
# -- Compiling module riscv_formal_monitor_rv32imc_insn_xor
# -- Compiling module riscv_formal_monitor_rv32imc_insn_xori
# 
# Top level modules:
# 	riscv_formal_monitor_rv32imc
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> vlog -sv -work work +incdir+/job/student/hvl {/job/student/hvl/source_tb.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hvl" /job/student/hvl/source_tb.sv 
# -- Compiling module magic_memory_dp
# -- Compiling module ParamMemory
# ** Warning: ** while parsing file included at /job/student/hvl/source_tb.sv(14)
# ** at hvl/param_memory.sv(25): (vlog-2244) Variable 'iteration' is implicitly static. You must either explicitly declare it as static or automatic
# or remove the initialization in the declaration of variable.
# -- Compiling interface rvfi_itf
# -- Compiling module shadow_memory
# -- Compiling interface tb_itf
# -- Compiling package ag_rv32i_types
# -- Compiling package source_tb_sv_unit
# -- Importing package ag_rv32i_types
# -- Compiling module source_tb
# 
# Top level modules:
# 	source_tb
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 1
ModelSim> vlog -sv -work work +incdir+/job/student/hvl {/job/student/hvl/top.sv}
# Model Technology ModelSim - Intel FPGA Edition vlog 10.5b Compiler 2016.10 Oct  5 2016
# Start time: 06:19:56 on Nov 18,2020
# vlog -sv -work work "+incdir+/job/student/hvl" /job/student/hvl/top.sv 
# -- Compiling module mp4_tb
# 
# Top level modules:
# 	mp4_tb
# End time: 06:19:56 on Nov 18,2020, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
ModelSim> 
> 
vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L arriaii_hssi_ver -L arriaii_pcie_hip_ver -L arriaii_ver -L rtl_work -L work -voptargs="+acc"  mp4_tb
# vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L arriaii_hssi_ver -L arriaii_pcie_hip_ver -L arriaii_ver -L rtl_work -L work -voptargs=""+acc"" mp4_tb 
# Start time: 06:19:56 on Nov 18,2020
# Loading sv_std.std
# Loading work.mp4_tb
# Loading work.tb_itf
# Loading work.rvfi_itf
# Loading work.ag_rv32i_types
# Loading work.source_tb_sv_unit
# Loading work.source_tb
# Loading work.riscv_formal_monitor_rv32imc
# Loading work.riscv_formal_monitor_rv32imc_isa_spec
# Loading work.riscv_formal_monitor_rv32imc_insn_add
# Loading work.riscv_formal_monitor_rv32imc_insn_addi
# Loading work.riscv_formal_monitor_rv32imc_insn_and
# Loading work.riscv_formal_monitor_rv32imc_insn_andi
# Loading work.riscv_formal_monitor_rv32imc_insn_auipc
# Loading work.riscv_formal_monitor_rv32imc_insn_beq
# Loading work.riscv_formal_monitor_rv32imc_insn_bge
# Loading work.riscv_formal_monitor_rv32imc_insn_bgeu
# Loading work.riscv_formal_monitor_rv32imc_insn_blt
# Loading work.riscv_formal_monitor_rv32imc_insn_bltu
# Loading work.riscv_formal_monitor_rv32imc_insn_bne
# Loading work.riscv_formal_monitor_rv32imc_insn_c_add
# Loading work.riscv_formal_monitor_rv32imc_insn_c_addi
# Loading work.riscv_formal_monitor_rv32imc_insn_c_addi16sp
# Loading work.riscv_formal_monitor_rv32imc_insn_c_addi4spn
# Loading work.riscv_formal_monitor_rv32imc_insn_c_and
# Loading work.riscv_formal_monitor_rv32imc_insn_c_andi
# Loading work.riscv_formal_monitor_rv32imc_insn_c_beqz
# Loading work.riscv_formal_monitor_rv32imc_insn_c_bnez
# Loading work.riscv_formal_monitor_rv32imc_insn_c_j
# Loading work.riscv_formal_monitor_rv32imc_insn_c_jal
# Loading work.riscv_formal_monitor_rv32imc_insn_c_jalr
# Loading work.riscv_formal_monitor_rv32imc_insn_c_jr
# Loading work.riscv_formal_monitor_rv32imc_insn_c_li
# Loading work.riscv_formal_monitor_rv32imc_insn_c_lui
# Loading work.riscv_formal_monitor_rv32imc_insn_c_lw
# Loading work.riscv_formal_monitor_rv32imc_insn_c_lwsp
# Loading work.riscv_formal_monitor_rv32imc_insn_c_mv
# Loading work.riscv_formal_monitor_rv32imc_insn_c_or
# Loading work.riscv_formal_monitor_rv32imc_insn_c_slli
# Loading work.riscv_formal_monitor_rv32imc_insn_c_srai
# Loading work.riscv_formal_monitor_rv32imc_insn_c_srli
# Loading work.riscv_formal_monitor_rv32imc_insn_c_sub
# Loading work.riscv_formal_monitor_rv32imc_insn_c_sw
# Loading work.riscv_formal_monitor_rv32imc_insn_c_swsp
# Loading work.riscv_formal_monitor_rv32imc_insn_c_xor
# Loading work.riscv_formal_monitor_rv32imc_insn_div
# Loading work.riscv_formal_monitor_rv32imc_insn_divu
# Loading work.riscv_formal_monitor_rv32imc_insn_jal
# Loading work.riscv_formal_monitor_rv32imc_insn_jalr
# Loading work.riscv_formal_monitor_rv32imc_insn_lb
# Loading work.riscv_formal_monitor_rv32imc_insn_lbu
# Loading work.riscv_formal_monitor_rv32imc_insn_lh
# Loading work.riscv_formal_monitor_rv32imc_insn_lhu
# Loading work.riscv_formal_monitor_rv32imc_insn_lui
# Loading work.riscv_formal_monitor_rv32imc_insn_lw
# Loading work.riscv_formal_monitor_rv32imc_insn_mul
# Loading work.riscv_formal_monitor_rv32imc_insn_mulh
# Loading work.riscv_formal_monitor_rv32imc_insn_mulhsu
# Loading work.riscv_formal_monitor_rv32imc_insn_mulhu
# Loading work.riscv_formal_monitor_rv32imc_insn_or
# Loading work.riscv_formal_monitor_rv32imc_insn_ori
# Loading work.riscv_formal_monitor_rv32imc_insn_rem
# Loading work.riscv_formal_monitor_rv32imc_insn_remu
# Loading work.riscv_formal_monitor_rv32imc_insn_sb
# Loading work.riscv_formal_monitor_rv32imc_insn_sh
# Loading work.riscv_formal_monitor_rv32imc_insn_sll
# Loading work.riscv_formal_monitor_rv32imc_insn_slli
# Loading work.riscv_formal_monitor_rv32imc_insn_slt
# Loading work.riscv_formal_monitor_rv32imc_insn_slti
# Loading work.riscv_formal_monitor_rv32imc_insn_sltiu
# Loading work.riscv_formal_monitor_rv32imc_insn_sltu
# Loading work.riscv_formal_monitor_rv32imc_insn_sra
# Loading work.riscv_formal_monitor_rv32imc_insn_srai
# Loading work.riscv_formal_monitor_rv32imc_insn_srl
# Loading work.riscv_formal_monitor_rv32imc_insn_srli
# Loading work.riscv_formal_monitor_rv32imc_insn_sub
# Loading work.riscv_formal_monitor_rv32imc_insn_sw
# Loading work.riscv_formal_monitor_rv32imc_insn_xor
# Loading work.riscv_formal_monitor_rv32imc_insn_xori
# Loading work.riscv_formal_monitor_rv32imc_rob
# Loading work.shadow_memory
# Loading work.mp4
# Loading work.mem_forwardmux2
# Loading work.forwardmux2
# Loading work.forwardmux1
# Loading work.regfilemux
# Loading work.alumux
# Loading work.cmpmux
# Loading work.marmux
# Loading work.pcmux
# Loading work.rv32i_types
# Loading work.types
# Loading work.datapath_sv_unit
# Loading work.datapath
# Loading work.pc_register
# Loading work.regfile
# Loading work.ctrl_rom_sv_unit
# Loading work.ctrl_rom
# Loading work.forwarding_unit_sv_unit
# Loading work.forwarding_unit
# Loading work.cmp_sv_unit
# Loading work.cmp
# Loading work.alu_sv_unit
# Loading work.alu
# Loading work.mem_forwarding_unit
# Loading work.register
# Loading work.cache
# Loading work.cache_control
# Loading work.cache_datapath
# Loading work.data_array
# Loading work.array
# Loading work.line_adapter
# Loading work.arbiter
# Loading work.cacheline_adaptor
# Loading work.ParamMemory
# ** Warning: (vsim-3015) /job/student/hvl/source_tb.sv(228): [PCDPC] - Port size (5) does not match connection size (32) for port 'rvfi_rd_addr'. The port definition is at: /job/student/hvl/rvfimon.v(21).
#    Time: 0 ps  Iteration: 0  Instance: /mp4_tb/tb/monitor File: /job/student/hvl/rvfimon.v
VSIM 29> 
> 
add wave *
VSIM 30> view structure
VSIM 31> # 
# <EOF>
# 0: RVMODEL NULL (Expected)
# End time: 06:19:57 on Nov 18,2020, Elapsed time: 0:00:01
# Errors: 0, Warnings: 1

```

</details>


### Targeted Tests: 
<ul>
<li> <b>cp1_cache</b> <img alt="failure" width="13" height="13" src="https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Red_x.svg/13px-Red_x.svg.png" ></img></li>
<li> <b>cp2</b> <img alt="failure" width="13" height="13" src="https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Red_x.svg/13px-Red_x.svg.png" ></img></li>
</ul>

---
Staff use: 5fb4baba992def9c51c720d8

[success]: https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Green_check.svg/13px-Green_check.svg.png 
[failure]: https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Red_x.svg/13px-Red_x.svg.png 