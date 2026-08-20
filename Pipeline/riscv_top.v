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
    // Forwarding Control Signals
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

// Forwarded Data
    wire [63:0] forwarded_operand_a;
    wire [63:0] forwarded_operand_b;

    //==========================
    // Instruction Memory
    //==========================
    wire [31:0] instruction;
    wire [63:0] if_id_pc;
    wire [31:0] if_id_instruction;

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
// ID/EX Register Signals
//==========================
//==========================
// EX/MEM Register Signals
//==========================

   wire [63:0] ex_mem_alu_result;
   wire [63:0] ex_mem_branch_target;
   wire [63:0] ex_mem_read_data2;

   wire ex_mem_zero;
   wire [4:0] id_ex_rs1;
   wire [4:0] id_ex_rs2;

   wire [4:0] ex_mem_rd;

   wire ex_mem_RegWrite;
   wire ex_mem_MemRead;
   wire ex_mem_MemWrite;
   wire ex_mem_MemToReg;
   wire ex_mem_Branch;

   wire [63:0] id_ex_pc;
   wire [63:0] id_ex_read_data1;
   wire [63:0] id_ex_read_data2; 
   wire [63:0] id_ex_imm;

   wire [4:0] id_ex_rd;
   wire [2:0] id_ex_funct3;
   wire       id_ex_funct7;
   wire [6:0] id_ex_opcode;

   wire id_ex_RegWrite;
   wire id_ex_ALUSrc;
   wire id_ex_MemRead;
   wire id_ex_MemWrite;
   wire id_ex_MemToReg;
   wire id_ex_Branch;
   wire [1:0] id_ex_ALUOp;
   


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
// MEM/WB Register Signals
//==========================

   wire [63:0] mem_wb_memory_data;
   wire [63:0] mem_wb_alu_result;

   wire [4:0] mem_wb_rd;

   wire mem_wb_RegWrite;
   wire mem_wb_MemToReg;

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
    assign opcode = if_id_instruction[6:0];

    assign rd  = if_id_instruction[11:7];
    assign rs1 = if_id_instruction[19:15];
    assign rs2 = if_id_instruction[24:20];

    assign funct3 = if_id_instruction[14:12];
    assign funct7 = if_id_instruction[30];



    //----------------------------------------------------------
    // PC + 4
    //----------------------------------------------------------

    assign pc_plus4 = pc + 64'd4;

    //----------------------------------------------------------
    // Branch Target
    //----------------------------------------------------------

    assign branch_target = id_ex_pc + id_ex_imm;

    //----------------------------------------------------------
    // Branch Decision
    //----------------------------------------------------------

    assign BranchTaken = ex_mem_Branch & ex_mem_zero;

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
    if_id_register IF_ID(

        .clk(clk),
        .rst(rst),

        .pc_in(pc),
        .instruction_in(instruction),

        .pc_out(if_id_pc),
        .instruction_out(if_id_instruction)

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

       .RegWrite(mem_wb_RegWrite),

       .rs1(rs1),
       .rs2(rs2),
       .rd(mem_wb_rd),

       .write_data(write_back_data),

       .read_data1(read_data1),
       .read_data2(read_data2)

    );



    //----------------------------------------------------------
    // Immediate Generator
    //----------------------------------------------------------

    immediate_generator IMM(

        .instruction(if_id_instruction),
        .imm_out(imm_out)

    );

    //----------------------------------------------------------
    // ALU Control
    //----------------------------------------------------------
    id_ex_register ID_EX(

    .clk(clk),
    .rst(rst),

    .pc_in(if_id_pc),
    .read_data1_in(read_data1),
    .read_data2_in(read_data2),
    .imm_in(imm_out),
    .rs1_in(rs1),
    .rs2_in(rs2),

    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),

    .rd_in(rd),
    .funct3_in(funct3),
    .funct7_in(funct7),
    .opcode_in(opcode),

    .RegWrite_in(RegWrite),
    .ALUSrc_in(ALUSrc),
    .MemRead_in(MemRead),
    .MemWrite_in(MemWrite),
    .MemToReg_in(MemToReg),
    .Branch_in(Branch),
    .ALUOp_in(ALUOp),

    .pc_out(id_ex_pc),
    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),
    .imm_out(id_ex_imm),

    .rd_out(id_ex_rd),
    .funct3_out(id_ex_funct3),
    .funct7_out(id_ex_funct7),
    .opcode_out(id_ex_opcode),

    .RegWrite_out(id_ex_RegWrite),
    .ALUSrc_out(id_ex_ALUSrc),
    .MemRead_out(id_ex_MemRead),
    .MemWrite_out(id_ex_MemWrite),
    .MemToReg_out(id_ex_MemToReg),
    .Branch_out(id_ex_Branch),
    .ALUOp_out(id_ex_ALUOp)

);

    alu_control ALUCTRL(

        .alu_op(id_ex_ALUOp),
        .op_code(id_ex_opcode),
        .funct3(id_ex_funct3),
        .funct7(id_ex_funct7),

        .alu_control(alu_control_signal)

    );

    //----------------------------------------------------------
    // ALU Source MUX
    //----------------------------------------------------------

    alu_src_mux SRCMUX(

        .ALUSrc(id_ex_ALUSrc),
        .reg_data(forwarded_operand_b),
        .imm_data(id_ex_imm),

        .alu_operand(alu_operand_b)

    );

    //----------------------------------------------------------
    // ALU
    //----------------------------------------------------------
   forwarding_unit FORWARDING(

    .ID_EX_rs1(id_ex_rs1),
    .ID_EX_rs2(id_ex_rs2),

    .EX_MEM_rd(ex_mem_rd),
    .EX_MEM_RegWrite(ex_mem_RegWrite),

    .MEM_WB_rd(mem_wb_rd),
    .MEM_WB_RegWrite(mem_wb_RegWrite),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)

);
    forward_mux FORWARD_MUX_A(

    .Forward(ForwardA),

    .reg_data(id_ex_read_data1),

    .ex_mem_data(ex_mem_alu_result),

    .mem_wb_data(write_back_data),

    .forward_data(forwarded_operand_a)

);
    forward_mux FORWARD_MUX_B(

    .Forward(ForwardB),

    .reg_data(id_ex_read_data2),

    .ex_mem_data(ex_mem_alu_result),

    .mem_wb_data(write_back_data),

    .forward_data(forwarded_operand_b)

);
    alu ALU(

        .operand_a(forwarded_operand_a),
        .operand_b(alu_operand_b),

        .alu_control(alu_control_signal),

        .alu_result(alu_result),
        .zero(zero)

    );
    ex_mem_register EX_MEM(

    .clk(clk),
    .rst(rst),

    .alu_result_in(alu_result),
    .branch_target_in(branch_target),
    .read_data2_in(id_ex_read_data2),

    .zero_in(zero),

    .rd_in(id_ex_rd),

    .RegWrite_in(id_ex_RegWrite),
    .MemRead_in(id_ex_MemRead),
    .MemWrite_in(id_ex_MemWrite),
    .MemToReg_in(id_ex_MemToReg),
    .Branch_in(id_ex_Branch),

    .alu_result_out(ex_mem_alu_result),
    .branch_target_out(ex_mem_branch_target),
    .read_data2_out(ex_mem_read_data2),

    .zero_out(ex_mem_zero),

    .rd_out(ex_mem_rd),

    .RegWrite_out(ex_mem_RegWrite),
    .MemRead_out(ex_mem_MemRead),
    .MemWrite_out(ex_mem_MemWrite),
    .MemToReg_out(ex_mem_MemToReg),
    .Branch_out(ex_mem_Branch)

);

    //----------------------------------------------------------
    // Data Memory
    //----------------------------------------------------------

    data_memory DM(

        .clk(clk),

        .MemRead(ex_mem_MemRead),
        .MemWrite(ex_mem_MemWrite),

        .address(ex_mem_alu_result),
        .write_data(ex_mem_read_data2),

        .read_data(memory_data)

    );
    mem_wb_register MEM_WB(

    .clk(clk),
    .rst(rst),

    .memory_data_in(memory_data),
    .alu_result_in(ex_mem_alu_result),

    .rd_in(ex_mem_rd),

    .RegWrite_in(ex_mem_RegWrite),
    .MemToReg_in(ex_mem_MemToReg),

    .memory_data_out(mem_wb_memory_data),
    .alu_result_out(mem_wb_alu_result),

    .rd_out(mem_wb_rd),

    .RegWrite_out(mem_wb_RegWrite),
    .MemToReg_out(mem_wb_MemToReg)

);

    //----------------------------------------------------------
    // Write Back MUX
    //----------------------------------------------------------

    write_back_mux WBMUX(

        .MemToReg(mem_wb_MemToReg),

        .alu_result(mem_wb_alu_result),
        .memory_data(mem_wb_memory_data),

        .write_back_data(write_back_data)

    );

    //----------------------------------------------------------
    // PC MUX
    //----------------------------------------------------------

    pc_mux PCMUX(

        .BranchTaken(BranchTaken),

        .pc_plus4(pc_plus4),
        .branch_target(ex_mem_branch_target),

        .pc_next(pc_next)

    );

endmodule