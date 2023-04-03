 module siso (
    input din,clk,clr,
    output reg [3:0]q
);

 

always @(posedge clk or posedge clr) begin
    if (clr)
     q<=0;
    else begin
       q<=q>>1;    //q'=q>>1;
      q[3]<=din;  //q={din,q'[2:0]}
    end
end
  
endmodule

module siso_tb;
wire [3:0]Q;
reg DIN,CLK,CLR;

siso dut(.din(DIN), .clk(CLK), .clr(CLR), .q(Q));

initial begin
    $monitor("%t)\t Q=%B\tD=%b",$time,Q,DIN);
    CLK=0;CLR=1;
    #10 CLR=0;
    #5 DIN=1;
    #10 DIN=1;
    #10 DIN=1;
    #10 DIN=1;
end

always #5 CLK=~CLK;
endmodule
