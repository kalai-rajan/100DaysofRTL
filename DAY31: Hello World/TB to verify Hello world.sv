class hello;
  
  function void display();
    $display("HELLO WORLD");
  endfunction
  
endclass

module tb;
  initial begin
    hello a;
    a=new( );
    a.display();
  end
endmodule
