`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 21:57:06
// Design Name: 
// Module Name: tb_dct_seq
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
//THE OUTPUTS OF 1D-DCT ARE GIVEN AS INPUTS IN THIS TESTBENCH
//SIMULATE TILL 1 ms FOR BEST RESULTS
module tb_idct_seq( );
reg clk;
reg clr,enable,out;
reg [15:0] sw;

wire signed [7:0] I0,I1,I2,I3,I4,I5,I6,I7;
wire signed [21:0] A0,A1,A2,A3,A4,A5,A6,A7;
wire signed [22:0] B0,B1,B2,B3,B4,B5,B6,B7;
wire signed [23:0] C0,C1,C2,C3,C4,C5,C6,C7;
wire signed [34:0] D0,D1,D2,D3,D4,D5,D6,D7,D8,D9;
wire signed [35:0] E0,E1,E2,E3,E4,E5,E6,E7;
wire signed [36:0] F0,F1,F2,F3,F4,F5,F6,F7;
wire signed [37:0] G0,G1,G2,G3,G4,G5,G6,G7;
wire signed [38:0] H0,H1,H2,H3,H4,H5,H6,H7;

parameter sf = (2.0)**(-4.0);

//THE FOLLOWING REAL VARIABLES ARE USED TO DISPLAY THE OUTPUTS AS REAL 
//DECIMAL NUMBERS WITH SIGN AND SUFFICIENT DECIMAL PLACES
real input_0,input_1,input_2,input_3,input_4,input_5,input_6,input_7; //TO DISPLAY INPUTS
real output_0,output_1,output_2,output_3,output_4,output_5,output_6,output_7; //TO DISPLAY OUTPUTS
real stage_1_0,stage_1_1,stage_1_2,stage_1_3,stage_1_4,stage_1_5,stage_1_6,stage_1_7; //TO DISPLAY STAGE-1 OUTPUTS
real stage_2_0,stage_2_1,stage_2_2,stage_2_3,stage_2_4,stage_2_5,stage_2_6,stage_2_7; //TO DISPLAY STAGE-2 OUTPUTS
real stage_3_0,stage_3_1,stage_3_2,stage_3_3,stage_3_4,stage_3_5,stage_3_6,stage_3_7; //TO DISPLAY STAGE-3 OUTPUTS
real stage_4_0,stage_4_1,stage_4_2,stage_4_3,stage_4_4,stage_4_5,stage_4_6,stage_4_7,stage_4_8,stage_4_9; //TO DISPLAY STAGE-4 OUTPUTS
real stage_5_0,stage_5_1,stage_5_2,stage_5_3,stage_5_4,stage_5_5,stage_5_6,stage_5_7; //TO DISPLAY STAGE-5 OUTPUTS
real stage_6_0,stage_6_1,stage_6_2,stage_6_3,stage_6_4,stage_6_5,stage_6_6,stage_6_7; //TO DISPLAY STAGE-6 OUTPUTS
real stage_7_0,stage_7_1,stage_7_2,stage_7_3,stage_7_4,stage_7_5,stage_7_6,stage_7_7; //TO DISPLAY STAGE-7 OUTPUTS

idctsim Ids0(clk,clr,enable,out,sw,
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

initial begin
clk <= 0;
sw <= 0;
clr <= 0;
enable <= 0;
out <= 0;
#50;

enable <= 1;
#100; 
//sw <= 16'b000000001101_0000 ;//
sw <= 16'b000000000011_0010;//0
#100;
//sw <= 16'b000000011011_0000;//
sw <= 16'b000000010100_0101;//1
#100;
//sw <= 16'b000000101100_0000;//
sw <= 16'b000000101011_0111;//2
#100;
//sw <= 16'b000001001110_0000;//
sw <= 16'b000001001110_0010;//3
#100;
//sw <= 16'b000010001111_0000;//
sw <= 16'b000010000011_0010;//4
#100;
//sw <= 16'b000100001010_0000;//
sw <= 16'b000100001110_0010;//5
#100;
//sw <= 16'b001000001001_0000;//
sw <= 16'b001000001111_0011;//6
#100;
//sw <= 16'b010000000000_0000;//
sw <= 16'b010000000001_0101;//7
#100;
sw <= 16'b100000000000_0000;
#2000;
enable <= 0;
sw <= 16'b0;
out <= 1;
#300;
out <= 0;
   //OUTPUTS ARE COMPUTED
//CONVERTING INPUTS TO REAL NUMBERS
input_0 <= $itor(I0*sf);
input_1 <= $itor(I1*sf);
input_2 <= $itor(I2*sf);     //$itor CONVERTS INTEGERS TO REAL NUMBERS
input_3 <= $itor(I3*sf);     //MULTIPLYING INPUTS ONCE BY sf (SCALING FACTOR)
input_4 <= $itor(I4*sf);     //AS THERE ARE 4 DECIMAL PLACES IN INPUTS 
input_5 <= $itor(I5*sf);
input_6 <= $itor(I6*sf);
input_7 <= $itor(I7*sf);
//DISPLAYING STAGE-1 OUTPUTS  
stage_1_0 <= $itor(A0*sf*sf*sf*sf);
stage_1_1 <= $itor(A1*sf*sf*sf*sf);
stage_1_2 <= $itor(A2*sf*sf*sf*sf);
stage_1_3 <= $itor(A3*sf*sf*sf*sf);
stage_1_4 <= $itor(A4*sf*sf*sf*sf);
stage_1_5 <= $itor(A5*sf*sf*sf*sf);
stage_1_6 <= $itor(A6*sf*sf*sf*sf);
stage_1_7 <= $itor(A7*sf*sf*sf*sf);
//DISPLAYING STAGE-2 OUTPUTS  
stage_2_0 <= $itor(B0*sf*sf*sf*sf);
stage_2_1 <= $itor(B1*sf*sf*sf*sf);
stage_2_2 <= $itor(B2*sf*sf*sf*sf);
stage_2_3 <= $itor(B3*sf*sf*sf*sf);
stage_2_4 <= $itor(B4*sf*sf*sf*sf);
stage_2_5 <= $itor(B5*sf*sf*sf*sf);
stage_2_6 <= $itor(B6*sf*sf*sf*sf);
stage_2_7 <= $itor(B7*sf*sf*sf*sf);     
//DISPLAYING STAGE-3 OUTPUTS
stage_3_0 <= $itor(C0*sf*sf*sf*sf);
stage_3_1 <= $itor(C1*sf*sf*sf*sf);
stage_3_2 <= $itor(C2*sf*sf*sf*sf);
stage_3_3 <= $itor(C3*sf*sf*sf*sf);
stage_3_4 <= $itor(C4*sf*sf*sf*sf);
stage_3_5 <= $itor(C5*sf*sf*sf*sf);
stage_3_6 <= $itor(C6*sf*sf*sf*sf);
stage_3_7 <= $itor(C7*sf*sf*sf*sf);
//DISPLAYING STAGE-4 OUTPUTS
stage_4_0 <= $itor(D0*sf*sf*sf*sf*sf*sf);
stage_4_1 <= $itor(D1*sf*sf*sf*sf*sf*sf);
stage_4_2 <= $itor(D2*sf*sf*sf*sf*sf*sf);
stage_4_3 <= $itor(D3*sf*sf*sf*sf*sf*sf);
stage_4_4 <= $itor(D4*sf*sf*sf*sf*sf*sf);
stage_4_5 <= $itor(D5*sf*sf*sf*sf*sf*sf);
stage_4_6 <= $itor(D6*sf*sf*sf*sf*sf*sf);
stage_4_7 <= $itor(D7*sf*sf*sf*sf*sf*sf);
stage_4_8 <= $itor(D8*sf*sf*sf*sf*sf*sf);
stage_4_8 <= $itor(D9*sf*sf*sf*sf*sf*sf);     
//DISPLAYING STAGE-5 OUTPUTS
stage_5_0 <= $itor(E0*sf*sf*sf*sf*sf*sf);
stage_5_1 <= $itor(E1*sf*sf*sf*sf*sf*sf);
stage_5_2 <= $itor(E2*sf*sf*sf*sf*sf*sf);
stage_5_3 <= $itor(E3*sf*sf*sf*sf*sf*sf);
stage_5_4 <= $itor(E4*sf*sf*sf*sf*sf*sf);
stage_5_5 <= $itor(E5*sf*sf*sf*sf*sf*sf);
stage_5_6 <= $itor(E6*sf*sf*sf*sf*sf*sf);
stage_5_7 <= $itor(E7*sf*sf*sf*sf*sf*sf);
//DISPLAYING STAGE-6 OUTPUTS
stage_6_0 <= $itor(F0*sf*sf*sf*sf*sf*sf);
stage_6_1 <= $itor(F1*sf*sf*sf*sf*sf*sf);
stage_6_2 <= $itor(F2*sf*sf*sf*sf*sf*sf);
stage_6_3 <= $itor(F3*sf*sf*sf*sf*sf*sf);
stage_6_4 <= $itor(F4*sf*sf*sf*sf*sf*sf);
stage_6_5 <= $itor(F5*sf*sf*sf*sf*sf*sf);
stage_6_6 <= $itor(F6*sf*sf*sf*sf*sf*sf);
stage_6_7 <= $itor(F7*sf*sf*sf*sf*sf*sf);
//DISPLAYING STAGE-7 OUTPUTS
stage_6_0 <= $itor(G0*sf*sf*sf*sf*sf*sf);
stage_6_1 <= $itor(G1*sf*sf*sf*sf*sf*sf);
stage_6_2 <= $itor(G2*sf*sf*sf*sf*sf*sf);
stage_6_3 <= $itor(G3*sf*sf*sf*sf*sf*sf);
stage_6_4 <= $itor(G4*sf*sf*sf*sf*sf*sf);
stage_6_5 <= $itor(G5*sf*sf*sf*sf*sf*sf);
stage_6_6 <= $itor(G6*sf*sf*sf*sf*sf*sf);
stage_6_7 <= $itor(G7*sf*sf*sf*sf*sf*sf);
//CONVERTING OUTPUTS TO REAL NUMBERS
output_0 <= $itor(H0*sf*sf*sf*sf*sf*sf);      //MULTIPLYING OUTPUTS SIX TIMES BY sf 
output_1 <= $itor(H1*sf*sf*sf*sf*sf*sf);      //AS THERE ARE 6*4 = 24 DECIMAL PLACES
output_2 <= $itor(H2*sf*sf*sf*sf*sf*sf);      //IN OUTPUTS
output_3 <= $itor(H3*sf*sf*sf*sf*sf*sf);
output_4 <= $itor(H4*sf*sf*sf*sf*sf*sf);
output_5 <= $itor(H5*sf*sf*sf*sf*sf*sf);
output_6 <= $itor(H6*sf*sf*sf*sf*sf*sf);
output_7 <= $itor(H7*sf*sf*sf*sf*sf*sf);
#800000; //800 microseconds delay for displaying outputs
clr <= 1; //CLEARING ALL INPUTS AND OUTPUTS
#1000; 
input_0 <= $itor(I0*sf);
input_1 <= $itor(I1*sf);
input_2 <= $itor(I2*sf);     //$itor CONVERTS INTEGERS TO REAL NUMBERS
input_3 <= $itor(I3*sf);     //MULTIPLYING INPUTS ONCE BY sf (SCALING FACTOR)
input_4 <= $itor(I4*sf);     //AS THERE ARE 4 DECIMAL PLACES IN INPUTS 
input_5 <= $itor(I5*sf);
input_6 <= $itor(I6*sf);
input_7 <= $itor(I7*sf);
//DISPLAYING STAGE-1 OUTPUTS  
stage_1_0 <= $itor(A0*sf*sf*sf*sf);
stage_1_1 <= $itor(A1*sf*sf*sf*sf);
stage_1_2 <= $itor(A2*sf*sf*sf*sf);
stage_1_3 <= $itor(A3*sf*sf*sf*sf);
stage_1_4 <= $itor(A4*sf*sf*sf*sf);
stage_1_5 <= $itor(A5*sf*sf*sf*sf);
stage_1_6 <= $itor(A6*sf*sf*sf*sf);
stage_1_7 <= $itor(A7*sf*sf*sf*sf);
//DISPLAYING STAGE-2 OUTPUTS  
stage_2_0 <= $itor(B0*sf*sf*sf*sf);
stage_2_1 <= $itor(B1*sf*sf*sf*sf);
stage_2_2 <= $itor(B2*sf*sf*sf*sf);
stage_2_3 <= $itor(B3*sf*sf*sf*sf);
stage_2_4 <= $itor(B4*sf*sf*sf*sf);
stage_2_5 <= $itor(B5*sf*sf*sf*sf);
stage_2_6 <= $itor(B6*sf*sf*sf*sf);
stage_2_7 <= $itor(B7*sf*sf*sf*sf);     
//DISPLAYING STAGE-3 OUTPUTS
stage_3_0 <= $itor(C0*sf*sf*sf*sf);
stage_3_1 <= $itor(C1*sf*sf*sf*sf);
stage_3_2 <= $itor(C2*sf*sf*sf*sf);
stage_3_3 <= $itor(C3*sf*sf*sf*sf);
stage_3_4 <= $itor(C4*sf*sf*sf*sf);
stage_3_5 <= $itor(C5*sf*sf*sf*sf);
stage_3_6 <= $itor(C6*sf*sf*sf*sf);
stage_3_7 <= $itor(C7*sf*sf*sf*sf);
//DISPLAYING STAGE-4 OUTPUTS
stage_4_0 <= $itor(D0*sf*sf*sf*sf*sf*sf);
stage_4_1 <= $itor(D1*sf*sf*sf*sf*sf*sf);
stage_4_2 <= $itor(D2*sf*sf*sf*sf*sf*sf);
stage_4_3 <= $itor(D3*sf*sf*sf*sf*sf*sf);
stage_4_4 <= $itor(D4*sf*sf*sf*sf*sf*sf);
stage_4_5 <= $itor(D5*sf*sf*sf*sf*sf*sf);
stage_4_6 <= $itor(D6*sf*sf*sf*sf*sf*sf);
stage_4_7 <= $itor(D7*sf*sf*sf*sf*sf*sf);
stage_4_8 <= $itor(D8*sf*sf*sf*sf*sf*sf);
stage_4_8 <= $itor(D9*sf*sf*sf*sf*sf*sf);     
//DISPLAYING STAGE-5 OUTPUTS
stage_5_0 <= $itor(E0*sf*sf*sf*sf*sf*sf);
stage_5_1 <= $itor(E1*sf*sf*sf*sf*sf*sf);
stage_5_2 <= $itor(E2*sf*sf*sf*sf*sf*sf);
stage_5_3 <= $itor(E3*sf*sf*sf*sf*sf*sf);
stage_5_4 <= $itor(E4*sf*sf*sf*sf*sf*sf);
stage_5_5 <= $itor(E5*sf*sf*sf*sf*sf*sf);
stage_5_6 <= $itor(E6*sf*sf*sf*sf*sf*sf);
stage_5_7 <= $itor(E7*sf*sf*sf*sf*sf*sf);
//DISPLAYING STAGE-6 OUTPUTS
stage_6_0 <= $itor(F0*sf*sf*sf*sf*sf*sf);
stage_6_1 <= $itor(F1*sf*sf*sf*sf*sf*sf);
stage_6_2 <= $itor(F2*sf*sf*sf*sf*sf*sf);
stage_6_3 <= $itor(F3*sf*sf*sf*sf*sf*sf);
stage_6_4 <= $itor(F4*sf*sf*sf*sf*sf*sf);
stage_6_5 <= $itor(F5*sf*sf*sf*sf*sf*sf);
stage_6_6 <= $itor(F6*sf*sf*sf*sf*sf*sf);
stage_6_7 <= $itor(F7*sf*sf*sf*sf*sf*sf);
//DISPLAYING STAGE-7 OUTPUTS
stage_6_0 <= $itor(G0*sf*sf*sf*sf*sf*sf);
stage_6_1 <= $itor(G1*sf*sf*sf*sf*sf*sf);
stage_6_2 <= $itor(G2*sf*sf*sf*sf*sf*sf);
stage_6_3 <= $itor(G3*sf*sf*sf*sf*sf*sf);
stage_6_4 <= $itor(G4*sf*sf*sf*sf*sf*sf);
stage_6_5 <= $itor(G5*sf*sf*sf*sf*sf*sf);
stage_6_6 <= $itor(G6*sf*sf*sf*sf*sf*sf);
stage_6_7 <= $itor(G7*sf*sf*sf*sf*sf*sf);
//CONVERTING OUTPUTS TO REAL NUMBERS
output_0 <= $itor(H0*sf*sf*sf*sf*sf*sf);      //MULTIPLYING OUTPUTS SIX TIMES BY sf 
output_1 <= $itor(H1*sf*sf*sf*sf*sf*sf);      //AS THERE ARE 6*4 = 24 DECIMAL PLACES
output_2 <= $itor(H2*sf*sf*sf*sf*sf*sf);      //IN OUTPUTS
output_3 <= $itor(H3*sf*sf*sf*sf*sf*sf);
output_4 <= $itor(H4*sf*sf*sf*sf*sf*sf);
output_5 <= $itor(H5*sf*sf*sf*sf*sf*sf);
output_6 <= $itor(H6*sf*sf*sf*sf*sf*sf);
output_7 <= $itor(H7*sf*sf*sf*sf*sf*sf);
end

always #50 clk = ~clk;
    
endmodule
