`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 21:47:51
// Design Name: 
// Module Name: dct_seq
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

module dct_seq(clk,btnC,btnU,btnL,btnR,btnD,sw,led,seg,an,dp );
            //Clock    
    	        input clk; //100 MHz
           //Push Button Inputs     
                input btnC; 
                input btnU;  
                input btnD;
                input btnR;
                input btnL;
                
           // Slide Switch Inputs     
                input signed [15:0] sw; 
              
           // LED Outputs
                output [15:0] led;
                
           // Seven Segment Display Outputs
                output [6:0] seg;
                output [3:0] an; 
                output dp;

    reg signed [7:0] I0=8'b0,
                     I1=8'b0,
                     I2=8'b0,
                     I3=8'b0,
                     I4=8'b0,
                     I5=8'b0,
                     I6=8'b0,
                     I7=8'b0;            
    reg signed [8:0] A0,A1,A2,A3,A4,A5,A6,A7;
    reg signed [9:0] B0,B1,B2,B3,B4,B5,B6,B7;
    reg signed [10:0] C0,C1,C2,C3,C4,C5,C6,C7,C8;    
    reg signed [21:0] D0,D1,D2,D3,D4,D5,D6,D7,D8;
    reg signed [22:0] E0,E1,E2,E3,E4,E5,E6,E7;
    reg signed [23:0] F0,F1,F2,F3,F4,F5,F6,F7;
    reg signed [39:0] G0,G1,G2,G3,G4,G5,G6,G7;
    
    reg sign0=0;
    reg sign1=0;
    reg sign2=0;
    reg sign3=0;
    reg sign4=0;
    reg sign5=0;
    reg sign6=0;
    reg sign7=0;

    reg sign=0;
    reg blink=0;
    reg [26:0] counter=0;
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

                           
reg signed [15:0] x = 16'b0;
reg dec=0;

assign led[14:0] = sw[14:0];  //THIS IS DONE TO MAKE IT EASIER TO KNOW WHICH INPUT WE ARE GIVING

always @(posedge clk) begin

if ( (btnU == 1))  
    begin
    case(sw[15:8]) 
        //GIVING INPUTS THROUGH SWITCHES
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
                //STAGE-4                                           //SIGN EXTENSION                 
                D0 <= {C0,8'b0}; if (C0[10]) D0[21:19] <= 3'b111;  //IS DONE USING CONCATENATION 
                D1 <= {C1,8'b0}; if (C1[10]) D1[21:19] <= 3'b111;  //SO THAT THE NEGATIVE NUMBERS 
                D2 <= C2 * m1;
                D3 <= {C3,8'b0}; if (C3[10]) D3[21:19] <= 3'b111;  //HAVE THEIR SIGN AND 
                D4 <= C4 * m3;
                D5 <= C5 * m1;
                D6 <= C6 * m4;
                D7 <= {C7,8'b0}; if (C7[10]) D7[21:19] <= 3'b111;  //MAGNITUDE RETAINED 
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
                
       else  if (btnL == 1) begin
                         //STAGE-7 
                         G0 <= F0 * s0;
                         G4 <= F1 * s4;
                         G6 <= F2 * s6;
                         G2 <= F3 * s2;
                         G3 <= F4 * s3;
                         G5 <= F5 * s5;
                         G7 <= F6 * s7;
                         G1 <= F7 * s1;         
                  end
                         
      else  if (btnR == 1) begin
                //GIVING SIGNS TO EACH OUTPUT                
                if(G0[39]) begin sign0 <= 1; G0 <= ~G0 + 1; end
                if(G1[39]) begin sign1 <= 1; G1 <= ~G1 + 1; end
                if(G2[39]) begin sign2 <= 1; G2 <= ~G2 + 1; end
                if(G3[39]) begin sign3 <= 1; G3 <= ~G3 + 1; end
                if(G4[39]) begin sign4 <= 1; G4 <= ~G4 + 1; end
                if(G5[39]) begin sign5 <= 1; G5 <= ~G5 + 1; end
                if(G6[39]) begin sign6 <= 1; G6 <= ~G6 + 1; end
                if(G7[39]) begin sign7 <= 1; G7 <= ~G7 + 1; end               
                end
    
    else if ((btnD == 1)) begin
        case(sw[15:8])                                 
                0:  begin if (sign0 == 0) begin 
                sign <= 0;                                                              
                case(sw[7:0])
                0:begin x <= G0[15:0]; dec <= 0;  end 
                1:begin x <= G0[31:16]; dec <= 1; end
                2:begin x <= {8'b0,G0[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end
                endcase
                end
                else if (sign0 == 1) begin 
                sign <= 1; 
                case(sw[7:0])
                0:begin x <= G0[15:0]; dec <= 0;end 
                1:begin x <= G0[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G0[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end
                endcase                                
                end
                end
                
            1:  begin if (sign1 == 0)begin 
                sign <= 0;  
                case(sw[7:0])
                0:begin x <= G1[15:0]; dec <= 0;end
                1:begin x <= G1[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G1[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end
                endcase
                end
                else if (sign1 == 1) begin 
                sign <= 1;
                case(sw[7:0])
                0:begin x <= G1[15:0]; dec <= 0;end
                1:begin x <= G1[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G1[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end
                endcase                
                end
                end
                
            2:  begin if (sign2 == 0) begin 
                sign <= 0;
                case(sw[7:0])
                0:begin x <= G2[15:0]; dec <= 0;end
                1:begin x <= G2[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G2[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0; end
                endcase
                end
                else if (sign2 == 1) begin 
                sign <= 1; 
                case(sw[7:0])
                0:begin x <= G2[15:0]; dec <= 0;end
                1:begin x <= G2[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G2[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end
                endcase                
                end
                end
                
            4:  begin if (sign3 == 0) begin 
                sign <= 0;
                case(sw[7:0])
                0:begin x <= G3[15:0]; dec <= 0;end
                1:begin x <= G3[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G3[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end                
                endcase
                end
                else if (sign3 == 1) begin 
                sign <= 1;
                case(sw[7:0])
                0:begin x <= G3[15:0]; dec <= 0;end
                1:begin x <= G3[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G3[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end                
                endcase                
                end
                end
                
            8:  begin if (sign4 == 0) begin 
                sign <= 0;   
                case(sw[7:0])
                0:begin x <= G4[15:0]; dec <= 0;end
                1:begin x <= G4[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G4[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end
                endcase
                end
                else if (sign4 == 1) begin 
                sign <= 1;   
                case(sw[7:0])
                0:begin x <= G4[15:0]; dec <= 0;end
                1:begin x <= G4[31:16]; dec <= 1;end
                2:begin x <= {8'b0,G4[39:32]}; dec <= 0;end
          default:begin x <= {16'b0}; dec <= 0;end
                endcase                
                end
                end
                
            16: begin if (sign5 == 0) begin 
                sign <= 0;  
                case(sw[7:0])
                0:begin x <= G5[15:0]; dec <= 0; end
                1:begin x <= G5[31:16]; dec <= 1; end
                2:begin x <= {8'b0,G5[39:32]}; dec <= 0; end
          default:begin x <= {16'b0}; dec <= 0; end
                endcase
                end
                else if (sign5 == 1) begin 
                sign <= 1;
                case(sw[7:0])
                0:begin x <= G5[15:0]; dec <= 0; end
                1:begin x <= G5[31:16]; dec <= 1; end
                2:begin x <= {8'b0,G5[39:32]}; dec <= 0; end
          default:begin x <= {16'b0}; dec <= 0; end
                endcase                
                end
                end
                
            32: begin if (sign6 == 0) begin 
                sign <= 0;
                case(sw[7:0])
                0:begin x <= G6[15:0]; dec <= 0; end
                1:begin x <= G6[31:16]; dec <= 1; end
                2:begin x <= {8'b0,G6[39:32]}; dec <= 0; end
          default:begin x <= {16'b0}; dec <= 0; end
                endcase
                end
                else if (sign6 == 1) begin 
                sign <= 1;
                case(sw[7:0])
                0:begin x <= G6[15:0]; dec <= 0; end
                1:begin x <= G6[31:16]; dec <= 1; end
                2:begin x <= {8'b0,G6[39:32]}; dec <= 0; end
          default:begin x <= {16'b0}; dec <= 0; end
                endcase                
                end
                end
                
            64: begin if (sign7 == 0) begin 
                sign <= 0;
                case(sw[7:0])
                0:begin x <= G7[15:0]; dec <= 0; end
                1:begin x <= G7[31:16]; dec <= 1; end
                2:begin x <= {8'b0,G7[39:32]}; dec <= 0; end 
          default:begin x <= {16'b0}; dec <= 0; end
                endcase
                end
                else if (sign7 == 1) begin 
                sign <= 1;
                case(sw[7:0])
                0:begin x <= G7[15:0]; dec <= 0; end
                1:begin x <= G7[31:16]; dec <= 1; end
                2:begin x <= {8'b0,G7[39:32]}; dec <= 0; end 
          default:begin x <= {16'b0}; dec <= 0; end
                endcase                
                end
                end                           
    endcase
    end

    else if ((btnC == 1)) begin
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
        x <= 0;
        sign <= 0;
        sign0 <= 0;
        sign1 <= 0;
        sign2 <= 0;
        sign3 <= 0;
        sign4 <= 0;
        sign5 <= 0;
        sign6 <= 0;
        sign7 <= 0;
        G0 <= 0;
        G1 <= 0;
        G2 <= 0;
        G3 <= 0;
        G4 <= 0;
        G5 <= 0;
        G6 <= 0;
        G7 <= 0;
        dec <= 0;
   end
end

always@(posedge clk)                    //THE CODE INSIDE THIS ALWAYS BLOCK
begin                                   //INCREMENTS A COUNTER VARIABLE AT EVER SO AS TO MAKE 
    counter=counter+1;                  //VARIABLE BLINK GO FROM HIGH TO LOW EVERY 0.5s (1Hz FREQUENCY)
    if(counter==49999999) begin counter=0; blink=blink+1; end 
end

assign led[15] = blink&(sign);  //THE LEFTMOST LED BLINKS AT 1Hz FREQUENCY WHEN NEGATIVE OUTPUT IS DISPLAYED

seg7decimal2 u7 (
.B(x),
.clk(clk),
.clr(btnC),
.dec(dec),
.a_to_g(seg),
.an(an),
.dp(dp)
);

endmodule