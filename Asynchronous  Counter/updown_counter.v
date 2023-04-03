module t_ff(
    input clk,rst,
    input  t,
    output reg q,
    output qb
);

always@(posedge clk or posedge rst)
begin
    if(rst)
            q<=0;
         else
            begin
                if(t)
                 q<=~q;
                else
                 q<=q;
            end
        
end
assign qb=~q;

endmodule

module up_down_counter2 (input clk,rst,en,
input [3:0]t,
output [3:0] q,qb );

t_ff d0(.clk(clk),   .rst(rst), .t(t[0]), .q(q[0]), .qb(qb[0]));
t_ff d1(.clk(q[0]^en), .rst(rst), .t(t[1]), .q(q[1]), .qb(qb[1]));
t_ff d2(.clk(q[1]^en), .rst(rst), .t(t[2]), .q(q[2]), .qb(qb[2]));
t_ff d3(.clk(q[2]^en), .rst(rst), .t(t[3]), .q(q[3]), .qb(qb[3]));


endmodule

module up_down_counter2_tb;
wire [3:0]Q,QB;
reg [3:0]T;
reg CLK,RST,EN;

up_down_counter2 dut (.clk(CLK), .rst(RST),
.t(T),
.q(Q), .qb(QB), .en(EN) );

initial begin
     $monitor("%t)\tEN=%D\tCOUNT=%B(%D)\t",$time,EN,Q,Q);
    CLK=0;RST=1;T=4'b1111;EN=0;
    #5RST=0;EN=1;
    #165 EN=0;
end
always #5 CLK=~CLK;
endmodule
