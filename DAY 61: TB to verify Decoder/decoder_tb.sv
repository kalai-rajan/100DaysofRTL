// Code your testbench here
// or browse Examples
 module  three_bit_decoder (
   input [2:0]ip,                       //ip lines
    input clk, rst,                        
    output reg y0,y1,y2,y3,y4,y5,y6,y7     //op lines 
);

always @(posedge clk)
begin
  if(rst)
  {y0,y1,y2,y3,y4,y5,y6,y7}<=8'b0;
  else 
    case (ip)
        3'd0:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00000001;
        3'd1:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00000010;
        3'd2:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00000100;             
        3'd3:{y7,y6,y5,y4,y3,y2,y1,y0}=8'd16;
        3'd4:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00010000;
        3'd5:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b00100000; 
        3'd6:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b01000000;
        3'd7:{y7,y6,y5,y4,y3,y2,y1,y0}=8'b10000000; 
        default: {y7,y6,y5,y4,y3,y2,y1,y0}=8'bz;
    endcase
end
endmodule
//-------------------------------------------------------------------------------
interface intf(input bit clk,rst);
 
  logic [2:0]ip;
  logic y0,y1,y2,y3,y4,y5,y6,y7;

endinterface
//-------------------------------------------------------------------------------
class transaction;

  rand bit[2:0]ip;
  bit[3:0]s;
  logic y0,y1,y2,y3,y4,y5,y6,y7;

    task display(string name);  
        
      $display("(%0s)\tip=%d\top=%b\t@%0d",name,ip,{y7,y6,y5,y4,y2,y1,y0}, $time);
  
        
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
  wait(a.rst==0);
endtask

task main;
    transaction t;
  forever begin
      
    gen2driv.get(t);
        a.ip=t.ip;
      t.display("driver");
      ->drivnext;
    end
endtask

endclass
//-------------------------------------------------------------------------------

class monitor;

virtual intf a;
event scbnext;

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
        t.ip=a.ip;
        t.y0=a.y0;
        t.y1=a.y1;
        t.y2=a.y2;
        t.y3=a.y3;
        t.y4=a.y4;
        t.y5=a.y5;
        t.y6=a.y6;
        t.y7=a.y7;
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
    c1: coverpoint t.ip;
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

     if(  ) begin
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
        env.g.repeat_no=30;
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
  intf t(clk,rst);
  

test t1(t);

  three_bit_decoder dut(t.ip,t.clk,t.rst,t.y0,t.y1,t.y2,t.y3,t.y4,t.y5,t.y6,t.y7);

initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
endmodule

//-------------------------------------------------------------------------------

 
