// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class packet extends uvm_component;
  `uvm_component_utils(packet)
  
  function new (string name="p_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  
endclass

class new_packet extends packet;
  `uvm_component_utils(new_packet)
  
  function new (string name="np_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  
endclass

class env extends uvm_component;
  
 `uvm_component_utils(env)
  packet p;
  new_packet np;
   uvm_factory factory;
  
  function new (string name="env_h", uvm_component parent=null);
    super.new(name,parent);
    factory = uvm_factory::get();
  endfunction
  
  function void replace();
    p=packet::type_id::create("pkt",this);
    
    $display("BEFORE OVER RIDING");
    p.print();
    
    
    factory.set_inst_override_by_name("packet","new_packet","*");//inst override by name
   // set_inst_override_by_type("*", packet::get_type(),new_packet::get_type() )//inst                                                                        override by type
    p=packet::type_id::create("pkt2",this);
    $display("AFTER OVER RIDING");
    p.print();
    factory.print();
    uvm_top.print_topology();
  endfunction
  
  
endclass

module tb;
  env e;
  initial begin
    e=new();
    e.replace();
  end
endmodule
