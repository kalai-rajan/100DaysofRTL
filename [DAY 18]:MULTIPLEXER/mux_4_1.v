module mux4_1 (
     input [1:0]ip1,ip2,ip3,ip0, input s1,s0,
     output [8:0]y
);



assign y=s1? (s0?ip3:ip2):(s0?ip1:ip0);  //dataflow modelling
    
endmodule

module mux4_1_tb;

wire  [8:0]Y;
reg   S1,S0;
reg [1:0]IP0,IP1,IP2,IP3;
integer i;


mux4_1 dut (
     .ip0(IP0), .ip1(IP1), .ip2(IP2), .ip3(IP3), .s1(S1), .s0(S0),
     .y(Y)
);

initial
begin
    
    $monitor("%t, s1,s0=%b %b, y=%D",$time,S1,S0,Y);
      IP0=2'b00;
      IP1=2'd1;
      IP2=2'd2;
      IP3=2'd3;
    for(i=0;i<4;i=i+1)
    begin
        #10;
        {S1,S0}=i;
    end
    
end

    
endmodule
