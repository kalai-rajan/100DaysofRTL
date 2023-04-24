module comp_4bit_1 (
    input [3:0]a,b ,   //input lines
    output agb,aeb,alb   //outputs 

);

assign agb=a>b?1:0;                         
  assign aeb=(a==b)?1:0;      //dataflow modelling             
assign alb=a<b?1:0;
    
endmodule

module  comp_4bit_1_tb;
wire AGB,AEB,ALB;
reg [3:0]A,B;
integer i;
comp_4bit_1 dut(.a(A), .b(B), .agb(AGB), .aeb(AEB), .alb(ALB));

initial
begin
      $monitor("[%t], A=%D, B=%d, A>B=%D, A==B=%D, A<B=%D",$time,A,B,AGB,AEB,ALB);
     for(i=0;i<8;i=i+1)
     begin
        #10 A=$random; B=$random;

     end
end
    
endmodule
