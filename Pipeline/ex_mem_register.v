module ex_mem_register(

    input wire clk,
    input wire rst,

    input wire [63:0] alu_result_in,
    input wire [63:0] branch_target_in,
    input wire [63:0] read_data2_in,

    input wire zero_in,

    input wire [4:0] rd_in,

    input wire RegWrite_in,
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire MemToReg_in,
    input wire Branch_in,

    output reg [63:0] alu_result_out,
    output reg [63:0] branch_target_out,
    output reg [63:0] read_data2_out,

    output reg zero_out,

    output reg [4:0] rd_out,

    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemToReg_out,
    output reg Branch_out

);

always @(posedge clk) begin

    if(rst) begin

        alu_result_out <= 64'd0;
        branch_target_out <= 64'd0;
        read_data2_out <= 64'd0;

        zero_out <= 1'b0;

        rd_out <= 5'd0;

        RegWrite_out <= 1'b0;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        MemToReg_out <= 1'b0;
        Branch_out <= 1'b0;

    end
    else begin

        alu_result_out <= alu_result_in;
        branch_target_out <= branch_target_in;
        read_data2_out <= read_data2_in;

        zero_out <= zero_in;

        rd_out <= rd_in;

        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemToReg_out <= MemToReg_in;
        Branch_out <= Branch_in;

    end

end

endmodule