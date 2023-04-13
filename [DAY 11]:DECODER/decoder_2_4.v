module decoder_2_4 (
    input [1:0]i,
    output reg y1,y2,y3,y0
);

always @(*)
begin
    case (i)
        2'd0: {y0,y1,y2,y3}=4'b1000;
        2'd1: {y0,y1,y2,y3}=4'b0100;
        2'd2: {y0,y1,y2,y3}=4'b0010;
        2'd3: {y0,y1,y2,y3}=4'b0001; 
        default: {y0,y1,y2,y3}=0000;
    endcase
end
endmodule

module decoder_2_4_tb;

wire Y0,Y1,Y2,Y3;
reg [1:0]I;

 decoder_2_4 dut(
    .i(I),
    .y0(Y0), .y1(Y1), .y2(Y2), .y3(Y3)
);

initial 
begin
    $monitor("%t the input to decoder is %b and outputs y0=%b y1=%b y2=%b y3=%b",$time,I,Y0,Y1,Y2,Y3);
    I=2'b00;
    #10 I=2'b01;
    #10 I=2'b10;
    #10 I=2'b11;
end
endmodule