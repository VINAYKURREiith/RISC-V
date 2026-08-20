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

    #300;

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

endmodule