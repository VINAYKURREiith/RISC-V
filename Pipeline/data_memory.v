module data_memory (

    input  wire        clk,
    input  wire [63:0] address,
    input  wire [63:0] write_data,
    input  wire        MemRead,
    input  wire        MemWrite,
    output reg  [63:0] read_data

);

    reg [63:0] memory [0:255];
    always @(posedge clk) begin

        if (MemWrite)
            memory[address[63:3]] <= write_data;

    end
    always @(*) begin
        if (MemRead)
            read_data = memory[address[63:3]];
        else
            read_data = 64'd0;
    end
endmodule