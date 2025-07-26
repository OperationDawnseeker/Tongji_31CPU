`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/30 14:13:16
// Design Name: 
// Module Name: IMEM
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

/*IMEM 为指令存储器模块，通过调用 ROM 的 IP 核实现。*/

module IMEM( 
    input   [10:0]  addr,   // 指令地址 
    output  [31:0]  data    // 所取指令 
    ); 
     
    dist_mem_gen_0 IM( 
        .a(addr), 
        .spo(data) 
    ); 
     
endmodule
