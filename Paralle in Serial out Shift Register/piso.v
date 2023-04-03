module piso (
    input clk,clr,en,   //en=1 load en=0 shift
    input [3:0]din,
  output reg [3:0]q,
  output reg out
);

always @(posedge clk ) begin
    if(clr) 
      q<=4'b0000;
    else begin
        if(en==1)
          q<=din;
        else if(en==0)
           q<=q>>1;    
           out<=q[0]; 
        
end
    
end
endmodule

module piso_tb;
wire [3:0]Q;
  wire OUT;
reg CLK,CLR,EN;
reg [3:0]DIN;

  piso dut(.din(DIN), .clk(CLK), .clr(CLR), .q(Q), .en(EN), .out(OUT) );

initial begin
  $monitor("%t)\t Q=%B\tD=%b\tOUT=%B",$time,Q,DIN,OUT);
   CLK=0; CLR=1;
   #5 CLR=0;
   #10 EN=1; DIN=4'B1010;
   repeat(4) #10 EN=0;

end

always #5 CLK=~CLK;

endmodule
