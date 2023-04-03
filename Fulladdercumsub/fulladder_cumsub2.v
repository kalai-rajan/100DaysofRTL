module fa(input a,b,cin, output s,co);
assign {co,s}=a+b+cin;
endmodule


module fulladder_cumsuub3 (
    input [3:0]a,b,
    input c,                      //enable
    output [3:0]sum,carry);

    fa a1(.a(a[0]), .b(b[0]^c), .cin(c), .s(sum[0]), .co(carry[0]) );
    fa a2(.a(a[1]), .b(b[1]^c), .cin(carry[0]), .s(sum[1]), .co(carry[1]) );
    fa a3(.a(a[2]), .b(b[2]^c), .cin(carry[1]), .s(sum[2]), .co(carry[2]) );
    fa a4(.a(a[3]), .b(b[3]^c), .cin(carry[2]), .s(sum[3]), .co(carry[3]) );
    

    
endmodule

module  fulladder_cumsub3_tb;

wire [3:0]S,C;
reg  [3:0]A,B;
reg CIN;

fulladder_cumsuub3 dut (
    .a(A), .b(B),
    .c(CIN),
    .sum(S), .carry(C));

    initial
     begin
        $monitor("[%t] A=%b B=%b C=%b SUM=%b C=%b",$time,A,B,CIN,S,C[3]);
        A=4'B1100; B=4'B1101; CIN=1'b1;                                // since cin=1 subraction
        #10   A=4'b1001; B=4'B1110; CIN=1'b0;                          // since c=0 addition
    end

    
endmodule
