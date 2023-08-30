// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class Tx extends uvm_component;
  `uvm_component_utils(Tx)
   
  int a;
  uvm_blocking_put_port #(int) p_h;
  
  function new (string name="tx_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      p_h=new("p1",this);
  	endfunction 
  
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.run_phase(phase);
    a=23;
    p_h.put(a);
    
    $display("%0d)Data sended by TX=%0d",$time,a);
     phase.drop_objection(this);
  endtask
  
endclass


class Rx extends uvm_component;
  `uvm_component_utils(Rx)
    
  int a;
  uvm_blocking_put_imp #(int,Rx) i_h;
  
  function new (string name="rx_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i_h=new("i1",this);
  endfunction 

  
   function void put (input int t);
    a=t;
  endfunction
  
   task run_phase(uvm_phase phase);
     super.run_phase(phase);
     $display("%0d)Data Received by RX=%0d",$time,a);
  endtask
  
endclass

class env extends uvm_component;
  `uvm_component_utils(env)
   Tx t_h;
   Rx r_h;
  
  function new (string name="rx_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    t_h=Tx::type_id::create("t_h",this);
    r_h=Rx::type_id::create("r_h",this);
  endfunction 
  
  function void connect_phase(uvm_phase phase);
    t_h.p_h.connect(r_h.i_h);
  endfunction
   
endclass

module tlm_put_tb;
  env e;
  initial begin
    e=new();
    run_test();
  
  end
endmodule

