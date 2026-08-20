module alu_src_mux (
    input  wire [63:0] reg_data,
    input  wire [63:0] imm_data,
    input  wire        ALUSrc,
    output wire [63:0] alu_operand
);
assign alu_operand = (ALUSrc) ? imm_data : reg_data;
endmodule