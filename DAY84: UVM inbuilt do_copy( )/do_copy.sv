
`include "uvm_macros.svh"
import uvm_pkg::*;

  class transection extends uvm_sequence_item;
  
  int a,b,c,d;
  
  function new(string name="t_h");
    super.new(name);
  endfunction
  
  function void do_copy (uvm_object tmp);
    transection t;
    super.do_copy(tmp);
    $cast(t,tmp);
    a=t.a;
    b=t.b;
    c=t.c;
    d=t.d;
  endfunction
  
  function void do_print(uvm_printer printer);
    printer.print_field("a",this.a,32,UVM_DEC);
    printer.print_field("b",this.b,32,UVM_DEC);
    printer.print_field("c",this.c,32,UVM_DEC);
    printer.print_field("d",this.d,32,UVM_DEC);
  endfunction
  

  
endclass

module tb;
  transection t1,t2,t3;
  initial begin
    t1= new("T_H1");
    t2=new("T_H2");
 
    
  t1.a=10; t1.b=20; t1.c=30; t1.d=45;
  t2.copy(t1);
   
    
  t1.print();  
  t2.print();
  t2.print(uvm_default_tree_printer);
  t2.print(uvm_default_line_printer);
  end
endmodule


