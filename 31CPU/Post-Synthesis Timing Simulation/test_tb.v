`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/01 14:41:39
// Design Name: 
// Module Name: test_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module test_tb;
reg clk;            //时钟信号
reg rst;            //复位信号
wire [31:0] inst;   //要执行的指令
wire [31:0] pc;     //下一条指令的地址
wire clk_cpu;
wire [7:0] o_seg;//输出内容
wire [7:0] o_sel; //片选信号
initial 
begin
    clk = 1'b0;
    rst = 1'b1;
    #50 rst = 1'b0;
end

always  #50 clk = ~clk;

sccomp_dataflow sc_inst(
    .clk_in(clk),
    .reset(rst),
    .o_seg(o_seg),//输出指令
    .o_sel(o_sel)//执行地址
);

endmodule
