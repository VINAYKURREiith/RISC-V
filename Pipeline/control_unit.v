module control_unit (
    input  wire [6:0] opcode,
    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        MemToReg,
    output reg        Branch,
    output reg [1:0]  ALUOp

);
always @(*) begin

    // Default values
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    MemToReg = 1'b0;
    Branch   = 1'b0;
    ALUOp    = 2'b00;
    
    case(opcode)
        // R-Type Instructions
        7'b0110011: begin

            RegWrite = 1'b1;
            ALUSrc   = 1'b0;
            ALUOp    = 2'b10;

        end
        // I-Type Arithmetic Instructions
        7'b0010011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ALUOp    = 2'b10;
            

        end
        // Load Instructions
        7'b0000011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            MemRead  = 1'b1;
            MemToReg = 1'b1;
            ALUOp    = 2'b00;
           

        end
      // Store Instructions
        7'b0100011: begin

            ALUSrc   = 1'b1;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
           

        end
        // Branch Instructions
        7'b1100011: begin

            Branch = 1'b1;
            ALUOp  = 2'b01;
            

        end
    endcase

end
endmodule