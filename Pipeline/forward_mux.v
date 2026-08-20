module forward_mux(

    input wire [1:0] Forward,
    input wire [63:0] reg_data,
    input wire [63:0] ex_mem_data,
    input wire [63:0] mem_wb_data,

    output reg [63:0] forward_data

);

always @(*) begin

    case(Forward)

        2'b00: forward_data = reg_data;

        2'b01: forward_data = mem_wb_data;

        2'b10: forward_data = ex_mem_data;

        default: forward_data = reg_data;

    endcase

end

endmodule