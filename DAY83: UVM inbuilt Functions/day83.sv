// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class transection extends uvm_sequence_item;
  
  int a,b,c,d;
  
  function new(string name="t_h");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(transection)
  `uvm_field_int(a,UVM_ALL_ON)
  `uvm_field_int(b,UVM_NOCOPY)
  `uvm_field_int(c,UVM_ALL_ON|UVM_NOPRINT)
  `uvm_field_int(d,UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass

module tb;
  transection t1,t2,t3;
  initial begin
  t1= new();
  t2=new();
 
    
  t1.a=10; t1.b=20; t1.c=30; t1.d=45;
  t2.copy(t1);
  $cast(t3,t1.clone());
    
  t1.print();  
  t2.print();
  t3.print();
  t2.print(uvm_default_tree_printer);
  t2.print(uvm_default_line_printer);
  end
endmodule



