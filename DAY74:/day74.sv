class abc;
  rand bit[7:0]randv1;
  rand bit[7:0]randv2;
  
  constraint cond{randv1!=randv2;}
  constraint cond_ones{$countones(randv2)==5;}
  
  function void display();
    $display("\nVariable1=%b\nVariable2=%b\n",randv1,randv2);
  endfunction
endclass

module tb;
  
  initial begin
  abc p;
  p=new();
  repeat(10)begin
    p.randomize();
    p.display();
  end
    
  end
endmodule
