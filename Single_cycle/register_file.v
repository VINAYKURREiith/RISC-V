module register_file(
    input wire clk,
    input wire rst,
    input wire [4:0] rs1, rs2,
    output wire [63:0] read_data1, read_data2,
    input wire [4:0] rd,
    input wire [63:0] write_data,
    input wire RegWrite 
);
reg [63:0] registers[0:31];
integer i;
always @(posedge clk) begin 
    if(rst) begin
        for(i=0;i<32;i=i+1) begin
            registers[i]<=0;
        end
    end
    else begin
        if(RegWrite && rd !=0) begin
            registers[rd] <= write_data;
        end
    end
end
assign read_data1 = registers[rs1];
assign read_data2 = registers[rs2];
endmodule
