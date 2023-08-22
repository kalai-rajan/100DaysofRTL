module dff_asynchronous_rst(
    input d,clk,rst,
    output reg q, output qb
);



always @(posedge clk or posedge rst)
begin
    if(rst)
      q<=0;
    else
     begin
        if(clk)
        begin
          q<=d;
        end  
        else
         begin
            q<=q;
        end
    end
end

assign qb=~q;
endmodule


// Code your testbench here
// or browse Examples


interface intf(input bit clk,rst);
 
  logic  d;
  logic  q,qb;
  

endinterface

class transaction;

  rand bit d;
  bit q,qb;

  task display(string s);  
        
      $display("(%0s)\tD=%b\tQ=%b\tQB=%b\T@%0d",s,d,q,qb,$time);
  
        
    endtask
endclass
//-------------------------------------------------------------------------------
class generator;
    mailbox gen2driv;
    mailbox gen2cov;
    mailbox gen2scb;
    event drivnext;
    event scbnext;
  event ended;
  int i=1;
  int repeat_no;

    function new(mailbox  gen2driv, mailbox gen2cov,mailbox gen2scb);
        this.gen2driv=gen2driv;
        this.gen2cov=gen2cov;
        this.gen2scb=gen2scb;
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
                gen2scb.put(t);
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
      a.d<=0;
endtask

task main;
    transaction t;
  forever begin
      
    gen2driv.get(t);
       a.d<=t.d;
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
        t.d=a.d;
        t.q=a.q;
        t.qb=a.qb;
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
    c1: coverpoint t.d; 
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
  mailbox gen2scb;
  



  function new(mailbox mon2scb,mailbox gen2scb);
    this.mon2scb=mon2scb;
    this.gen2scb=gen2scb;
    
  endfunction
  
  task main;
   
    transaction ts,tg;
   forever  begin
   
    mon2scb.get(ts);
    gen2scb.get(tg);

     if({ts.q} == (tg.d) ) begin
      ts.display("SCOREBOARD");
       $display("VERIFICATION OF TEST CASE SUCESS");
     end
    else begin
      ts.display("SCOREBOARD");
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
mailbox gen2scb;
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
    gen2scb=new();
  g=new(gen2driv,gen2cov,gen2scb);
    d=new(gen2driv,a);
    m=new(mon2scb,a);
  	s=new(mon2scb,gen2scb); 
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
        env.g.repeat_no=5;
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
    	repeat(2)@(posedge clk);
    	rst=0;
    end
  intf a(clk,rst);
  

test t1(a);

 dff_asynchronous_rst dut(.d(a.d), .clk(a.clk), .rst(a.rst), .q(a.q), .qb(a.qb) ) ;

initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------

 
