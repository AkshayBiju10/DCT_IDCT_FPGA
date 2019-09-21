`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2018 01:24:14
// Design Name: 
// Module Name: dctsim
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


module dctsim(clk,clr,enable,out,sw, 
I0,I1,I2,I3,I4,I5,I6,I7,
A0,A1,A2,A3,A4,A5,A6,A7,
B0,B1,B2,B3,B4,B5,B6,B7,
C0,C1,C2,C3,C4,C5,C6,C7,C8,
D0,D1,D2,D3,D4,D5,D6,D7,D8,
E0,E1,E2,E3,E4,E5,E6,E7,
F0,F1,F2,F3,F4,F5,F6,F7,
G0,G1,G2,G3,G4,G5,G6,G7
);

//100 MHz CLOCK CONNECTED TO W5   
input clk;
//Push Button Inputs     
input clr;     
input enable;  
input out;                      
// Slide Switch Inputs
input signed [15:0] sw; 
                
output reg signed [7:0] I0,I1,I2,I3,I4,I5,I6,I7;            
output reg signed [8:0] A0,A1,A2,A3,A4,A5,A6,A7;
output reg signed [9:0] B0,B1,B2,B3,B4,B5,B6,B7;
output reg signed [10:0] C0,C1,C2,C3,C4,C5,C6,C7,C8;    
output reg signed [21:0] D0,D1,D2,D3,D4,D5,D6,D7,D8;
output reg signed [22:0] E0,E1,E2,E3,E4,E5,E6,E7;
output reg signed [23:0] F0,F1,F2,F3,F4,F5,F6,F7;
output reg signed [39:0] G0,G1,G2,G3,G4,G5,G6,G7;

wire signed [10:0] m1 = 11'b000_10110101,  //0.7071
                   m2 = 11'b000_01100001,  //0.3826
                   m3 = 11'b000_10001010,  //0.5412
                   m4 = 11'b001_01001110;  //1.3066
                       
wire signed [15:0] s0 = 16'b0000_010110101000,//0.353606789 
                   s4 = 16'b0000_010110101000,//0.353515625
                   s6 = 16'b0000_101001110011,//0.653076171875
                   s2 = 16'b0000_010001010100,//0.2705078125
                   s3 = 16'b0000_010011001111,//0.300537109375
                   s5 = 16'b0000_011100110011,//0.449951171875
                   s7 = 16'b0001_010010000000,//1.28125
                   s1 = 16'b0000_010000010100;//0.2548828125

always @(posedge clk) begin

if ( (enable == 1))  
    begin
    case(sw[15:8]) 

        0:I0 <= sw[7:0];
        1:I1 <= sw[7:0];
        2:I2 <= sw[7:0];
        4:I3 <= sw[7:0];
        8:I4 <= sw[7:0];
        16:I5 <= sw[7:0];
        32:I6 <= sw[7:0];
        64:I7 <= sw[7:0];
       128:  
            begin
                //STAGE-1
                A0 <= I0 + I7;
                A1 <= I1 + I6;
                A2 <= I2 + I5;
                A3 <= I3 + I4;
                A4 <= I3 - I4;
                A5 <= I2 - I5;
                A6 <= I1 - I6;
                A7 <= I0 - I7;
                //STAGE-2
                B0 <= A0 + A3;
                B1 <= A1 + A2;
                B2 <= A1 - A2;
                B3 <= A0 - A3;
                B4 <= A4 + A5;
                B5 <= A5 + A6;
                B6 <= A6 + A7;
                B7 <= A7;
                //STAGE-3
                C0 <= B0 + B1;
                C1 <= B0 - B1;
                C2 <= B2 + B3;
                C3 <= B3;
                C4 <= B4;
                C5 <= B5;
                C6 <= B6;
                C7 <= B7;
                C8 <= B4 - B6;
                //STAGE-4
                D0 <= {C0,8'b0}; if (C0[10]) D0[21:19] <= 3'b111;
                D1 <= {C1,8'b0}; if (C1[10]) D1[21:19] <= 3'b111; 
                D2 <= C2 * m1;
                D3 <= {C3,8'b0}; if (C3[10]) D3[21:19] <= 3'b111;
                D4 <= C4 * m3;
                D5 <= C5 * m1;
                D6 <= C6 * m4;
                D7 <= {C7,8'b0}; if (C7[10]) D7[21:19] <= 3'b111;
                D8 <= C8 * m2;
                //STAGE-5
                E0 <= D0;
                E1 <= D1;
                E2 <= D3 - D2;
                E3 <= D3 + D2;
                E4 <= D4 + D8;
                E5 <= D7 - D5; 
                E6 <= D6 + D8;
                E7 <= D5 + D7; 
                //STAGE-6
                F0 <= E0;
                F1 <= E1;
                F2 <= E2;
                F3 <= E3;
                F4 <= E5 - E4; 
                F5 <= E5 + E4;
                F6 <= E7 - E6;
                F7 <= E7 + E6;               
                end
                endcase
                end
                //OUTPUTS
            else if ((out == 1)) begin
                G0 <= F0 * s0;
                G4 <= F1 * s4;
                G6 <= F2 * s6;
                G2 <= F3 * s2;
                G3 <= F4 * s3;
                G5 <= F5 * s5;
                G7 <= F6 * s7;
                G1 <= F7 * s1;         
                end 

    else if ((clr == 1)) begin
        
        I0 <= 0;
        I1 <= 0;
        I2 <= 0;
        I3 <= 0;
        I4 <= 0;
        I5 <= 0;
        I6 <= 0;
        I7 <= 0;
        A0 <= 0;
        A1 <= 0;
        A2 <= 0;
        A3 <= 0;
        A4 <= 0;
        A5 <= 0;
        A6 <= 0;
        A7 <= 0;
        B0 <= 0;
        B1 <= 0;
        B2 <= 0;
        B3 <= 0;
        B4 <= 0;
        B5 <= 0;
        B6 <= 0;
        B7 <= 0;
        C0 <= 0;
        C1 <= 0;
        C2 <= 0;
        C3 <= 0;
        C4 <= 0;
        C5 <= 0;
        C6 <= 0;
        C7 <= 0;
        C8 <= 0;
        D0 <= 0;
        D1 <= 0;
        D2 <= 0;
        D3 <= 0;
        D4 <= 0;
        D5 <= 0;
        D6 <= 0;
        D7 <= 0;
        D8 <= 0;
        E0 <= 0;
        E1 <= 0;
        E2 <= 0;
        E3 <= 0;
        E4 <= 0;
        E5 <= 0;
        E6 <= 0;
        E7 <= 0;
        F0 <= 0;
        F1 <= 0;
        F2 <= 0;
        F3 <= 0;
        F4 <= 0;
        F5 <= 0;
        F6 <= 0;
        F7 <= 0;
        G0 <= 0;
        G1 <= 0;
        G2 <= 0;
        G3 <= 0;
        G4 <= 0;
        G5 <= 0;
        G6 <= 0;
        G7 <= 0;
   end
end
endmodule
