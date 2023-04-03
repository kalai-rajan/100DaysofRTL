module mux_21 (
               input i0,i1,
               input s,
               output y0);

assign y0= ( (~s & i0) | (s&i1) );     

endmodule

module mux81_using_21 (
    input [7:0]ip,
    input [2:0]s,
    output y
);
wire l,m,n,o,p,q;
mux_21 do(.i0(ip[0]), .i1(ip[1]), .s(s[0]), .y0(l));
mux_21 d1(.i0(ip[2]), .i1(ip[3]), .s(s[0]), .y0(m));
mux_21 d2(.i0(ip[4]), .i1(ip[5]), .s(s[0]), .y0(n));
mux_21 d3(.i0(ip[6]), .i1(ip[7]), .s(s[0]), .y0(o));

mux_21 d4(.i0(l), .i1(m), .s(s[1]), .y0(p));
mux_21 d5(.i0(n), .i1(o), .s(s[1]), .y0(q));

mux_21 d6(.i0(p), .i1(q), .s(s[2]), .y0(y));

endmodule

module mux21using81_tb;

wire Y;
reg [7:0]IP;
reg [2:0]S;
integer i;

mux81_using_21 dut  (
    .ip(IP),
    .s(S),
    .y(Y)
);

initial 
begin
    $monitor("[%t] INPUTS=%B,SELECT LINES=%B, OUTPUTLINESSELECTED=%d ",$time,IP,S,i);
    for(i=0;i<8;i=i+1)
    begin
        #10; IP=(2**i); S=i;
    end
end

    
endmodule
