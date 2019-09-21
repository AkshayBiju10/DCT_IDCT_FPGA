`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2018 03:13:37
// Design Name: 
// Module Name: idct_seq
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
    
    
module idctsim(clk,clr,enable,out,sw,
               I0,I1,I2,I3,I4,I5,I6,I7,
               A0,A1,A2,A3,A4,A5,A6,A7,
               B0,B1,B2,B3,B4,B5,B6,B7,
               C0,C1,C2,C3,C4,C5,C6,C7,
               D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,
               E0,E1,E2,E3,E4,E5,E6,E7,
               F0,F1,F2,F3,F4,F5,F6,F7,
               G0,G1,G2,G3,G4,G5,G6,G7,
               H0,H1,H2,H3,H4,H5,H6,H7
               );
//100 MHz CLOCK CONNECTED TO W5
input clk;

//Push Button Inputs     
input clr;
input enable; 
input out;
                       
// Slide Switch Inputs
input signed [15:0] sw; 
                     
// LED Outputs                    
output reg signed [21:0] A0,A1,A2,A3,A4,A5,A6,A7;
output reg signed [22:0] B0,B1,B2,B3,B4,B5,B6,B7;
output reg signed [23:0] C0,C1,C2,C3,C4,C5,C6,C7;    
output reg signed [34:0] D0,D1,D2,D3,D4,D5,D6,D7,D8,D9;
output reg signed [35:0] E0,E1,E2,E3,E4,E5,E6,E7;
output reg signed [36:0] F0,F1,F2,F3,F4,F5,F6,F7;        
output reg signed [37:0] G0,G1,G2,G3,G4,G5,G6,G7;
output reg signed [38:0] H0,H1,H2,H3,H4,H5,H6,H7;
wire signed [10:0] c4 = 11'b000_10110101,  //0.7071
                   c6 = 11'b000_01100001,  //0.3826
                   c2 = 11'b000_11101100;  //0.921875
            
wire signed [13:0] 
s0 = 14'b00_010110101000,//0.3535533906
s3 = 14'b00_010000010100,//0.2548977895 
s6 = 14'b00_010001010100,//0.2705980501
s7 = 14'b00_010011001111,//0.3006724435
s4 = 14'b00_010110101000,//0.3535533906
s1 = 14'b00_011100110011,//0.4499881115
s2 = 14'b00_101001110011,//0.6532814824
s5 = 14'b01_010010000000;//1.2814577239             
     
output reg signed [7:0] I0,
                        I1,
                        I2,
                        I3,
                        I4,
                        I5,
                        I6,
                        I7;
        

always @(posedge clk) begin
    if ( (enable == 1)) begin              
    case(sw[15:8])         
    0:I0[7:0] <= sw[7:0];
    1:I1[7:0] <= sw[7:0];
    2:I2[7:0] <= sw[7:0];
    4:I3[7:0] <= sw[7:0];
    8:I4[7:0] <= sw[7:0];
   16:I5[7:0] <= sw[7:0];
   32:I6[7:0] <= sw[7:0];
   64:I7[7:0] <= sw[7:0];
  128:  begin
       //STAGE-1
       A0 <= I0*s0;
       A1 <= I1*s1;
       A2 <= I2*s2;
       A3 <= I3*s3;
       A4 <= I4*s4;
       A5 <= I5*s5;
       A6 <= I6*s6;
       A7 <= I7*s7;
       //STAGE-2
       B0 <= A0 + A4;
       B4 <= A0 - A4;
       B2 <= A2 - A6;
       B6 <= A2 + A6;
       B1 <= A1 + A7;
       B5 <= A5 - A3;
       B3 <= A5 + A3;
       B7 <= A1 - A7;       
       //STAGE-3
       C0 <= B0;
       C4 <= B4;
       C2 <= B2;
       C6 <= B6;
       C1 <= B5 - B1;
       C5 <= B5 + B1;
       C3 <= B3;     
       C7 <= B7;     
       //STAGE-4
       D0 <= {C0,8'b0}; if (C0[23]) D0[34:32] <= 3'b111;
       D4 <= {C4,8'b0}; if (C4[23]) D4[34:32] <= 3'b111;
       D2 <= {C2,8'b0}; if (C2[23]) D2[34:32] <= 3'b111; 
       D6 <= C6 * c4;  
       D1 <= C1 * c4;  
       D5 <= {C5,8'b0}; if (C5[23]) D5[34:32] <= 3'b111;
       D3 <= C3 * c6;
       D7 <= C7 * c6;                  
       D8 <= C3 * c2;
       D9 <= C7 * c2;
       //STAGE-5
       E0 <= D0;
       E4 <= D4;
       E2 <= D2;
       E6 <= D6;
       E1 <= D1;
       E5 <= D5;
       E3 <= D9 - D3;
       E7 <= D8 + D7;
       //STAGE-6
       F0 <= E0;
       F4 <= E4;
       F2 <= E2 - E6;
       F6 <= E6;
       F1 <= E1;
       F5 <= E5 - E7;
       F3 <= E3;
       F7 <= E7 - E1;
       //STAGE-7
       G0 <= F0 + F6;
       G4 <= F4 + F2;
       G2 <= F4 - F2;
       G6 <= F0 - F6;
       G1 <= F1 + F3;
       G5 <= F5;
       G3 <= F3;
       G7 <= F7;
       end
       endcase
       end

else if ((out == 1)) begin           
       H0 <= G0 + G7;
       H1 <= G4 + G3;
       H2 <= G2 + G5; 
       H3 <= G6 + G1;
       H4 <= G6 - G1;
       H5 <= G2 - G5;
       H6 <= G4 - G3;
       H7 <= G0 - G7;
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
       D0 <= 0;
       D1 <= 0;
       D2 <= 0;
       D3 <= 0;
       D4 <= 0;
       D5 <= 0;
       D6 <= 0;
       D7 <= 0;
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
       H0 <= 0;
       H1 <= 0;
       H2 <= 0;
       H3 <= 0;
       H4 <= 0;
       H5 <= 0;
       H6 <= 0;
       H7 <= 0;            
end
end
endmodule
    
