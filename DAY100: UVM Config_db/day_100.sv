`include "uvm_macros.svh"
import uvm_pkg::*;


class driver extends uvm_driver;
    `uvm_component_utils(driver)

    function new (string name="d_h",uvm_component parent =null);
        super.new(name,parent);
    endfunction

endclass

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new (string name="m_h",uvm_component parent =null);
        super.new(name,parent);
    endfunction

endclass

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    function new (string name="s_h",uvm_component parent =null);
        super.new(name,parent);
    endfunction

endclass

class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)
    driver d;
    monitor m;
    scoreboard s;
    bit is_active;

    function new (string name="ag_h",uvm_component parent =null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
      uvm_config_db #(bit)::get(this,"*","is_active",is_active);
        if(is_active)begin
        d=driver::type_id::create("d1",this);
        m=monitor::type_id::create("m2",this);
          
        end
        else
        s=scoreboard::type_id::create("s3",this);
    endfunction


endclass

class env extends uvm_component;
    `uvm_component_utils(env)
    my_agent a_h[];
    int no_of_agents;

     function new (string name="e_h",uvm_component parent =null);
        super.new(name,parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
      uvm_config_db #(bit)::get(this,"*","no_of_agents",no_of_agents);
        if(no_of_agents!=0) begin
            a_h=new[no_of_agents];
        end
    endfunction

endclass

class test extends uvm_component;
    `uvm_component_utils(test)
     env e_h;

    function new (string name="t_h",uvm_component parent =null);
        super.new(name,parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
      e_h=env::type_id::create("envi",this);
      uvm_config_db #(bit)::set(this,"*","no_of_agents",10);
      uvm_config_db #(bit)::set(this,"*","is_active",1);
      $display("size of agent is %0d",e_h.a_h.size());
     endfunction

endclass

module tb;
    test t;
    initial begin
        t=new();
      run_test();
 
    end
