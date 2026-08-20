module write_back_mux (
    input  wire [63:0] alu_result,
    input  wire [63:0] memory_data,
    input  wire        MemToReg,
    output wire [63:0] write_back_data

);
assign write_back_data = (MemToReg) ? memory_data : alu_result;
endmodule