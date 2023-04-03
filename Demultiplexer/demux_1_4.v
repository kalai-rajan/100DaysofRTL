module demux_1_4 (
    input i,s1,s0,
    output y0,y1,y2,y3
);
wire sob,s1b;
not n1(s0b,s0);
not n2(s1b,s1);

and a1(y0,s0b,s1b,i);
and a2(y1,s0,s1b,i);
and a3(y2,s1,s0b,i);
and a4(y3,s1,s0,i);
endmodule

module demux_1_4_tb;
wire Y0,Y1,Y2,Y3;
reg I,S1,S0;
integer i;

demux_1_4 dut  (
    .i(I),.s1(S1),.s0(S0),
    .y0(Y0),.y1(Y1),.y2(Y2),.y3(Y3)
);

initial


begin
    $monitor("[%t] I=%B, S1:S0=%B:%B, Y0=%B, Y1=%B, Y2=%B, Y3=%B", $time,I,S1,S0,Y0,Y1,Y2,Y3);
    I=1'b1;
     for(i=0;i<4;i=i+1)
     
    begin
        #10; {S1,S0}=i;
    end

    
end
endmodule
