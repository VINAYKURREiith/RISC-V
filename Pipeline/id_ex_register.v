module id_ex_register(

    input wire clk,
    input wire rst,

    input wire [63:0] pc_in,
    input wire [63:0] read_data1_in,
    input wire [63:0] read_data2_in,
    input wire [63:0] imm_in,
    input wire [4:0] rs1_in,
    input wire [4:0] rs2_in,

    input wire [4:0] rd_in,
    input wire [2:0] funct3_in,
    input wire funct7_in,
    input wire [6:0] opcode_in,

    input wire RegWrite_in,
    input wire ALUSrc_in,
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire MemToReg_in,
    input wire Branch_in,
    input wire [1:0] ALUOp_in,

    output reg [63:0] pc_out,
    output reg [63:0] read_data1_out,
    output reg [63:0] read_data2_out,
    output reg [63:0] imm_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,

    output reg [4:0] rd_out,
    output reg [2:0] funct3_out,
    output reg funct7_out,
    output reg [6:0] opcode_out,

    output reg RegWrite_out,
    output reg ALUSrc_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemToReg_out,
    output reg Branch_out,
    output reg [1:0] ALUOp_out

);
always @(posedge clk) begin

    if(rst) begin

        pc_out <= 64'd0;
        read_data1_out <= 64'd0;
        read_data2_out <= 64'd0;
        imm_out <= 64'd0;

        rd_out <= 5'd0;
        funct3_out <= 3'd0;
        funct7_out <= 1'b0;
        opcode_out <= 7'd0;

        RegWrite_out <= 1'b0;
        ALUSrc_out <= 1'b0;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        MemToReg_out <= 1'b0;
        Branch_out <= 1'b0;
        ALUOp_out <= 2'b00;
        rs1_out <= 5'd0;
        rs2_out <= 5'd0;

    end
    else begin

        pc_out <= pc_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        imm_out <= imm_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;

        rd_out <= rd_in;
        funct3_out <= funct3_in;
        funct7_out <= funct7_in;
        opcode_out <= opcode_in;

        RegWrite_out <= RegWrite_in;
        ALUSrc_out <= ALUSrc_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemToReg_out <= MemToReg_in;
        Branch_out <= Branch_in;
        ALUOp_out <= ALUOp_in;

    end

end
endmodule