module a_jk_flip_flop(input j,k,rst,clk,
                      output  reg q,
                      output qb);

always @(posedge clk ) begin
    if(rst) 
      q<=0;
    else begin
        case ({j,k})
            2'b00: q<=q;
            2'b01: q<=1'b0;
            2'b10: q<=1'b1;
            2'b11: q<=~q;
            
        endcase
    end
end
assign qb=~q;
endmodule

interface intf(input bit clk,rst);

  logic j,k;
  logic q,qb;

endinterface

class transaction;

  rand bit j,k;
  bit q,qb;
   
  

    task display(string name);  
      $display("[%0s]\tJ=%b\t(K)=%b\t(Q)=%b\t(Qb)=%b\t@%0d",name,j,k,q,qb,$time);
    endtask
    
endclass
//-------------------------------------------------------------------------------
class generator;
    mailbox gen2driv;
    mailbox gen2cov;
    event drivnext;
    event scbnext;
     event scbnext2;
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
            //@(scbnext);
            @(scbnext2);
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
      a.j=0;
      a.k=0;
  wait(a.rst==0);
endtask

task main;
    transaction t;
  forever begin
      
    gen2driv.get(t);
       a.k=t.k;
      a.j=t.j;
    t.display("DRIVER");
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
        t.j=a.j;
        t.k=a.k;
        t.q=a.q;
        t.qb=a.qb;
     	  mon2scb.put(t);
     t.display("MONITOR");
        //->scbnext;
    end
endtask
endclass

//------------------------------------------------------------------------------------------
  class coverage;
    transaction t;
    mailbox gen2cov;
    covergroup cg;
    c1: coverpoint t.j;
    c2: coverpoint t.k;
    c3: cross c1,c2;

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
    event scbnext2;
    bit tmp;
  
  mailbox mon2scb;
   transaction t; 
  
  function new(mailbox mon2scb);
    this.mon2scb=mon2scb;
    t=new();
  endfunction
  
  task main;
   
   
   forever  begin
   
    mon2scb.get(t);
  
    // Qn+1 = Q’nJ + QnK’
     if({t.q} == ( (~tmp&t.j) || (tmp & ~t.k)) ) begin
      t.display("SCOREBOARD");
       $display("VERIFICATION OF TEST CASE SUCESS");
     end
    else begin
      t.display("SCOREBOARD");
       $display("VERIFICATION OF TEST CASE FAILURE");
    end
       tmp=t.q;
   	->scbnext2;
    
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
     event nextgs2;
 
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
        m.scbnext=nextgs;
         g.scbnext2=nextgs2;
         s.scbnext2=nextgs2;

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
        env.g.repeat_no=35;
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

  a_jk_flip_flop dut(a.j, a.k, a.rst, a.clk, a.q,a.qb);

initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------

 
