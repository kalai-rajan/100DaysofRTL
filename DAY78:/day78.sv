class pattern;
  rand bit[3:0] a;
  int b[$:7];
  constraint cn1{!(a inside b);}
   
  function void post_randomize ();
    b.push_front(a);
    $write("A=%0d",a);
    if(b.size==7)
      b.pop_back();
    $write("\tPrevious values=%p\n",b);
  endfunction
  
endclass

module tb;
  pattern p;
  initial begin
    p=new();
    $display();
    repeat(10)
      p.randomize();
  end
endmodule
