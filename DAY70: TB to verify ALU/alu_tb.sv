
interface intf(input bit clk,rst);
 
  logic [3:0]a,b,opcode;
  logic [15:0]alu_out;

endinterface

class transaction;

  rand bit [3:0]a,b,opcode;
  bit [15:0]alu_out;
  bit i=1;
   
 

    task display(string name);  
        
      $display("(%0s)\tA=%0d\tB=%0d\tOPCODE=%0d\tALU_OUT=%0d\t@%0d",name,a,b,opcode,alu_out,$time);
  
        
    endtask
endclass
//-------------------------------------------------------------------------------
class generator;
    mailbox gen2driv;
    mailbox gen2cov;
    event drivnext;
    event scbnext;
  event ended;
  int i=1;
  int repeat_no;

    function new(mailbox  gen2driv, mailbox gen2cov);
        this.gen2driv=gen2driv;
        this.gen2cov=gen2cov;
     
    endfunction

    task main;
      
      repeat (repeat_no) begin
      transaction t;
 	  t=new();
        if(!t.randomize)
                $fatal("RANDOMIZATION FAILED");
            else begin
                gen2driv.put(t);
                gen2cov.put(t);
                $display(" ");
              	 $display("TRANSECTION NUMBER = %0d",i);
                t.display("GENERATOR");
            end
            @(drivnext);
            @(scbnext);
           i++;
        end
      ->ended;
    endtask
endclass
//-------------------------------------------------------------------------------
class driver;
event drivnext;
virtual intf a;


mailbox gen2driv;

function new(mailbox gen2driv, virtual intf a);
    this.a=a;
    this.gen2driv=gen2driv;
endfunction


task reset;
   @(posedge a.clk);
      a.a=0;
      a.b=0;
      a.opcode=0;
endtask

task main;
    transaction t;
  forever begin
      
    gen2driv.get(t);
      a.a=t.a;
      a.b=t.b;
      a.opcode=t.opcode;
      t.display("driver");
      ->drivnext;
    end
endtask

endclass
//-------------------------------------------------------------------------------

class monitor;
event scbnext;
virtual intf a;

mailbox mon2scb;

function new(mailbox mon2scb, virtual intf a);
    this.mon2scb=mon2scb;
    this.a=a;
endfunction

task main;
    transaction t;
   forever begin
     repeat(1) @(posedge a.clk);
        t=new();
        t.a=a.a;
        t.b=a.b;
        t.opcode=a.opcode;
        t.alu_out=a.alu_out;
     	  mon2scb.put(t);
        t.display("monitor");
        ->scbnext;
    end
endtask
endclass

//------------------------------------------------------------------------------------------
  class coverage;
    transaction t;
    mailbox gen2cov;
    covergroup cg;
    c1: coverpoint t.opcode;
    c2: coverpoint t.a;
    c3: coverpoint t.b;
      
    cross c1,c2,c3; 

  endgroup

  function new(mailbox gen2cov);
    	this.gen2cov=gen2cov; 
        t=new();
   	 	cg=new();
    endfunction

    task main();
      forever begin
       gen2cov.get(t);
       cg.sample(); 
      end
    endtask

    task display();
      $display("COVERAGE=%f",cg.get_coverage());
    endtask

endclass
//-------------------------------------------------------------------------------
/*class scoreboard;
    event scbnext;
  
  mailbox mon2scb;
  
  function new(mailbox mon2scb);
    this.mon2scb=mon2scb;
    
  endfunction
  
  task main;
   
    transaction t; 
   forever  begin
   
    mon2scb.get(t);

     if({t.c,t.s} == (t.a+t.b+t.cin) ) begin
      t.display("SCOREBOARD");
       $display("VERIFICATION OF TEST CASE SUCESS");
     end
    else begin
      t.display("SCOREBOARD");
      $display("VERIFICATION OF TEST CASE SUCESS");
    end
   	->scbnext;
    
   end
  	
   endtask
  
endclass*/
//-------------------------------------------------------------------------------

class environment;

virtual intf a;
mailbox mon2scb;
mailbox gen2cov;
mailbox gen2driv;
generator g;
monitor m;
//scoreboard s;
coverage c;
  event nextgd;
    event nextgs;
 
driver d;

function new(virtual intf a);

    this.a=a;
    mon2scb=new();
    gen2driv=new();
    gen2cov=new();
  g=new(gen2driv,gen2cov);
    d=new(gen2driv,a);
    m=new(mon2scb,a);
  	//s=new(mon2scb); 
    c=new(gen2cov);
  g.drivnext=nextgd;
        d.drivnext=nextgd;
        g.scbnext=nextgs;
        m.scbnext=nextgs;

endfunction

task pretest;
    d.reset();
endtask

task test;
    fork
        g.main();
        d.main();
        m.main();
      	//s.main();
        c.main();
    join_any
endtask

 task post_test();
   wait(g.ended.triggered);
       $display("-------------------------------------------------------------------------------");
        c.display();
      $display("-------------------------------------------------------------------------------");
        $finish();
 endtask

task run;
  begin
    pretest();
    test();
    post_test(); 
         
  end
    
endtask

endclass
//-------------------------------------------------------------------------------

program test(intf a);
  
    environment env;
    initial begin
        env=new(a);
        env.g.repeat_no=990;
      env.run();
    end
endprogram
//-------------------------------------------------------------------------------

module add_tb;
  bit clk,rst;
initial begin
        clk=0;
        forever #5 clk=~clk;
    end
  initial begin
        rst=1;
    repeat(2) @(posedge clk);
    rst=0;
    end
  intf a(clk,rst);
  

test t1(a);

  alu dut(a.a,a.b,a.opcode,a.alu_out,a.clk,a.rst);
initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------

 
