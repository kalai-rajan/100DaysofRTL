 // Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class Tx extends uvm_component;
  `uvm_component_utils(Tx)
   
  int a;
  uvm_analysis_port #(int) p_h;
  
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
    p_h.write(a);
    
    $display("%0d)Data sended by TX=%0d\n",$time,a);
     phase.drop_objection(this);
  endtask
  
endclass


class Rx1 extends uvm_component;
  `uvm_component_utils(Rx1)
    
  int a;
  uvm_analysis_imp #(int,Rx1) i_h;
  
  function new (string name="rx1_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i_h=new("i1",this);
  endfunction 

  
   function void write (input int t);
    a=t;
  endfunction
  
   task run_phase(uvm_phase phase);
     phase.raise_objection(this);
     super.run_phase(phase);
     # 10; $display("%0d)Data Received by RX1=%0d\n",$time,a);
     phase.drop_objection(this);
  endtask
  
endclass


class Rx2 extends uvm_component;
  `uvm_component_utils(Rx2)
    
  int a;
  uvm_analysis_imp #(int,Rx2) i_h2;
  
  function new (string name="rx2_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i_h2=new("i2",this);
  endfunction 

  
   function void write (input int t);
    a=t;
  endfunction
  
   task run_phase(uvm_phase phase);
     super.run_phase(phase);
     phase.raise_objection(this);
   #10;  $display("%0d)Data Received by RX2=%0d",$time,a);
     phase.drop_objection(this);
  endtask
  
endclass

class Rx3 extends uvm_component;
  `uvm_component_utils(Rx3)
    
  int a;
  uvm_analysis_imp #(int,Rx3) i_h3;
  
  function new (string name="rx2_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i_h3=new("i3",this);
  endfunction 

  
   function void write (input int t);
    a=t;
  endfunction
  
   task run_phase(uvm_phase phase);
     super.run_phase(phase);
     phase.raise_objection(this);
    #10; $display("%0d)Data Received by RX3=%0d",$time,a);
     phase.drop_objection(this);
  endtask
  
endclass

class env extends uvm_component;
  `uvm_component_utils(env)
   Tx t_h;
   Rx1 r_h;
   Rx2 r_h2;
   Rx3 r_h3;
  
  function new (string name="rx_h", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    t_h=Tx::type_id::create("t_h",this);
    r_h=Rx1::type_id::create("r_h",this);
    r_h2=Rx2::type_id::create("r_h2",this);
    r_h3=Rx3::type_id::create("r_h3",this);
  endfunction 
  
  function void connect_phase(uvm_phase phase);
    t_h.p_h.connect(r_h.i_h);
    t_h.p_h.connect(r_h2.i_h2);
    t_h.p_h.connect(r_h3.i_h3);

  endfunction
   
endclass

module tlm_analysis_tb;
  env e;
  initial begin
    e=new();
    run_test();
  
  end
endmodule

