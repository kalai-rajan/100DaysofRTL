module dlatch_using_mux (clk,d,q);

input clk;
input d;
output q;

mux_2_1 a0(q,d,clk,q);


endmodule

module mux_2_1 (i0,i1,s,y);

input i0,i1,s;
output y;

assign y=s?i1:i0;
    
endmodule

module dlatch_using_mux_tb;

wire Q;
reg CLK,D;

dlatch_using_mux dut(CLK,D,Q);

initial begin
    $monitor("%0d\tD=%b\tQ=%b",$time,D,Q);
    CLK=0; D=1;
    #5 D=0;
    #5 D=1;
    #5 D=1;
    #5 D=1;
    #5 D=0;
    #5 D=1;
end

always #5 CLK=~CLK;
endmodule
