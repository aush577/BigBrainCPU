# AG Report Generated 2020-11-15 00:14
This is a report about mp4cp1 generated for BigBrainCPU at 2020-11-15 00:14. The autograder used commit ``543774c6d4de`` as a starting point. If you have any questions about this report, please contact the TAs on Piazza.
### Quick Results:
 - Compilation: NO
 - Targeted: 0/1 (0.0%)
### Compilation ![Failure][failure]
You did not succesfully compile. Your report is below.
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
    Info: Processing started: Sun Nov 15 06:14:31 2020
Info: Command: quartus_map mp4 -c mp4
Warning (18236): Number of processors has not been specified which may cause overloading on shared machines.  Set the global assignment NUM_PARALLEL_PROCESSORS in your QSF to an appropriate value for best performance.
Info (20029): Only one processor detected - disabling parallel compilation
Info (12021): Found 1 design units, including 0 entities, in source file hdl/types.sv
    Info (12022): Found design unit 1: types (SystemVerilog) File: /job/student/hdl/types.sv Line: 1
Info (12021): Found 1 design units, including 0 entities, in source file hdl/rv32i_types.sv
    Info (12022): Found design unit 1: rv32i_types (SystemVerilog) File: /job/student/hdl/rv32i_types.sv Line: 1
Error (10170): Verilog HDL syntax error at rv32i_mux_types.sv(52) near text: "package";  expecting "endpackage". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/rv32i_mux_types.sv Line: 52
Error (10170): Verilog HDL syntax error at rv32i_mux_types.sv(62) near text: "}";  expecting an identifier. Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/rv32i_mux_types.sv Line: 62
Error (10112): Ignored design unit "regfilemux" at rv32i_mux_types.sv(38) due to previous errors File: /job/student/hdl/rv32i_mux_types.sv Line: 38
Info (12021): Found 0 design units, including 0 entities, in source file hdl/rv32i_mux_types.sv
Info (12021): Found 1 design units, including 1 entities, in source file hdl/register.sv
    Info (12023): Found entity 1: register File: /job/student/hdl/register.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/regfile.sv
    Info (12023): Found entity 1: regfile File: /job/student/hdl/regfile.sv Line: 1
Info (12021): Found 1 design units, including 1 entities, in source file hdl/pc_register.sv
    Info (12023): Found entity 1: pc_register File: /job/student/hdl/pc_register.sv Line: 3
Error (10170): Verilog HDL syntax error at datapath.sv(107) near text: "function";  expecting ";". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 107
Error (10170): Verilog HDL syntax error at datapath.sv(111) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 111
Error (10170): Verilog HDL syntax error at datapath.sv(112) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 112
Error (10170): Verilog HDL syntax error at datapath.sv(113) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 113
Error (10170): Verilog HDL syntax error at datapath.sv(114) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 114
Error (10170): Verilog HDL syntax error at datapath.sv(114) near text: "}";  expecting ";". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 114
Error (10170): Verilog HDL syntax error at datapath.sv(115) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 115
Error (10149): Verilog HDL Declaration error at datapath.sv(115): identifier "data" is already declared in the present scope File: /job/student/hdl/datapath.sv Line: 115
Error (10170): Verilog HDL syntax error at datapath.sv(115) near text: "}";  expecting ";". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 115
Error (10170): Verilog HDL syntax error at datapath.sv(116) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 116
Error (10149): Verilog HDL Declaration error at datapath.sv(116): identifier "data" is already declared in the present scope File: /job/student/hdl/datapath.sv Line: 116
Error (10170): Verilog HDL syntax error at datapath.sv(116) near text: "1";  expecting an identifier. Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 116
Error (10170): Verilog HDL syntax error at datapath.sv(117) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 117
Error (10170): Verilog HDL syntax error at datapath.sv(118) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 118
Error (10149): Verilog HDL Declaration error at datapath.sv(118): identifier "data" is already declared in the present scope File: /job/student/hdl/datapath.sv Line: 118
Error (10170): Verilog HDL syntax error at datapath.sv(118) near text: "1";  expecting an identifier. Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 118
Error (10170): Verilog HDL syntax error at datapath.sv(119) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 119
Error (10170): Verilog HDL syntax error at datapath.sv(120) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 120
Error (10170): Verilog HDL syntax error at datapath.sv(121) near text: "=";  expecting ".", or "(". Check for and fix any syntax errors that appear immediately before or at the specified keyword. The Intel FPGA Knowledge Database contains many articles with specific details on how to resolve this error. Visit the Knowledge Database at https://www.altera.com/support/support-resources/knowledge-base/search.html and search for this specific error message number. File: /job/student/hdl/datapath.sv Line: 121
Info (12021): Found 0 design units, including 0 entities, in source file hdl/datapath.sv
Info (12021): Found 1 design units, including 1 entities, in source file hdl/ctrl_rom.sv
    Info (12023): Found entity 1: ctrl_rom File: /job/student/hdl/ctrl_rom.sv Line: 5
Info (12021): Found 1 design units, including 1 entities, in source file hdl/cmp.sv
    Info (12023): Found entity 1: cmp File: /job/student/hdl/cmp.sv Line: 3
Info (12021): Found 1 design units, including 1 entities, in source file hdl/alu.sv
    Info (12023): Found entity 1: alu File: /job/student/hdl/alu.sv Line: 3
Info (12021): Found 1 design units, including 1 entities, in source file hdl/mp4.sv
    Info (12023): Found entity 1: mp4 File: /job/student/hdl/mp4.sv Line: 1
Error: Quartus Prime Analysis & Synthesis was unsuccessful. 22 errors, 1 warning
    Error: Peak virtual memory: 987 megabytes
    Error: Processing ended: Sun Nov 15 06:14:48 2020
    Error: Elapsed time: 00:00:17
    Error: Total CPU time (on all processors): 00:00:15

```

</details>


### Targeted Tests: 
<ul>
<li> <b>cp1</b> <img src="https://upload.wikimedia.org/wikipedia/en/thumb/7/74/Ambox_warning_yellow.svg/40px-Ambox_warning_yellow.svg.png" alt="error" width="13" height="13" ></img><details>
<summary>Error Occurred</summary>

```
An error occured when running this test.
If your code did not successfully compile, that is likely the reason.
If your code did compile, then please reach out to a TA on Piazza
```

</details>
</li>
</ul>

---
Staff use: 5fb0c63a992def9c51c71eff

[success]: https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Green_check.svg/13px-Green_check.svg.png 
[failure]: https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Red_x.svg/13px-Red_x.svg.png 
