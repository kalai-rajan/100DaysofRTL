// Code your testbench here
// or browse Examples
module paramet_class_eample;
  
  class packet #(parameter int ADDR_WIDTH=10, DATA_WIDTH =4);
    bit[ADDR_WIDTH-1:0] addr;
    bit[DATA_WIDTH-1:0] data;
  endclass
  
  class packet_2 #(parameter type t=int);
    t addr;
    t data;
  endclass
  
  initial begin
    packet p1;
    packet #(20,20) p2;
    packet_2 p;
    p=new();
    p1=new();
    p2=new();
    $display("size of addr and data with o p1=%d\t%D",$size(p.addr),$size(p.data));
    $display("size of addr and data with o p1=%d\t%D",$size(p1.addr),$size(p1.data));
    $display("size of addr and data with o p2=%d\t%D",$size(p2.addr),$size(p2.data));
             end 
endmodule
