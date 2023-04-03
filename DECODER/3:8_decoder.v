module  three_bit_decoder (
    input [2:0]ip,                           //ip lines
    output reg y0,y1,y2,y3,y4,y5,y6,y7     //o/p lines 
);

always @(*)
begin
    case (ip)
        3'd0:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00000001;
        3'd1:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00000010;
        3'd2:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00000100;             
        3'd3:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00001000;
        3'd4:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00010000;
        3'd5:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00100000; 
        3'd6:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b01000000;
        3'd7:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b10000000; 
        default: {y7,y6,y5,y4,y3,y2,y1,y0}=8'bz;
    endcase
end
endmodule

module three_8_decoder_tb;
wire Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7;
reg [2:0]IP;
integer i;

three_bit_decoder dut(
    .ip(IP),
    .y0(Y0), .y1(Y1), .y2(Y2), .y3(Y3), .y4(Y4), .y5(Y5), .y6(Y6), .y7(Y7)
);

initial
begin
      $monitor("%t the input to decoder is %b and outpUTS y0=%b--y1=%b--y2=%b-- y3=%b-- y4=%b-- y5=%b-- y6=%b-- y7=%b-- ",$time,IP,Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7);
      for (i = 0;i<8 ;i=i+1 )
       begin
        #10 {IP}=i;
      end
end



endmodule
