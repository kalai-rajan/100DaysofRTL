module counter(clk,rst,load,updown,data_in,data_out);
    input clk,rst,load,updown;
    input [3:0]data_in;
    output reg [3:0]data_out;

  always@(posedge clk or posedge rst) begin
        if(rst)
          data_out<=0;
    	else begin
          if(load)
           	  data_out<=data_in;
          else begin
             if(updown)
               data_out<=data_out+1'b1;
              else 
               data_out<=data_out-1'b1;
        end
    end
  end
endmodule

interface intf(input bit clk,rst);

  logic load,updown;
  logic [3:0]data_in,data_out;

endinterface

class transaction;

  rand bit load,updown;
  rand bit[3:0]data_in;
  bit[3:0]data_out;
   
  constraint cn1{ (load != updown); }


    task display(string name);  
      $display("[%0s]\tLOAD=%b\t(UPDOWN)=%b\t(DATA_IN)=%b\t(DATA_OUT)=%b\t@%0d",name,load,updown,data_in,data_out,$time);
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
  wait(a.rst==1);
      a.load=0;
      a.data_in=0;
      a.updown=0;
  wait(a.rst==0);
endtask

task main;
    transaction t;
  forever begin
      
    gen2driv.get(t);
       a.load=t.load;
      a.data_in=t.data_in;
      a.updown=t.updown;
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
        t.load=a.load;
        t.updown=a.updown;
        t.data_in=a.data_in;
        t.data_out=a.data_out;
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
    c1: coverpoint t.load;
    c2: coverpoint t.data_in;
    c3: coverpoint t.updown;

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
        env.g.repeat_no=100;
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
      repeat(5) @(posedge clk);
      rst=0;
    end
  intf a(clk,rst);
  

test t1(a);

  counter dut(a.clk,a.rst,a.load,a.updown,a.data_in,a.data_out);

initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------

 
