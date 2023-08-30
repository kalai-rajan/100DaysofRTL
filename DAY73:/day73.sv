class even_number;
  rand int a;
  constraint range{a inside{[100:300]}; }
  constraint condn{a%2==0;}
  
  function void post_randomize();
    $display("EVEN NUMBER = %0d",a);
  endfunction
endclass

module tb;
  even_number e;
  initial begin
  e=new();
    repeat(10)
      e.randomize();
    $finish();
  end
endmodule
