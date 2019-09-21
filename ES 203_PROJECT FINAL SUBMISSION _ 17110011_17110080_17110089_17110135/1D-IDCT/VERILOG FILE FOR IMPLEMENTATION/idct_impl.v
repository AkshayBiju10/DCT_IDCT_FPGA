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


module idct_seq(clk,btnC,btnU,btnL,btnR,btnD,sw,led,seg,an,dp
                 );
                    input clk;
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
                
         reg signed [21:0] A0,A1,A2,A3,A4,A5,A6,A7;
         reg signed [22:0] B0,B1,B2,B3,B4,B5,B6,B7;
         reg signed [23:0] C0,C1,C2,C3,C4,C5,C6,C7;    
         reg signed [34:0] D0,D1,D2,D3,D4,D5,D6,D7,D8,D9;
         reg signed [35:0] E0,E1,E2,E3,E4,E5,E6,E7;
         reg signed [36:0] F0,F1,F2,F3,F4,F5,F6,F7;        
         reg signed [37:0] G0,G1,G2,G3,G4,G5,G6,G7;
         reg signed [38:0] H0,H1,H2,H3,H4,H5,H6,H7;
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
        wire signed [10:0] c4 = 11'b000_10110101,  //0.7071
                           c6 = 11'b000_01100001,  //0.3826
                           c2 = 11'b000_11101100;  //0.92387
        
        wire signed [13:0] 
                           s0 = 14'b00_010110101000, //0.353606789 
                           s3 = 14'b00_010000010100,//0.9807852804  
                           s6 = 14'b00_010001010100,//0.9238795325 
                           s7 = 14'b00_010011001111,//0.8314696123 
                           s4 = 14'b00_010110101000,//0.3535533905
                           s1 = 14'b00_011100110011,//0.4499881115
                           s2 = 14'b00_101001110011,//0.6532814824
                           s5 = 14'b01_010010000000;//1.2814577238             
 
    //Seven Segment Display Signal
    reg signed [7:0] I0=16'b0,
               I1=16'b0,
               I2=16'b0,
               I3=16'b0,
               I4=16'b0,
               I5=16'b0,
               I6=16'b0,
               I7=16'b0;
    reg signed [15:0] x = 0; //input to seg7 to define segment pattern
    reg dec = 0;
    
    assign led[14:0] = sw[14:0];

    always @(posedge clk) begin
  if ( (btnU == 1))  
        begin
        case(sw[15:8]) 
    
            0:I0[7:0] <= sw[7:0];
            1:I1[7:0] <= sw[7:0];
            2:I2[7:0] <= sw[7:0];
            4:I3[7:0] <= sw[7:0];
            8:I4[7:0] <= sw[7:0];
           16:I5[7:0] <= sw[7:0];
           32:I6[7:0] <= sw[7:0];
           64:I7[7:0] <= sw[7:0];
          128:  
                begin
                    //Stge 1
                    A0 <= I0*s0;
                    A1 <= I1*s1;
                    A2 <= I2*s2;
                    A3 <= I3*s3;
                    A4 <= I4*s4;
                    A5 <= I5*s5;
                    A6 <= I6*s6;
                    A7 <= I7*s7;
                    //stage 2
                    B0 <= A0 + A4;  
                    B4 <= A0 - A4;  
                    B2 <= A2 - A6;  
                    B6 <= A2 + A6;  
                    B1 <= A1 + A7;  
                    B5 <= A5 - A3;  
                    B3 <= A5 + A3;
                    B7 <= A1 - A7;   

                    //stage 3
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
                    //STAGE-8
                    H0 <= G0 + G7;
                    H1 <= G4 + G3;
                    H2 <= G2 + G5;
                    H3 <= G6 + G1;
                    H4 <= G6 - G1;
                    H5 <= G2 - G5;
                    H6 <= G4 - G3;
                    H7 <= G0 - G7;
                    end
                    endcase
                    end
          else  if (btnL == 1) begin                
                    if(H0[38]) begin sign0 <= 1; H0 <= ~H0 + 1;  end
                    if(H1[38]) begin sign1 <= 1; H1 <= ~H1 + 1;  end
                    if(H2[38]) begin sign2 <= 1; H2 <= ~H2 + 1;  end
                    if(H3[38]) begin sign3 <= 1; H3 <= ~H3 + 1;  end
                    if(H4[38]) begin sign4 <= 1; H4 <= ~H4 + 1;  end
                    if(H5[38]) begin sign5 <= 1; H5 <= ~H5 + 1;  end
                    if(H6[38]) begin sign6 <= 1; H6 <= ~H6 + 1;  end
                    if(H7[38]) begin sign7 <= 1; H7 <= ~H7 + 1;  end                
                    end
                    
        else if ((btnD == 1)) begin
            case(sw[15:8])                                 
                0:  begin if (sign0 == 0) begin 
                    sign <= 0;                                                              
                    case(sw[7:0])
                    0:begin x <= H0[15:0]; dec <= 0;  end 
                    1:begin x <= H0[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H0[38:32]}; dec <= 0;end
                    default:begin x <= {16'b0}; dec <= 0; end 
                    endcase
                    end
                    else if (sign0 == 1) begin sign <= 1; 
                    case(sw[7:0])
                    0:begin x <= H0[15:0]; dec <= 0;end 
                    1:begin x <= H0[31:16]; dec <= 1;end
                    2:begin x <= {9'b0,H0[38:32]}; dec <= 0;end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase                                
                    end
                    end
                    
                1:  begin if (sign1 == 0)begin 
                    sign <= 0;  
                    case(sw[7:0])
                    0:begin x <= H1[15:0]; dec <= 0;end
                    1:begin x <= H1[31:16]; dec <= 1;end
                    2:begin x <= {9'b0,H1[38:32]}; dec <= 0;end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase
                    end
                    else if (sign1 == 1) begin 
                    sign <= 1;
                    case(sw[7:0])
                    0:begin x <= H1[15:0]; dec <= 0;end
                    1:begin x <= H1[31:16]; dec <= 1;end
                    2:begin x <= {9'b0,H1[38:32]}; dec <= 0;end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase                
                    end
                    end
                2:  begin if (sign2 == 0) begin 
                    sign <= 0;
                    case(sw[7:0])
                    0:begin x <= H2[15:0]; dec <= 0; end
                    1:begin x <= H2[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H2[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase
                    end
                    else if (sign2 == 1) begin 
                    sign <= 1; 
                    case(sw[7:0])
                    0:begin x <= H2[15:0]; dec <= 0; end
                    1:begin x <= H2[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H2[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase                
                    end
                    end
                4:  begin if (sign3 == 0) begin 
                    sign <= 0;
                    case(sw[7:0])
                    0:begin x <= H3[15:0]; dec <= 0; end
                    1:begin x <= H3[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H3[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase
                    end
                    else if (sign3 == 1) begin 
                    sign <= 1;
                    case(sw[7:0])
                    0:begin x <= H3[15:0]; dec <= 0; end
                    1:begin x <= H3[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H3[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase                
                    end
                    end
                8:  begin if (sign4 == 0) begin 
                    sign <= 0;   
                    case(sw[7:0])
                    0:begin x <= H4[15:0]; dec <= 0; end
                    1:begin x <= H4[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H4[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase
                    end
                    else if (sign4 == 1) begin 
                    sign <= 1; 
                    case(sw[7:0])
                    0:begin x <= H4[15:0]; dec <= 0; end
                    1:begin x <= H4[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H4[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase                
                    end
                    end
                16: begin if (sign5 == 0) begin 
                    sign <= 0;  
                    case(sw[7:0])
                    0:begin x <= H5[15:0]; dec<= 0; end
                    1:begin x <= H5[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H5[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase
                    end
                    else if (sign5 == 1) begin 
                    sign <= 1;
                    case(sw[7:0])
                    0:begin x <= H5[15:0]; dec <= 0; end
                    1:begin x <= H5[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H5[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase                
                    end
                    end
                32: begin if (sign6 == 0) begin 
                    sign <= 0;
                    case(sw[7:0])
                    0:begin x <= H6[15:0]; dec <= 0; end
                    1:begin x <= H6[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H6[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase
                    end
                    else if (sign6 == 1) begin 
                    sign <= 1; 
                    case(sw[7:0])
                    0:begin x <= H6[15:0]; dec <= 0; end
                    1:begin x <= H6[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H6[38:32]}; dec <= 0; end
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase                
                    end
                    end
                64: begin if (sign7 == 0) begin 
                    sign <= 0;
                    case(sw[7:0])
                    0:begin x <= H7[15:0]; dec <= 0; end
                    1:begin x <= H7[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H7[38:32]}; dec <= 0; end 
                    default:begin x <= {16'b0}; dec <= 0; end
                    endcase
                    end
                    else if (sign7 == 1) begin 
                    sign <= 1;
                    case(sw[7:0])
                    0:begin x <= H7[15:0]; dec <= 0; end
                    1:begin x <= H7[31:16]; dec <= 1; end
                    2:begin x <= {9'b0,H7[38:32]}; dec <= 0; end 
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
            x <= 0;
            sign <= 0;
            sign0=0;
            sign1=0;
            sign2=0;
            sign3=0;
            sign4=0;
            sign5=0;
            sign6=0;
            sign7=0;
            dec <= 0;
            sign <=0;
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
    
    
always@(posedge clk)
begin
    counter=counter+1;
    if(counter==49999999) begin counter=0; blink=blink+1; end 
end
    
assign led[15] = blink&sign;

seg7decimal2 Iu7 (
.B(x),
.clk(clk),
.clr(btnC),
.dec(dec),
.a_to_g(seg),
.an(an),
.dp(dp)
 );

    
    endmodule
