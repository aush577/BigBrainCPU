package pcmux;
typedef enum bit {
    pc_plus4  = 1'b0
    ,alu_out  = 1'b1
} pcmux_sel_t;
endpackage

package marmux;
typedef enum bit {
    pc_out = 1'b0
    ,alu_out = 1'b1
} marmux_sel_t;
endpackage

package cmpmux;
typedef enum bit {
    rs2_out = 1'b0
    ,i_imm = 1'b1
} cmpmux_sel_t;
endpackage

package alumux;
typedef enum bit {
    rs1_out = 1'b0
    ,pc_out = 1'b1
} alumux1_sel_t;

typedef enum bit [2:0] {
    i_imm    = 3'b000
    ,u_imm   = 3'b001
    ,b_imm   = 3'b010
    ,s_imm   = 3'b011
    ,j_imm   = 3'b100
    ,rs2_out = 3'b101
} alumux2_sel_t;
endpackage

package regfilemux;
typedef enum bit [3:0] {
    alu_out   = 4'b0000
    ,br_en    = 4'b0001
    ,u_imm    = 4'b0010
    ,mdr      = 4'b0011 // ,lw       = 4'b0011
    ,pc_plus4 = 4'b0100
    // ,lb        = 4'b0101
    // ,lbu       = 4'b0110  // unsigned byte
    // ,lh        = 4'b0111
    // ,lhu       = 4'b1000  // unsigned halfword
} regfilemux_sel_t;
endpackage

package forwardmux1;
typedef enum bit [2:0] {
    idex_rs1 = 3'b000
    ,exmem_alu = 3'b001
    ,regfilemux = 3'b010
    ,mem_rdata = 3'b011
    ,mem_uimm = 3'b100
    ,cmp_br = 3'b101
} forwardmux1_sel_t;
endpackage

package forwardmux2;
typedef enum bit [2:0] {
    idex_rs2 = 3'b000
    ,exmem_alu = 3'b001
    ,regfilemux = 3'b010
    ,mem_rdata = 3'b011
    ,mem_uimm = 3'b100
    ,cmp_br = 3'b101
} forwardmux2_sel_t;
endpackage

package mem_forwardmux2;
typedef enum bit {
    exmem_rs2 = 1'b0
    ,regfilemux = 1'b1
} mem_forwardmux2_sel_t;
endpackage
