module  a_mux2x1(i0,i1,s0,y);

input i0,i1,s0;
output y;

assign y=s0?i1:i0;
endmodule

module a_8bit_barrel_shifter (in,s,out);

input [7:0]in;
input [2:0]s;
output [7:0]out;

wire [7:0]p,l;

//shift by 4

a_mux2x1 inst1(in[0],in[4],s[2],p[0]);
a_mux2x1 inst2(in[1],in[5],s[2],p[1]);
a_mux2x1 inst3(in[2],in[6],s[2],p[2]);
a_mux2x1 inst4(in[3],in[7],s[2],p[3]);
a_mux2x1 inst5(in[4],in[0],s[2],p[4]);
a_mux2x1 inst6(in[5],in[1],s[2],p[5]);
a_mux2x1 inst7(in[6],in[2],s[2],p[6]);
a_mux2x1 inst8(in[7],in[3],s[2],p[7]);


//shift  by 2

a_mux2x1  inst9(p[0],p[2],s[1],l[0]);
a_mux2x1 inst10(p[1],p[3],s[1],l[1]);
a_mux2x1 inst11(p[2],p[4],s[1],l[2]);
a_mux2x1 inst12(p[3],p[5],s[1],l[3]);
a_mux2x1 inst13(p[4],p[6],s[1],l[4]);
a_mux2x1 inst14(p[5],p[7],s[1],l[5]);
a_mux2x1 inst15(p[6],p[0],s[1],l[6]);
a_mux2x1 inst16(p[7],p[1],s[1],l[7]);

//shift by 1

a_mux2x1 inst17(l[0],l[1],s[0],out[0]);
a_mux2x1 inst18(l[1],l[2],s[0],out[1]);
a_mux2x1 inst19(l[2],l[3],s[0],out[2]);
a_mux2x1 inst20(l[3],l[4],s[0],out[3]);
a_mux2x1 inst21(l[4],l[5],s[0],out[4]);
a_mux2x1 inst22(l[5],l[6],s[0],out[5]);
a_mux2x1 inst23(l[6],l[7],s[0],out[6]);
a_mux2x1 inst24(l[7],l[0],s[0],out[7]);

    
endmodule

module a_8bit_barrel_shifter_tb;

wire [7:0]OUT;
reg [7:0]IN;
reg [2:0]S;
integer i;

a_8bit_barrel_shifter dut(IN,S,OUT);

initial begin
    $monitor("%0d\tin=%b\tsel=%b(%0d)\tout=%b",$time,IN,S,S,OUT);
    i=0; IN=8'b11001110;
    for (i =0 ;i<8 ;i=i+1) begin
        #5 S=i;
    end

end

endmodule
 
