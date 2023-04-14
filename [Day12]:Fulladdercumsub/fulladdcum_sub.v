module fulladdcum_sub (
                        input [3:0]a,b, input en,
                        output reg [3:0]s, 
                        output reg co
);

always @(*)
begin
    if(en)
      begin
        {co,s}=a+b;        
      end

      else
       begin
        {co,s}=a-b;
       end
end
    
endmodule

module fulladdcum_sub_tb;

wire [3:0] S;
wire CO;
reg [3:0] A,B;
reg EN;

fulladdcum_sub dut(
                        .a(A), .b(B),  .en(EN),
                        .s(S), .co(CO)
);

initial 
begin
     $monitor("%0t, A=%b, B=%b,  EN=%B, S=%b, C0=%b",$time,A,B,EN,S,CO);
    A=4'b0000;B=4'b0000;
    #100 A=4'b1001; B=4'b1010;   EN=1;
    #100 A=4'b1001; B=4'b1010;   EN=0;
    
end    
endmodule
