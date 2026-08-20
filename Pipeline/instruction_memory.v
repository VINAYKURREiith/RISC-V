module instruction_memory(
    input wire [63:0]addr,
    output wire [31:0] instruction

);
reg [31:0] memory [0:255];
initial begin
    $readmemh("program.mem",memory);
end
assign instruction = memory[addr[63:2]];
endmodule