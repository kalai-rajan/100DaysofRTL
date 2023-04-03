module pipo (
    input clk,clr,
    input [3:0]din,
    output reg [3:0]q
);

always @(posedge clk ) begin
    if(clr) 
      q<=0;
    else 
       q<=din;
    
end
    
endmodule


module pipo_tb;
wire [3:0]Q;
reg CLK,CLR;
reg [3:0]DIN;

pipo dut(.din(DIN), .clk(CLK), .clr(CLR), .q(Q));

initial begin
    $monitor("%t)\t Q=%B\tD=%b",$time,Q,DIN);
    CLK=0;CLR=1;
    #10 CLR=0;
    #5 DIN=4'b1000;
    #10 DIN=4'b1111;
    #10 DIN=4'b1010;
    #10 DIN=4'b1000;
  #100 $finish();
end

always #5 CLK=~CLK;

endmodule
