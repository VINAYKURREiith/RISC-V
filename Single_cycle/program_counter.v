module program_counter(
    input wire rst,
    input wire clk,
    input wire [63:0] pc_next,
    output reg [63:0] pc
);
always @(posedge clk) begin
    if(rst) begin
        pc<=0;
    end
    else begin
        pc<= pc_next;
    end
end
endmodule