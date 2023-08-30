module rtc_7seg(input [3:0]bcd, output reg [6:0]seg);

always @(*) begin
    case(bcd)
    4'd0: seg=7'b1111110;
    4'd1: seg=7'b0110000;
    4'd2: seg=7'b1101101;
    4'd3: seg=7'b1111001;
    4'd4: seg=7'b0110011;
    4'd5: seg=7'b1011011;
    4'd6: seg=7'b1011111;
    4'd7: seg=7'b1110000;
    4'd8: seg=7'b1111111;
    4'd9: seg=7'b1111011;
    default: seg=7'b0000000;
    endcase
    
end
endmodule


module rtc_7seg_tb;
wire [6:0]SEG;
reg [3:0]BCD;
integer i;

bcd_2_7seg dur(.bcd(BCD),.seg(SEG));
initial begin
    $monitor("\t BCD=%B(%d) \t SEGMENT=%B",BCD,BCD,SEG);
    for(i=0;i<16;i=i+1)
    begin
        #10  BCD=i;
    end
end
   
endmodule