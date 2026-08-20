`timescale 1ns/1ps

module tb_riscv_top;

reg clk;
reg rst;

// Instantiate DUT
riscv_top DUT(
    .clk(clk),
    .rst(rst)
);

//--------------------------------------------------
// Clock Generation
//--------------------------------------------------

always #5 clk = ~clk;

//--------------------------------------------------
// Initialize
//--------------------------------------------------

initial begin

    clk = 0;
    rst = 1;

    #20;

    rst = 0;

end

//--------------------------------------------------
// Waveform Dump
//--------------------------------------------------

initial begin

    $dumpfile("riscv.vcd");
    $dumpvars(0,tb_riscv_top);

end

//--------------------------------------------------
// Simulation End
//--------------------------------------------------

initial begin

    #400;

    $display("\n============================");
    $display("Final Register Values");
    $display("============================");

    $display("x1 = %d",DUT.RF.registers[1]);
    $display("x2 = %d",DUT.RF.registers[2]);
    $display("x3 = %d",DUT.RF.registers[3]);
    $display("x4 = %d",DUT.RF.registers[4]);
    $display("x5 = %d",DUT.RF.registers[5]);
    $display("x6 = %d",DUT.RF.registers[6]);

    $display("\nMemory[0] = %d",DUT.DM.memory[0]);

    $finish;

end

//--------------------------------------------------
// Monitor
//--------------------------------------------------

initial begin

$monitor(
"Time=%0t PC=%d ALU=%d x1=%d x2=%d x3=%d x4=%d",

$time,

DUT.pc,

DUT.alu_result,

DUT.RF.registers[1],

DUT.RF.registers[2],

DUT.RF.registers[3],

DUT.RF.registers[4]

);

end
always @(posedge clk) begin
    $display("\n==================================================");
    $display("Time = %0t", $time);

    $display("PC = %0d", DUT.pc);
    $display("Instruction = %h", DUT.if_id_instruction);

    $display("ID/EX");
    $display(" rd=%0d RegWrite=%b MemRead=%b MemWrite=%b MemToReg=%b",
             DUT.id_ex_rd,
             DUT.id_ex_RegWrite,
             DUT.id_ex_MemRead,
             DUT.id_ex_MemWrite,
             DUT.id_ex_MemToReg);

    $display("EX/MEM");
    $display(" rd=%0d ALU=%0d MemRead=%b MemWrite=%b",
             DUT.ex_mem_rd,
             DUT.ex_mem_alu_result,
             DUT.ex_mem_MemRead,
             DUT.ex_mem_MemWrite);

    $display("MEM/WB");
    $display(" rd=%0d MemData=%0d ALU=%0d RegWrite=%b MemToReg=%b",
             DUT.mem_wb_rd,
             DUT.mem_wb_memory_data,
             DUT.mem_wb_alu_result,
             DUT.mem_wb_RegWrite,
             DUT.mem_wb_MemToReg);

    $display("Registers");
    $display(" x3=%0d x4=%0d",
             DUT.RF.registers[3],
             DUT.RF.registers[4]);
end

endmodule