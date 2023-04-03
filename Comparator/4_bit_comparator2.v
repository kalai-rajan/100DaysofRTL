module comp_4bit_2 (
    input [3:0]a,b ,
    output agb,aeb,alb

);

assign aeb= (  (a[3] ~^ b[3]) && (a[2] ~^ b[2]) && (a[1] ~^ b[1]) && (a[0] ~^ b[0])  )     ;                         //try using tasks and functions   //check eqns of a>b;          
assign agb= (  (a[3] & (!b)) || ( (a[3] ~^ b[3]) && (a[2] & (!b[2]))  ) || ( (a[3] ~^ b[3]) && (a[2] ~^ b[2]) && (a[1] & (!b[1])) ) || ( (a[3] ~^ b[3]) && (a[2] ~^ b[2]) && (a[1] ~^ (b[1])) | (a[0] & ~b[0])) );
assign alb=(!agb && !aeb)?1:0;
    
endmodule

module  comp_4bit_2_tb;
wire AGB,AEB,ALB;
reg [3:0]A,B;
integer i;
comp_4bit_2 dut(.a(A), .b(B), .agb(AGB), .aeb(AEB), .alb(ALB));

initial
begin
      $monitor("[%t], A=%D, B=%d, A>B=%D, A==B=%D, A<B=%D",$time,A,B,AGB,AEB,ALB);
     for(i=0;i<8;i=i+1)
     begin
        #10 A=$random; B=$random;

     end
end
    
endmodule