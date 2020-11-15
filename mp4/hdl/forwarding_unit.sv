module forwarding_unit (

);

forw_mux_sel_t rs1forw_mux_sel;
forw_mux_sel_t rs2forw_mux_sel;

assign rs1forw_mux_sel = forw_mux::idex_rs1reg_out;
assign rs2forw_mux_sel = forw_mux::idex_rs2reg_out;

if (exmem_ctrlreg_out.regfile_ld 
    && exmem_ireg_out.rd != 0 
    && exmem_ireg_out.rd == idex_ireg_out.rs1
    && memwb_ireg_out.rd != idex_ireg_out.rs1
) begin
  rs1forw_mux_sel = forw_mux::exmem_alureg_out;
end

else if (exmem_ctrlreg_out.regfile_ld 
        && exmem_ireg_out.rd != 0
        && exmem_ireg_out.rd == idex_ireg_out.rs2
        && memwb_ireg_out.rd != idex_ireg_out.rs2
) begin
  rs2forw_mux_sel = forw_mux::exmem_alureg_out;
end

else if (memwb_ctrlreg_out.regfile_ld 
        && memwb_ireg_out.rd != 0
        && !(exmem_ctrlreg_out.regfile_ld && exmem_ireg_out.rd != 0)
        && exmem_ireg_out.rd != idex_ireg_out.rs1
        && memwb_ireg_out.rd == idex_ireg_out.rs1
) begin
    rs1forw_mux_sel = forw_mux::regfile_wdata;
end

else if (memwb_ctrlreg_out.regfile_ld 
        && memwb_ireg_out.rd != 0
        && !(exmem_ctrlreg_out.regfile_ld && exmem_ireg_out.rd != 0)
        && exmem_ireg_out.rd != idex_ireg_out.rs2
        && memwb_ireg_out.rd == idex_ireg_out.rs2
) begin
    rs2forw_mux_sel = forw_mux::regfile_wdata
end

endmodule : forwaring_unit