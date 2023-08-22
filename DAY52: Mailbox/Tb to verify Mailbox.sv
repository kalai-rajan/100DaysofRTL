// Code your testbench here
// or browse Examples
class tx;
  int a;
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx=mbx;
  endfunction
  
  task send();
    mbx.put(a);
  endtask
  
endclass

class rx;
  int a;
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx=mbx;
  endfunction
  
  task receive();
    mbx.get(a);
  endtask
  
endclass

class env;
  rx r_h;
  tx t_h;
  mailbox mbx;
  
  function new();
    mbx=new();
    r_h=new(mbx);
    t_h=new(mbx);  
  endfunction
  
  task main();
    fork
      t_h.send();
      r_h.receive();
    join
    $display("Data sended by TX=%0d",t_h.a);
    $display("Data Received by RX=%0d",r_h.a);
    $finish();
  endtask
  
endclass

module tb;
  env e;
  initial begin
    e=new();
    e.t_h.a=10;
    e.main();
  end
endmodule
