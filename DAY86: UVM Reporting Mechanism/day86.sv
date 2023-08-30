// Code your testbench here
`include "uvm_macros.svh"
import uvm_pkg::*;

class transection extends uvm_component;
   function new(string name="mon3",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
	function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("[mon]"," FROM UVM INFO UVM LOW",UVM_LOW)
     `uvm_info("[mon]"," FROM UVM INFO UVM MEDIUM",UVM_MEDIUM)
     `uvm_info("[driv]"," FROM UVM INFO UVM NONE",UVM_NONE)
     `uvm_info("[driv]"," FROM UVM INFO UVM HIGH",UVM_HIGH)
     `uvm_info("[driv]"," FROM UVM INFO UVM FULL",UVM_FULL)
      
  	endfunction
  
endclass

module tb;
  transection t;
  initial begin
    t=new();
  run_test();
    t.set_report_verbosity_level(UVM_DEBUG);
  end
endmodule
