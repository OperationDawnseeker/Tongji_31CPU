`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/30 18:48:46
// Design Name: 
// Module Name: CPU
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
module cpu( 
    input           clk_in,     // 时钟信号 
    input           ena,        // 使能信号 
    input           rst,        // 复位信号 
    input [31:0]    imem,       // 当前读到的指令 
    input [31:0]    dmem_out,   // DMEM 读出的数据 
    output [31:0]   dmem_in,    // DMEM 写入的数据 
    output [31:0]   dmem_addr,  // DMEM 读/写地址 
    output          dmem_w,     // DMEM 写信号 
    output          dmem_r,     // DMEM 读信号 
    output [31:0]   PC          // 程序计数器 
    ); 
     
    // R-type 
    wire Add    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100000) ? 1'b1 : 1'b0; 
    wire Addu   = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100001) ? 1'b1 : 1'b0; 
    wire Sub    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100010) ? 1'b1 : 1'b0; 
    wire Subu   = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100011) ? 1'b1 : 1'b0; 
    wire And    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100100) ? 1'b1 : 1'b0; 
    wire Or     = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100101) ? 1'b1 : 1'b0; 
    wire Xor    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100110) ? 1'b1 : 1'b0; 
    wire Nor    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b100111) ? 1'b1 : 1'b0; 
    wire Slt    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b101010) ? 1'b1 : 1'b0; 
    wire Sltu   = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b101011) ? 1'b1 : 1'b0; 
    wire Sll    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b000000) ? 1'b1 : 1'b0; 
    wire Srl    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b000010) ? 1'b1 : 1'b0; 
    wire Sra    = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b000011) ? 1'b1 : 1'b0; 
    wire Sllv   = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b000100) ? 1'b1 : 1'b0; 
    wire Srlv   = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b000110) ? 1'b1 : 1'b0; 
    wire Srav   = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b000111) ? 1'b1 : 1'b0; 
    wire Jr     = (imem[31:26] == 6'b000000 && imem[5:0] == 6'b001000) ? 1'b1 : 1'b0; 
    wire Rtype  = (imem[31:26] == 6'b000000); 
         
    // I-type 
    wire Addi   = (imem[31:26] == 6'b001000) ? 1'b1 : 1'b0; 
    wire Addiu  = (imem[31:26] == 6'b001001) ? 1'b1 : 1'b0; 
    wire Andi   = (imem[31:26] == 6'b001100) ? 1'b1 : 1'b0; 
    wire Ori    = (imem[31:26] == 6'b001101) ? 1'b1 : 1'b0; 
    wire Xori   = (imem[31:26] == 6'b001110) ? 1'b1 : 1'b0; 
    wire Lw     = (imem[31:26] == 6'b100011) ? 1'b1 : 1'b0; 
    wire Sw     = (imem[31:26] == 6'b101011) ? 1'b1 : 1'b0; 
    wire Beq    = (imem[31:26] == 6'b000100) ? 1'b1 : 1'b0; 
    wire Bne    = (imem[31:26] == 6'b000101) ? 1'b1 : 1'b0; 
    wire Slti   = (imem[31:26] == 6'b001010) ? 1'b1 : 1'b0; 
    wire Sltiu  = (imem[31:26] == 6'b001011) ? 1'b1 : 1'b0; 
    wire Lui    = (imem[31:26] == 6'b001111) ? 1'b1 : 1'b0; 
    wire Itype  = Addi || Addiu || Andi || Ori || Xori || Lw || Sw || Beq || Bne || Slti || Sltiu || Lui; 
     
    // J-type 
    wire J      = (imem[31:26] == 6'b000010) ? 1'b1 : 1'b0; 
    wire Jal    = (imem[31:26] == 6'b000011) ? 1'b1 : 1'b0; 
    wire Jtype  = J || Jal;          
    
    // PC 
    wire [31:0] PC_in; 
    wire [31:0] NPC = PC + 32'd4; 
     
    // ALU 
    wire [3:0] ALUC; 
    wire zero, carry, negative, overflow; 
    wire [31:0] A; 
    wire [31:0] B; 
    wire [31:0] Y; 
     
    // Regfile 
    wire reg_wena; 
    wire [4:0] rsc; 
    wire [4:0] rtc; 
    wire [4:0] rdc; 
    wire [31:0] rs; 
    wire [31:0] rt; 
    wire [31:0] rd; 
     
    // MUX 
    wire [1:0] mux_pc; 
    wire [1:0] mux_a; 
    wire [1:0] mux_b; 
     
    // Ext 
    wire [31:0] ext5; 
    wire        extb; 
    wire [31:0] ext16; 
    wire [31:0] ext18; 
    wire [31:0] add; //ext18 + npc
    wire [31:0] concat; // ||
     
    // ALU 
    assign ALUC[3] = Slt || Sltu || Sll || Srl || Sra || Sllv || Srlv || Srav || Slti || Sltiu || Lui; 
    assign ALUC[2] = And || Or || Xor || Nor || Sra || Srav || Andi || Ori || Xori || Lui; 
    assign ALUC[1] = Sub || Subu || Xor || Nor || Sll || Srl || Sllv || Srlv || Xori || Beq || Bne; 
    assign ALUC[0] = Addu || Subu || Or || Nor || Sltu || Srl || Srlv || Addiu || Ori || Beq || Bne || Sltiu || Lui;    
      
    // MUX 
    assign mux_pc[1] = Jr|| J || Jal; //jr 10; j jal 11
    assign mux_pc[0] = (Beq && zero) || (Bne && ~zero)|| J || Jal; //beq bne 01 ; j jal 11
    assign mux_a[1]  = Jal; //jal 10 
    assign mux_a[0]  = Sll || Srl || Sra || Sllv || Srlv || Srav;  // 01
    assign mux_b[1]  = Jal; // jal 10
    assign mux_b[0]  = Addi || Addiu || Andi || Ori || Xori || Lw || Sw || Slti || Sltiu || Lui; // 01
    
    // Regfile 
    assign rsc = imem[25:21]; 
    assign rtc = imem[20:16]; 
    assign rdc = Rtype ? imem[15:11] : (Itype ? imem[20:16] : 5'd31); //目标寄存器地址
    assign rd = Lw ? dmem_out : Y; //存入寄存器的数据
    assign reg_wena = !(Jr || Sw || Beq || Bne || J); //寄存器堆的使能端
    
    // DMEM 
    assign dmem_w = Sw; 
    assign dmem_r = Lw; 
    assign dmem_addr = (Lw || Sw) ? Y : 32'bz; 
    assign dmem_in = rt; 
     
    // Ext 和其他模块 
    assign ext5  = Sllv || Srlv || Srav ? {27'b0, rs[4:0] }: {  27'b0, imem[10:6] }; //rs或sa
    assign extb  = ( Andi || Ori || Xori || Lui) ? 1'b0 : imem[15]; //符号扩展or零扩展
    assign ext16 = { {16 { extb }}, imem[15:0] }; 
    assign ext18 = { {14{ imem[15] }}, imem[15:0], 2'b0 }; 
    assign add = ext18 + NPC; 
    assign concat   = { PC[31:28], imem[25:0], 2'b0 }; //j jal
    
     
    MUX4 MUX_PC( 
        .d0(NPC), 
        .d1(add), 
        .d2(rs), 
        .d3(concat), 
        .s(mux_pc), 
        .y(PC_in) 
        ); 
     
    MUX4 MUX_A( 
        .d0(rs),
        .d1(ext5), 
        .d2(PC), 
        .d3(32'b0), 
        .s(mux_a), 
        .y(A) 
        ); 
     
    MUX4 MUX_B( 
        .d0(rt), 
        .d1(ext16), 
        .d2(32'd4), 
        .d3(32'b0), 
        .s(mux_b), 
        .y(B) 
        ); 
     
    PC pc( 
        .clk(clk_in), 
        .ena(ena), 
        .rst(rst), 
        .PC_in(PC_in), 
        .PC_out(PC) 
        ); 
     
    ALU alu( 
        .A(A), 
        .B(B), 
        .Y(Y), 
        .ALUC(ALUC), 
        .zero(zero), 
        .carry(carry), 
        .negative(negative), 
        .overflow(overflow) 
        ); 
     
    regfile cpu_ref( 
        .ena(ena), 
        .rst(rst), 
        .clk(clk_in), 
        .w_ena(reg_wena), 
        .Rdc(rdc), 
        .Rsc(rsc), 
        .Rtc(rtc),
        .Rd(rd), 
        .Rs(rs), 
        .Rt(rt) 
        ); 
     

endmodule
