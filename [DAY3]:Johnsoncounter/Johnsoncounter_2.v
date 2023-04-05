
module dff(input d,clk,prst,clr,
            output reg q,
            output qb);

always @(posedge clk or posedge clr or posedge prst) begin
    if(prst && ~clr)
      q<=1;
    else if(clr && ~prst)
       q<=0;
    else 
        if(clk)
            q<=d;
        else 
            q<=q;
end

assign qb=~q;
endmodule

module johnsoncounter_2 (input [2:0]d,prst,clr, input clk,
                      output [2:0]q,qb
);

dff d0(.d(q[1]), .clk(clk), .prst(prst[0]), .clr(clr[0]), .q(q[0]), .qb(qb[0]) );  //d0
dff d1(.d(q[2]), .clk(clk), .prst(prst[1]), .clr(clr[1]), .q(q[1]), .qb(qb[1]) );  //d1
dff d2(.d(qb[0]), .clk(clk), .prst(prst[2]), .clr(clr[2]), .q(q[2]), .qb(qb[2]) );  //d2
    
endmodule

module johnsoncounter_2_tb;
wire [2:0]Q,QB;
reg [2:0]D,PRST,CLR;
reg CLK;

johnsoncounter_2  dut(.clk(CLK), .prst(PRST), .clr(CLR), .q(Q), .qb(QB),.d(D));
initial begin
     $monitor("%t]\t COUNT=%B(%D)\t",$time,Q,Q);
     CLK=0; PRST=3'B000; CLR=3'B111;
     #10 PRST=0; CLR=0; 
end
always #5 CLK=~CLK;
endmodule
