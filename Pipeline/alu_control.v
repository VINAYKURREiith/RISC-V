module alu_control(

    input  wire [1:0] alu_op,
    input  wire [6:0] op_code,
    input  wire [2:0] funct3,
    input  wire       funct7,

    output reg  [3:0] alu_control

);

always @(*) begin

    case (alu_op)

        // Load and Store
        // Address = rs1 + immediate
        2'b00: begin
            alu_control = 4'b0000;   // ADD
        end

        // Branch (BEQ)
        // Compare by subtraction
        2'b01: begin
            alu_control = 4'b0001;   // SUB
        end

        // R-Type and I-Type Arithmetic
        2'b10: begin

            case (funct3)

                // ADD / SUB / ADDI
                3'b000: begin
                    if(op_code == 7'b0110011) begin
                        // R-Type
                        if(funct7)
                            alu_control = 4'b0001;   // SUB
                        else
                            alu_control = 4'b0000;   // ADD
                    end
                    else begin
                        // I-Type (ADDI)
                        alu_control = 4'b0000;       // ADD
                    end
                end

                // SLL / SLLI
                3'b001: begin
                    alu_control = 4'b0101;
                end

                // SLT / SLTI
                3'b010: begin
                    alu_control = 4'b1000;
                end

                // XOR / XORI
                3'b100: begin
                    alu_control = 4'b0100;
                end

                // SRL / SRA / SRLI / SRAI
                3'b101: begin
                    if(funct7)
                        alu_control = 4'b0111;   // SRA / SRAI
                    else
                        alu_control = 4'b0110;   // SRL / SRLI
                end

                // OR / ORI
                3'b110: begin
                    alu_control = 4'b0011;
                end

                // AND / ANDI
                3'b111: begin
                    alu_control = 4'b0010;
                end

                default: begin
                    alu_control = 4'b0000;
                end

            endcase

        end

        default: begin
            alu_control = 4'b0000;
        end

    endcase

end

endmodule