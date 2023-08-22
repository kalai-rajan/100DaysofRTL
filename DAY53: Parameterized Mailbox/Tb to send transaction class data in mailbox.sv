interface intf(input bit clk,rst);
  logic rd_en,wr_en,full,empty,rd_error,wr_error;
  logic [3:0]w_data_in,r_data_out;
endinterface
//------------------------------------------------------------------------------------------------

class transaction;
    rand bit rd_en,wr_en;
    rand bit[3:0]w_data_in;
    bit full,empty,rd_error,wr_error;
    bit [3:0]r_data_out;

    constraint cn1 {rd_en != wr_en; }

    function void  display(string s);
        $display("%s\twr_en=%b\t\trd_en=%b\t\tw_data_in=%0d \t\trd_data_out=%0d \t\tfull=%b\t\tempty=%b\t\t@%0d",s,wr_en,rd_en,w_data_in,r_data_out,full,empty,$time);
    endfunction

    

endclass
 
//------------------------------------------------------------------------------------------------- 
class generator;
  
    mailbox   gen2driv;

    event ended;
    event next;

    int repeat_no;

    function new(mailbox   gen2driv);
        this.gen2driv=gen2driv;
    endfunction

    task main();
        transaction t;
        repeat (repeat_no) begin
            t=new();
            if(!t.randomize()) 
                $fatal("RANDOMIZATION FAILED");
            else 
                gen2driv.put(t);
            t.display("GENERATOR ");
            @(next);
        end
        ->ended;
        
    endtask

endclass

//------------------------------------------------------------------------------------------------- 
class driver;

     mailbox  gen2driv;

    virtual intf intf_h;

    int no_trans;

    event next;

    function new(mailbox  gen2driv,virtual intf intf_h );
            this.gen2driv=gen2driv;
            this.intf_h=intf_h;
    endfunction

    task reset();
        wait(intf_h.rst);
        intf_h.wr_en<=0;
        intf_h.rd_en<=0;
        intf_h.w_data_in<=0;
        wait(!intf_h.rst);     
    endtask

    task main();
        transaction t;
        forever begin
           gen2driv.get(t);   
           intf_h.wr_en<=t.wr_en;
           intf_h.rd_en<=t.rd_en;
           intf_h.w_data_in<=t.w_data_in;
          repeat(1) @(posedge intf_h.clk); 
          t.display("DRIVER    "); 
          
           no_trans++;
            ->next; 
          repeat(2) @(posedge intf_h.clk);
          
        end

    endtask

endclass
//------------------------------------------------------------------------------------------------- 

class environment;
    generator g;
    driver d;
  event nextgd;
     
    mailbox gen2driv;
     
    virtual intf intf_h;
     

    function new(virtual intf intf_h );
         
        gen2driv=new();
        g=new(gen2driv);
        d=new(gen2driv,intf_h);
        g.next=nextgd;
        d.next=nextgd;
         
    endfunction

    task pretest();
        d.reset();
    endtask

    task test();
      
      fork
        g.main();
        d.main();
        
      join_any
    endtask

    task posttest();
      wait(g.ended.triggered);
      $finish();
    endtask

    task run();
        pretest();
        test();
        posttest();
        $finish();
    endtask

endclass
//------------------------------------------------------------------------------------------------- 

 program test(intf intf_h);
    environment e;
    initial begin
        e=new(intf_h);
        e.g.repeat_no=5;
        e.run();
    end
endprogram

//------------------------------------------------------------------------------------------------- 
module tb;
    
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
    intf intf_h(clk,rst);
    test a(intf_h);

endmodule

