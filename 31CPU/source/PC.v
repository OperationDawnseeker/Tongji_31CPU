`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/30 14:12:31
// Design Name: 
// Module Name: PC
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

//PCreg 取指

module PC( 
    input               clk,    // 时钟信号 
    input               ena,    // 使能信号 
    input               rst,    // 复位信号 
    input      [31:0]   PC_in,  // 输入的 PC 数据 
    output reg [31:0]   PC_out  // 输出的 PC 数据 
    ); 
     
    always@(negedge clk or posedge rst) 
    begin 
        if(rst) 
        begin 
            PC_out <= 32'h00400000; 
        end 
        else if(ena) 
        begin 
            PC_out <= PC_in; 
        end 
    end 
     

endmodule 
