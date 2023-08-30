class pattern;
  rand bit a;
  bit b=0;
  constraint cn1{a!=b;}
   
  function void post_randomize ();
    $write("%0d%0d",a,b);
  endfunction
  
endclass

module tb;
  pattern p;
  initial begin
    p=new();
    $display();
    repeat(5)
      p.randomize();
  end
endmodule
