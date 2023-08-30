 `include "uvm_macros.svh"
import uvm_pkg::*;

class Rx extends uvm_component;
  uvm_blocking_get_port #(int) g_h;
  `uvm_component_utils(Rx)
   int a;
  
  function new(string name="rx_h",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    g_h=new("g_h",this);
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     g_h.get(a);
     $display("Value Received in RX=%0d",a);
   endtask
  
endclass

class Tx extends uvm_component;
  
  uvm_blocking_get_imp #(int,Tx) i_h;
  `uvm_component_utils(Tx)
   int a;
  
  function new(string name="tx_h",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i_h=new("i_h",this);
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     a=23;
     $display("Value Transmitted in TX=%0d",a);
   endtask
  
  function void get(output int t);
    t=a;
  endfunction
  
  
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  Tx t_h;
  Rx r_h;
  
  function new(string name="tx_h",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     t_h=Tx::type_id::create("t_h",this);
     r_h=Rx::type_id::create("r_h",this);
  endfunction
  
  
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     r_h.g_h.connect(t_h.i_h);
  endfunction
  
  
endclass

module tb;
  env e;
  initial begin
    e=new();
    run_test();
  end
endmodule
