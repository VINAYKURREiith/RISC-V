module mem_wb_register(

    input wire clk,
    input wire rst,

    input wire [63:0] memory_data_in,
    input wire [63:0] alu_result_in,

    input wire [4:0] rd_in,

    input wire RegWrite_in,
    input wire MemToReg_in,

    output reg [63:0] memory_data_out,
    output reg [63:0] alu_result_out,

    output reg [4:0] rd_out,

    output reg RegWrite_out,
    output reg MemToReg_out

);

always @(posedge clk) begin

    if(rst) begin

        memory_data_out <= 64'd0;
        alu_result_out  <= 64'd0;

        rd_out <= 5'd0;

        RegWrite_out <= 1'b0;
        MemToReg_out <= 1'b0;

    end
    else begin

        memory_data_out <= memory_data_in;
        alu_result_out  <= alu_result_in;

        rd_out <= rd_in;

        RegWrite_out <= RegWrite_in;
        MemToReg_out <= MemToReg_in;

    end

end

endmodule