module fulladdcum_sub (
                        input [3:0]a,b, input cin, en,
                        output reg [3:0]s, 
                        output reg co
);

always @(*)
begin
    if(en)
      begin
        {co,s}=a+b+cin;        
      end

      else
       begin
        {co,s}=a-b-cin;
       end
end
    
endmodule

module fulladdcum_sub_tb;

wire [3:0] S;
wire CO;
reg [3:0] A,B;
reg EN,C;

fulladdcum_sub dut(
                        .a(A), .b(B), .cin(C), .en(EN),
                        .s(S), .co(CO)
);

initial 
begin
     $monitor("%0t, A=%b, B=%b, C=%b, EN=%B, S=%b, C0=%b",$time,A,B,C,EN,S,CO);
    A=4'b0000;B=4'b0000;C=1'b0; 
    #100 A=4'b1001; B=4'b1010; C=1'b1; EN=1;
    #100 A=4'b1001; B=4'b1010; C=1'b1; EN=0;
    
end    
endmodule
