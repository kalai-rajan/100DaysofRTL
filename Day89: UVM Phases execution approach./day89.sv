`include "uvm_macros.svh"
import uvm_pkg::*;

class mon6 extends uvm_component;
  function new(string name="mon_6",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("BUILD-6");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("CONNECT-6");
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("END-OF-ELOB-6");
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    $display("START-OF-SIM-6");
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     $display("RUN-6");
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("EXTRACT-6");
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    $display("CHECK-6");
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("REPORT-6");
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("FINAL-6");
  endfunction
  

endclass
//--------------------------------------------------------------------------------------------------------------------
class mon3 extends uvm_component;
mon6 m6;
  function new(string name="mon3",uvm_component parent=null);
    super.new(name,parent);
    m6=new("m6",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("BUILD-3");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("CONNECT-3");
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("END-OF-ELOB-3");
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    $display("START-OF-SIM-3");
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     $display("RUN-3");
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("EXTRACT-3");
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    $display("CHECK-3");
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("REPORT-3");
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("FINAL-3");
    
  endfunction
  

endclass
//--------------------------------------------------------------------------------------------------------------------

class mon4 extends uvm_component;
  function new(string name="mon4",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("BUILD-4");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("CONNECT-4");
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("END-OF-ELOB-4");
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    $display("START-OF-SIM-4");
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     $display("RUN-4");
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("EXTRACT-4");
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    $display("CHECK-4");
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("REPORT-4");
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("FINAL-4");
  endfunction
  

endclass
//--------------------------------------------------------------------------------------------------------------------
class mon5 extends uvm_component;
  function new(string name="mon6",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("BUILD-5");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("CONNECT-5");
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("END-OF-ELOB-5");
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    $display("START-OF-SIM-5");
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     $display("RUN-5");
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("EXTRACT-5");
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    $display("CHECK-4");
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("REPORT-5");
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("FINAL-5");
  endfunction
  

endclass
//--------------------------------------------------------------------------------------------------------------------
class mon2 extends uvm_component;
mon4 m4;
mon5 m5;
  function new(string name="mon2",uvm_component parent=null);
    super.new(name,parent);
    m4=new();
    m5=new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("BUILD-2");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("CONNECT-2");
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    $display("END-OF-ELOB-2");
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    $display("START-OF-SIM-2");
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
     $display("RUN-2");
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("EXTRACT-2");
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    $display("CHECK-2");
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("REPORT-2");
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("FINAL-2");
  endfunction
  
endclass
//--------------------------------------------------------------------------------------------------------------------
class mon extends uvm_component;
mon2 m2;
mon3  m3;

  function new(string name="mon",uvm_component parent=null);
    super.new(name,parent);
    m2=new();
    m3=new();
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
    $display("START-OF-SIM-1");
  endfunction
  
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
    $display("RUN-1");
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
     $display("EXTRACT-1");
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
//--------------------------------------------------------------------------------------------------------------------

module tb;
  mon m;
  initial begin
    m=new();
    run_test();
  end
  
endmodule

