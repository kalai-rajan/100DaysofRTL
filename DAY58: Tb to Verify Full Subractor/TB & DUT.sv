  module sub(a,b,cin,s,c,clk);
  input [3:0]a,b;
  input cin,clk;
  output   reg [3:0]s;
  output  reg c;
  reg [4:0]temp;
  
  
  always@(posedge clk) begin	
    temp=a-b-cin;
    s=temp[3:0];
    c=temp[4];
  end
 
endmodule



interface intf(input bit clk);
 
  logic [3:0]a,b;
  logic [3:0]s;
  logic cin,c;

endinterface

class transaction;

  randc bit[3:0]a,b;
  bit[3:0]s;
  randc bit cin;
  bit c;

    task display(string name);  
        
      $display("(%0s)\tA=%0d\tB=%0d\tcin=%b\tS=%0d\tC=%b\t@%0d",name,a,b,cin,s,c,$time);
  
        
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
  		a.cin=0;
endtask

task main;
    transaction t;
  forever begin
      
    gen2driv.get(t);
      a.a=t.a;
  		a.b=t.b;
  		a.cin=t.cin;
      t.display("driver");
      ->drivnext;
    end
endtask

endclass
//-------------------------------------------------------------------------------

class monitor;

virtual intf a;

mailbox mon2scb;

function new(mailbox mon2scb, virtual intf a);
    this.mon2scb=mon2scb;
    this.a=a;
endfunction

task main;
    transaction t;
   forever begin
        repeat(2) @(posedge a.clk);
        t=new();
        t.b=a.b;
        t.a=a.a;
      	t.cin=a.cin;
      	t.s=a.s;
      	t.c=a.c;
     	  mon2scb.put(t);
        t.display("monitor");
    end
endtask
endclass

//------------------------------------------------------------------------------------------
  class coverage;
    transaction t;
    mailbox gen2cov;
    covergroup cg;
    c1: coverpoint t.a; 
    c2: coverpoint t.b;
    c3: coverpoint t.cin;
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
class scoreboard;
    event scbnext;
  
  mailbox mon2scb;

  function new(mailbox mon2scb);
    this.mon2scb=mon2scb;
    
  endfunction
  
  task main;
   
    transaction t; 
   forever  begin
   
    mon2scb.get(t);

     if({t.c,t.s} == (t.a-t.b-t.cin) ) begin
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
  
endclass
//-------------------------------------------------------------------------------

class environment;

virtual intf a;
mailbox mon2scb;
mailbox gen2cov;
mailbox gen2driv;
generator g;
monitor m;
scoreboard s;
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
  	s=new(mon2scb); 
    c=new(gen2cov);
  g.drivnext=nextgd;
        d.drivnext=nextgd;
        g.scbnext=nextgs;
        s.scbnext=nextgs;

endfunction

task pretest;
    d.reset();
endtask

task test;
    fork
        g.main();
        d.main();
        m.main();
      	s.main();
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
        env.g.repeat_no=100;
      env.run();
    end
endprogram
//-------------------------------------------------------------------------------

module sub_tb;
  bit clk;
initial begin
        clk=0;
        forever #5 clk=~clk;
    end
  intf a(clk);
  

test t1(a);

  sub dut(a.a,a.b,a.cin,a.s,a.c,a.clk);

initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------

 
