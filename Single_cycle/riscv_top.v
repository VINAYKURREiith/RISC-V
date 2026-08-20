module riscv_top(

    input wire clk,
    input wire rst

);

    //==========================
    // Program Counter Signals
    //==========================
    wire [63:0] pc;
    wire [63:0] pc_next;
    wire [63:0] pc_plus4;
    wire [63:0] branch_target;

    //==========================
    // Instruction Memory
    //==========================
    wire [31:0] instruction;

    //==========================
    // Instruction Fields
    //==========================
    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire       funct7;

    //==========================
    // Register File
    //==========================
    wire [63:0] read_data1;
    wire [63:0] read_data2;
    wire [63:0] write_back_data;

    //==========================
    // Immediate Generator
    //==========================
    wire [63:0] imm_out;
   


    //==========================
    // Control Signals
    //==========================
    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire Branch;
    wire [1:0] ALUOp;

    //==========================
    // ALU Control
    //==========================
    wire [3:0] alu_control_signal;

    //==========================
    // ALU
    //==========================
    wire [63:0] alu_operand_b;
    wire [63:0] alu_result;
    wire zero;

    //==========================
    // Data Memory
    //==========================
    wire [63:0] memory_data;

    //==========================
    // Branch
    //==========================
    wire BranchTaken;

    //----------------------------------------------------------
    // Instruction Decode
    //----------------------------------------------------------

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[30];

    //----------------------------------------------------------
    // PC + 4
    //----------------------------------------------------------

    assign pc_plus4 = pc + 64'd4;

    //----------------------------------------------------------
    // Branch Target
    //----------------------------------------------------------

    assign branch_target = pc + imm_out;

    //----------------------------------------------------------
    // Branch Decision
    //----------------------------------------------------------

    assign BranchTaken = Branch & zero;

    //----------------------------------------------------------
    // Program Counter
    //----------------------------------------------------------

    program_counter PC(

        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)

    );

    //----------------------------------------------------------
    // Instruction Memory
    //----------------------------------------------------------

    instruction_memory IM(

        .addr(pc),
        .instruction(instruction)

    );

    //----------------------------------------------------------
    // Control Unit
    //----------------------------------------------------------

    control_unit CU(

        .opcode(opcode),

        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
        

    );

    //----------------------------------------------------------
    // Register File
    //----------------------------------------------------------

    register_file RF(

        .clk(clk),
        .rst(rst),

        .RegWrite(RegWrite),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .write_data(write_back_data),

        .read_data1(read_data1),
        .read_data2(read_data2)

    );

    //----------------------------------------------------------
    // Immediate Generator
    //----------------------------------------------------------

    immediate_generator IMM(

        .instruction(instruction),
        .imm_out(imm_out)

    );

    //----------------------------------------------------------
    // ALU Control
    //----------------------------------------------------------

    alu_control ALUCTRL(

        .alu_op(ALUOp),
        .op_code(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .alu_control(alu_control_signal)

    );

    //----------------------------------------------------------
    // ALU Source MUX
    //----------------------------------------------------------

    alu_src_mux SRCMUX(

        .ALUSrc(ALUSrc),
        .reg_data(read_data2),
        .imm_data(imm_out),

        .alu_operand(alu_operand_b)

    );

    //----------------------------------------------------------
    // ALU
    //----------------------------------------------------------

    alu ALU(

        .operand_a(read_data1),
        .operand_b(alu_operand_b),

        .alu_control(alu_control_signal),

        .alu_result(alu_result),
        .zero(zero)

    );

    //----------------------------------------------------------
    // Data Memory
    //----------------------------------------------------------

    data_memory DM(

        .clk(clk),

        .MemRead(MemRead),
        .MemWrite(MemWrite),

        .address(alu_result),
        .write_data(read_data2),

        .read_data(memory_data)

    );

    //----------------------------------------------------------
    // Write Back MUX
    //----------------------------------------------------------

    write_back_mux WBMUX(

        .MemToReg(MemToReg),

        .alu_result(alu_result),
        .memory_data(memory_data),

        .write_back_data(write_back_data)

    );

    //----------------------------------------------------------
    // PC MUX
    //----------------------------------------------------------

    pc_mux PCMUX(

        .BranchTaken(BranchTaken),

        .pc_plus4(pc_plus4),
        .branch_target(branch_target),

        .pc_next(pc_next)

    );

endmodule