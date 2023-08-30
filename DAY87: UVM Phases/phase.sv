`include "uvm_macros.svh"
import uvm_pkg::*;

class mon extends uvm_component;
  `uvm_component_utils(mon)
  function new(string name="mon",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("BUILD-1");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("CONNECT-1");
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("END-OF-ELOB-1");
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    $display("(%0d)START-OF-SIM-1",$time);
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     $display("(%0d)RUN-1",$time);
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("(%0d)EXTRACT-1",$time);
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    $display("CHECK-1");
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("REPORT-1");
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("FINAL-1");
  endfunction
  

endclass

module tb;
  mon m;
  initial begin
    m=new();
    run_test();
  end
endmodule
