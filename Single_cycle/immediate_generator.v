module immediate_generator(

    input  wire [31:0] instruction,

    output reg  [63:0] imm_out

);

wire [6:0] opcode;

assign opcode = instruction[6:0];

always @(*) begin

    case(opcode)

        //========================================
        // I-Type (ADDI, ANDI, ORI, XORI, SLTI...)
        // Load (LD)
        //========================================
        7'b0010011,
        7'b0000011:
        begin
            imm_out = {{52{instruction[31]}},
                        instruction[31:20]};
        end

        //========================================
        // S-Type (SD)
        //========================================
        7'b0100011:
        begin
            imm_out = {{52{instruction[31]}},
                        instruction[31:25],
                        instruction[11:7]};
        end

        //========================================
        // B-Type (BEQ)
        //========================================
        7'b1100011:
        begin
            imm_out = {{51{instruction[31]}},
                        instruction[31],
                        instruction[7],
                        instruction[30:25],
                        instruction[11:8],
                        1'b0};
        end

        //========================================
        // U-Type (LUI)
        //========================================
        7'b0110111:
        begin
            imm_out = {{32{instruction[31]}},
                        instruction[31:12],
                        12'b0};
        end

        //========================================
        // U-Type (AUIPC)
        //========================================
        7'b0010111:
        begin
            imm_out = {{32{instruction[31]}},
                        instruction[31:12],
                        12'b0};
        end

        //========================================
        // J-Type (JAL)
        //========================================
        7'b1101111:
        begin
            imm_out = {{43{instruction[31]}},
                        instruction[31],
                        instruction[19:12],
                        instruction[20],
                        instruction[30:21],
                        1'b0};
        end

        default:
        begin
            imm_out = 64'd0;
        end

    endcase

end

endmodule