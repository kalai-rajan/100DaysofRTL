module  a_mux2x1(i0,i1,s0,y);

input i0,i1,s0;
output y;

assign y=s0?i1:i0;
endmodule

module a_3x1mux(i0,i1,i2,s0,s1,y);

input i0,i1,i2;
input s0,s1;

output y;

wire l;

a_mux2x1 dut1 (i0,i1,s0,l);
a_mux2x1 dut2 (l,i2,s1,y);


endmodule

module a_3x1mux_tb;

reg I0,I1,I2,S0,S1;
wire Y;

a_3x1mux dut(I0,I1,I2,S0,S1,Y);


initial begin
    $monitor("%0d\ti0=%b\ti1=%b\ti2=%b\ts0=%b\ts1=%b\ty=%b",$time,I0,I1,I2,S0,S1,Y);
       I0 = 1; I1 = 0; I2 = 0; S0=0; S1=0;
    #5 I0 = 0; I1 = 1; I2 = 0; S0=0; S1=1;
    #5 I0 = 0; I1 = 0; I2 = 1; S0=1; S1=0;
    #5 I0 = 1; I1 = 0; I2 = 1; S0=1; S1=1;
end
endmodule