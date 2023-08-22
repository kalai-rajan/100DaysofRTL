// Code your testbench here
// or browse Examples
 module g2b (
    input [3:0]g,
    output [3:0]b
);

assign b[3]=g[3];
assign b[2]=b[3]^g[2];
assign b[1]=b[2]^g[1];
assign b[0]=b[1]^g[0];
    
endmodule
 

//-------------------------------------------------------------------------------
interface intf;
 logic [3:0]b,g;
  

endinterface

class transaction;
rand bit [3:0]g;
  bit [3:0]b;
    task display(string name);
        $display("-----------------------------------");
        $display("%s",name);
        $display("-----------------------------------");
      $display( "(%0d)\t{GRAY CODE}=%b{BINARY CODE}=%b",$time,g,b);
        $display("-----------------------------------");
        
    endtask
endclass
//-------------------------------------------------------------------------------
class generator;
    mailbox gen2driv;

    rand transaction t;


    function new(mailbox gen2driv);
    
    t=new();
    this.gen2driv=gen2driv;

    endfunction

    task main;
        #1;
         begin
            if(! ( t.randomize() ) )
                $fatal("RANDOMIZATION FAILED");
            else begin
                gen2driv.put(t);
              t.display("GENERATOR");
            end
        end
        
    endtask
endclass
//-------------------------------------------------------------------------------
class driver;

virtual intf a;

mailbox gen2driv;

function new(mailbox gen2driv, virtual intf a);
    this.a=a;
    this.gen2driv=gen2driv;
endfunction


task reset;
        a.g=0;
endtask

task main;
    transaction t;
   begin
        #2;
        gen2driv.get(t);
         a.g=t.g;
        t.display("DRIVER");
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
    begin
        #3;
        t=new();
        t.g=a.g;
        t.b=a.b;
        t.display("MONITOR");
      $display(" ");
      $display(" ");
    end
endtask
endclass

//-------------------------------------------------------------------------------
class scoreboard;

mailbox mon2scb;

int no_transactions;

function new(mailbox mon2sb);
    this.mon2scb=mon2scb;
endfunction

task  main;
 transaction t;
  begin
    #4;
    mon2scb.get(t);
    
 end
endtask

endclass
//-------------------------------------------------------------------------------

class environment;

virtual intf a;
mailbox mon2scb;
mailbox gen2driv;
generator g;
monitor m;
 
 
driver d;

function new(virtual intf a);

    this.a=a;
    mon2scb=new();
    gen2driv=new();
    g=new(gen2driv);
    d=new(gen2driv,a);
    m=new(mon2scb,a);
     
     

endfunction

task pretest;
    d.reset();
endtask

task test;
    begin
        g.main();
        d.main();
        m.main();
    end
endtask



task run;
  begin
    pretest();
    test();
  end
    
endtask

endclass
//-------------------------------------------------------------------------------

program test(intf a);
  
    environment env;
    initial begin
        env=new(a);
      repeat(50) 
            env.run();
        $finsih();
    end
endprogram
//-------------------------------------------------------------------------------

module tb;

  intf a();

test t1(a);

  g2b fut(.b(a.b),.g(a.g) );

initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------
