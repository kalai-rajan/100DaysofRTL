// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class Tx extends uvm_component;
  `uvm_component_utils(Tx)
   event next;
   
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
    
    repeat(5) begin
    a=$random;
    p_h.put(a);
    $display("%0d)Data sended by TX=%0d\n",$time,a);
    @(next);
    end
     phase.drop_objection(this);
  endtask
  
endclass

class Rx extends uvm_component;
    `uvm_component_utils(Rx)
  uvm_blocking_get_port #(int) g_h;
  event next;
  
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
    repeat(5) begin
     g_h.get(a);
     $display("Value Received in RX=%0d\n",a);
     ->next;
    end
   endtask
  
endclass

class env extends uvm_component;
  `uvm_component_utils(env)
   Tx t_h;
   Rx r_h;
   uvm_tlm_fifo #(int) fifo_h;
   event nextr;
  
  function new (string name="rx_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    t_h=Tx::type_id::create("t_h",this);
    r_h=Rx::type_id::create("r_h",this);
    fifo_h=new("fif_h",this,0); //instance_name,heirachy,
    t_h.next=nextr;
    r_h.next=nextr;
  endfunction 
  
  function void connect_phase(uvm_phase phase);
    t_h.p_h.connect(fifo_h.put_export);
    r_h.g_h.connect(fifo_h.get_export);
  endfunction
   
endclass

module tlm_fifo_tb;
  env e;
  initial begin
    e=new();
    run_test();
  
  end
endmodule
