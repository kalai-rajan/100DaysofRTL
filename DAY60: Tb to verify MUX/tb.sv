module a_mux41(s1,s0,i,y);
    input s1,s0;
    input [3:0]i;
    output reg y;

    always @(*) begin
        case({s1,s0})
            2'd0: y=i[0];
            2'd1: y=i[1];
            2'd2: y=i[2];
            2'd3: y=i[3];
        endcase
    end

endmodule


interface intf;
 
logic [3:0]i;
logic y,s1,s0;

endinterface

class transaction;

  randc bit[3:0]i;
  randc bit s1,s0;
  bit y;
  

    task display(string name);
        
      $display( "%0s\t{s1,s0}=%b%b\ti=%b\ty=%b\t@(%0d)",name,s1,s0,i,y,$time);
       
        
    endtask
endclass
//-------------------------------------------------------------------------------
class generator;
    mailbox gen2driv;
	int i=1;
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
              $display("Transection number %0d",i);
                gen2driv.put(t);
                t.display("GENERATOR");
              i++;
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
      a.i=0;
      a.s1=0;
      a.s0=0;
endtask

task main;
    transaction t;
   begin
        #2;
        gen2driv.get(t);
            a.i=t.i;
            a.s1=t.s1;
            a.s0=t.s0;
        t.display("driver");
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
        t.i=a.i;
        t.s1=a.s1;
        t.s0=a.s0;
        t.y=a.y;
     	mon2scb.put(t);
        t.display("monitor");
    end
endtask
endclass

//-------------------------------------------------------------------------------
class scoreboard;
  
  mailbox mon2scb;
  
  function new(mailbox mon2scb);
    this.mon2scb=mon2scb;
  endfunction
  
  task main;
   
    transaction t; 
    begin
    #4;
    mon2scb.get(t);
      if( (t.y) == ( t.s1 ? (t.s0?t.i[3]:t.i[2]) : (t.s0?t.i[1]:t.i[0]) ) )
      $display("SUCESS FROM SCOREBOARD\n");
    else 
      $display("FAILURE FROM SCOREBOARD\n");
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
scoreboard s;
 
driver d;

function new(virtual intf a);

    this.a=a;
    mon2scb=new();
    gen2driv=new();
    g=new(gen2driv);
    d=new(gen2driv,a);
    m=new(mon2scb,a);
  	s=new(mon2scb); 

endfunction

task pretest;
    d.reset();
endtask

task test;
    begin
        g.main();
        d.main();
        m.main();
      	s.main();
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
        $finish();
    end
endprogram
//-------------------------------------------------------------------------------

module tb;

  intf a();

test t1(a);

  a_mux41 dut(a.s1,a.s0,a.i,a.y);

initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------

 
