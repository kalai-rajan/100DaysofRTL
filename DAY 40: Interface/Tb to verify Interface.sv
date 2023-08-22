// Code your design here
module adder(intf add);
 
  reg [4:0]temp;
  
  always @(*) begin
    temp=add.a+add.b+add.cin;
   add.s= temp[3:0];
  add.cout=temp[4];
  end
endmodule

interface intf;
  
  logic[3:0]a,b,s;
  logic cin,cout;
  
endinterface

module tb;
 
  int i;
  intf a();
  adder dut(a);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
  
  initial begin
    $monitor("(%0d)\tA=%b\tB=%b\tCIN=%b\tS=%b\tCOUT=%b",$time,a.a,a.b,a.cin,a.s,a.cout);
    i=0;a.a=0;a.b=0;a.cin=0;
    repeat(16) begin
      #5; 
        a.a=i; a.b=i; a.cin=i;
      	i++;
    end
    #100 $finish();
  end
endmodule
