`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/30 14:13:28
// Design Name: 
// Module Name: DMEM
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
 
 /*
       DMEM 为数据存储器模块。其输入信号有时钟信号、使能信号、写有效信
号与读有效信号。此外，还有地址以及写入的数据作为模块输入，以及读出的数
据作为模块的输出。
 */

module DMEM( 
   input           clk,        // 时钟信号 
   input           ena,        // 使能信号 
   input           DMEM_W,     // 写有效信号 
   input           DMEM_R,     // 读有效信号 
   input   [10:0]  DM_addr,    // 地址 
   input   [31:0]  DM_wdata,   // 写入数据 
   output  [31:0]  DM_rdata    // 读出数据 
   ); 
    
   reg [31:0] DM [31:0]; //2048个32位存储单元
    
   always@(posedge clk) 
   begin 
       if(ena && DMEM_W) 
       begin
             DM[DM_addr] <= DM_wdata; 
       end 
   end 
    
   assign DM_rdata = (ena && DMEM_R) ? DM[DM_addr] : 32'bz; //随时可以读取（异步）
    

endmodule 
