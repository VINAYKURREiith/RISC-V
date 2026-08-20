module alu(
    input wire [63:0] operand_a, operand_b,
    input wire [3:0] alu_control,
    output reg [63:0] alu_result,
    output wire zero
);
always @(*) begin
    case(alu_control) 
        4'b0000 : begin // add
            alu_result = operand_a + operand_b;
        end
        4'b0001 : begin //sub
            alu_result = operand_a - operand_b; 
        end
        4'b0010 :begin //and
            alu_result = operand_a & operand_b;
        end
        4'b0011 : begin //or
           alu_result = operand_a | operand_b;
        end
        4'b0100 :begin //xor
            alu_result = operand_a ^ operand_b;
        end
        4'b0101 : begin //shift left logical
            alu_result = operand_a << operand_b[5:0];
        end
         4'b0110 : begin //shift right logical
            alu_result = operand_a >> operand_b[5:0];
        end
        4'b0111 : begin //shift right arthimetic
            alu_result = $signed(operand_a) >>> operand_b[5:0] ;
        end
        4'b1000 : begin  // set less than
            if ($signed(operand_a) < $signed(operand_b))
                alu_result = 64'd1;
            else
                alu_result = 64'd0;
        end
        default : begin
            alu_result = 64'd0;
        end
    endcase
end
assign zero = (alu_result == 64'd0);
endmodule
