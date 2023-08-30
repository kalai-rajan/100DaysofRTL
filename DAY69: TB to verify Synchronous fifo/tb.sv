
interface intf(input bit clk,rst);
  logic rd_en,wr_en,full,empty,rd_error,wr_error;
  logic [3:0]w_data_in,r_data_out;

    clocking driv_cb @(posedge clk);
     output rd_en,wr_en;
     output w_data_in;
     input full,empty;
     input rd_error,wr_error;
     input r_data_out;
    endclocking

    clocking mon_cb @(posedge clk);
     input rd_en,wr_en;
     input w_data_in;
     input full,empty;
     input rd_error,wr_error;
     input r_data_out;
    endclocking

  modport mon (clocking mon_cb, input clk,rst);  //learnings how to acess modports
    modport d (clocking driv_cb, input clk,rst);
endinterface

//----------------------------------------------------------------------------------------------------

class transaction;
    rand bit rd_en,wr_en;
    randc bit[3:0]w_data_in;
    bit full,empty,rd_error,wr_error;
    bit [3:0]r_data_out;

    constraint cn1 {rd_en != wr_en; }

    function void  display(string s);
        $display("%s\twr_en=%b\t\trd_en=%b\t\tw_data_in=%0d \t\trd_data_out=%0d \t\tfull=%b\t\tempty=%b\t\t@%0d",s,wr_en,rd_en,w_data_in,r_data_out,full,empty,$time);
    endfunction
    

endclass

//----------------------------------------------------------------------------------------------------

class generator;

    mailbox   gen2driv;
	 
    event ended;
    event drvnext;
  	event scbnext;

    int repeat_no;
    int i;

  function new(mailbox   gen2driv);
        this.gen2driv=gen2driv;
    	 
    endfunction

    task main();
        transaction t;
        t=new();
        i=1;
        
        repeat (repeat_no) begin
            
            if(!t.randomize()) 
                $fatal("RANDOMIZATION FAILED");
            else begin 
                gen2driv.put(t);
               
            end
          $display("TRANSACTION NUMBER = %0d",i);
            t.display("GENERATOR ");
          @(drvnext);
          @(scbnext);
          i++;
        end
        ->ended;
        $display(" ");
    endtask

endclass

//----------------------------------------------------------------------------------------------------

class driver;

     mailbox  gen2driv;
	event drvnext;
    virtual intf intf_h;

     

    event next;

    function new(mailbox  gen2driv,virtual intf intf_h );
            this.gen2driv=gen2driv;
            this.intf_h=intf_h;
    endfunction

    task reset();
        wait(intf_h.rst);
        intf_h.driv_cb.wr_en<=0;
        intf_h.driv_cb.rd_en<=0;
        intf_h.driv_cb.w_data_in<=0;
        wait(!intf_h.rst);     
    endtask

    task main();
        transaction t;
        forever begin
          gen2driv.get(t);  
           intf_h.driv_cb.wr_en<=t.wr_en;
           intf_h.driv_cb.rd_en<=t.rd_en;
           intf_h.driv_cb.w_data_in<=t.w_data_in;
          t.display("DRIVER    "); 
          
            
           ->drvnext; 
          
          
        end

    endtask

endclass

//----------------------------------------------------------------------------------------------------
class monitor;
    mailbox mon2scb;
    mailbox mon2cov;
    virtual intf intf_h;

  function new(mailbox  mon2scb, mailbox mon2cov,virtual intf intf_h );
            this.mon2scb=mon2scb;
    		this.mon2cov=mon2cov;
            this.intf_h=intf_h;
    endfunction

    task main();
        transaction t;
      	
        forever begin
          t=new(); 
          repeat(1) @(posedge intf_h.clk); 
         		
             t.wr_en=intf_h.wr_en;  
             t.rd_en=intf_h.rd_en;
             t.w_data_in=intf_h.w_data_in;
          	 t.r_data_out=intf_h.r_data_out;
             t.full=intf_h.full;
             t.empty=intf_h.empty;
             t.rd_error=intf_h.rd_error;
             t.wr_error=intf_h.wr_error;
          
         	 mon2scb.put(t);  
             mon2cov.put(t);
               
        
               t.display("MONITOR   ");   
            
             
           
        end
    endtask

endclass
//----------------------------------------------------------------------------------------------------
class coverage;
    transaction t;
    mailbox mon2cov;
    covergroup cg;
      c1: coverpoint  t.wr_en {bins b0={0};bins b1={1};}
      c2: coverpoint  t.rd_en {bins b0={0};bins b1={1};}
      c3: coverpoint  t.w_data_in {bins b0 = {1}; bins b5 = {6}; bins b10 = {11};
                                bins b1 = {2}; bins b6 = {7}; bins b11 = {12};
                                bins b2 = {3}; bins b7 = {8}; bins b12 = {13};
                                bins b3 = {4}; bins b8 = {9}; bins b13 = {14};
                                bins b4 = {5}; bins b9 = {10}; bins b14 = {15};
                                bins b15= {0};}
       // c4: cross c1,c2;
    endgroup

  	function new(mailbox mon2cov);
    	this.mon2cov=mon2cov; 
        t=new();
   	 	cg=new();
    endfunction

    task main();
      forever begin
       mon2cov.get(t);
       cg.sample(); 
      end
    endtask

    task display();
      $display("COVERAGE=%f",cg.get_coverage());
    endtask

endclass
//----------------------------------------------------------------------------------------------------
class scoreboard;
	event scbnext;  
    mailbox mon2scb;
      
    bit[3:0] din[$];
    bit [3:0]temp;
    bit f,e,m;
    int i;
  	event next;
    virtual intf intf_h;
  	int q[$];
 
     
  
     
  	function new(mailbox  mon2scb ,virtual intf intf_h );
            this.mon2scb=mon2scb;
            this.intf_h=intf_h;
    endfunction

    task main();
      transaction t;
     	i=1;
      forever begin

        
        mon2scb.get(t);
        
         t.display("SCOREBOARD");

        if(t.wr_en) begin

          if(din.size!=8) begin
              din.push_front(t.w_data_in);
              $display("DATA WRITTEN ON FIFO IS %d",t.w_data_in);
             // $display(" ");
           end
           else begin
              $display("FIFO FULL");
              // $display(" ");
           end
          
              if(din.size==0 && t.empty)
                 $display("EMPTY SIGNAL VERIFICATION IS SUCESS");
              else if(din.size!=0 && ~t.empty)
                 $display("EMPTY SIGNAL VERIFICATION IS SUCESS");
              else begin
                q.push_front(i);
                $display("EMPTY SIGNAL VERIFICATION IS FAILURE SIZE=%0d",din.size());
              end
            if(din.size==8 && t.full)
                    $display("FULL SIGNAL VERIFICATION IS SUCESS");
            else if(din.size!=8 && ~t.full)
                    $display("FULL SIGNAL VERIFICATION IS SUCESS");
            else  begin
              $display("FULL SIGNAL VERIFICATION IS FAILURE SIZE=%0d",din.size());
                 
              q.push_front(i);
            end
            $display(" ");

        end
       

        if(t.rd_en) begin

          if(din.size!=0) begin
            temp=din.pop_back();
            if(t.r_data_out==temp) begin
              $display("SCB-SUCESS");
              $display(" "); 
              end 
           else begin
              $display("SCB-FAILURE"); 
               //$display(" ");
            end
          end
         else begin
          $display("FIFO EMPTY");
          //$display(" ");
         end
         
       		 if(din.size==0 && t.empty)
                 $display("EMPTY SIGNAL VERIFICATION IS SUCESS");
              else if(din.size!=0 && ~t.empty)
                 $display("EMPTY SIGNAL VERIFICATION IS SUCESS");
              else begin
                q.push_front(i);
                $display("EMPTY SIGNAL VERIFICATION IS FAILURE SIZE=%0d",din.size());
              end
            if(din.size==8 && t.full)
                    $display("FULL SIGNAL VERIFICATION IS SUCESS");
            else if(din.size!=8 && ~t.full)
                    $display("FULL SIGNAL VERIFICATION IS SUCESS");
            else  begin
              $display("FULL SIGNAL VERIFICATION IS FAILURE SIZE=%0d",din.size());
                 
              q.push_front(i);
            end
            $display(" ");

         
      end
       

            i++;
        
        ->scbnext;
        end 
     
        
    endtask
  
  	  

    task report_g;
     transaction t;
      int i;
      int temp;
      
      if(q.size()) begin
        $display("The  Failed Transections Numbers are ");
          foreach (q[i]) begin
            $display("%0d",q[i]);
          end
      end
      else
        $display("Passed all testcases");
    endtask



endclass
//----------------------------------------------------------------------------------------------------
class environment;
    generator g;
    driver d;
    coverage c;
    monitor m;
    mailbox gen2driv;
    mailbox mon2scb;
  	mailbox mon2cov;
  	 
    virtual intf intf_h;
    scoreboard s;

  	event nextgs;
  	event nextgd;
    

    function new(virtual intf intf_h );
        mon2scb=new();
        gen2driv=new();
      	mon2cov=new(); 
      	g=new(gen2driv);
        d=new(gen2driv,intf_h);
        m=new(mon2scb,mon2cov,intf_h);
        s=new(mon2scb,intf_h);
      	c=new(mon2cov);
        
		g.scbnext = nextgs;
   		s.scbnext = nextgs;
      	g.drvnext = nextgd;
   		d.drvnext = nextgd;
    endfunction

    task pretest();
        d.reset();
    endtask

    task test();
      
      fork
        g.main();
        d.main();
        m.main();
        c.main();
        s.main();
       
      join_any
    endtask

    task posttest();
        wait(g.ended.triggered);
    endtask

    task run();
        pretest();
        test();
        posttest();
      $display("-------------------------------------------------------------------------------");
        s.report_g();
       $display("-------------------------------------------------------------------------------");
        c.display();
       $display("-------------------------------------------------------------------------------");
        $finish();
    endtask

endclass
//----------------------------------------------------------------------------------------------------
program test(intf intf_h);
    environment e;
    initial begin
        e=new(intf_h);
        e.g.repeat_no=200;
        e.run();

    end
endprogram
//----------------------------------------------------------------------------------------------------

module synch_fifo_top2;
    
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
  synch_fifo_sv ttd (.rst(intf_h.rst),.clk(intf_h.clk),.rd_en(intf_h.rd_en),.wr_en(intf_h.wr_en),.w_data_in(intf_h.w_data_in),.full(intf_h.full),.empty(intf_h.empty),.wr_error(intf_h.wr_error),.rd_error(intf_h.rd_error),.r_data_out(intf_h.r_data_out));

endmodule
