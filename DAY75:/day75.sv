class ones_constraint;
  rand bit [31:0]a;
  constraint ones_condn{$countones(a)==12;}
  constraint non_consecutive_ones{foreach (a[i])
                                    if(i>0 && a[i]==1)
                                      a[i]!=a[i-1];
                                   }
  function void post_randomize();
    $write("\na=");
    foreach (a[i])
      $write("%b",a[i]);
    $write(" no_of_ones=%0d",$countones(a));
  endfunction
 
endclass

module tb;
  
  ones_constraint o;
  initial begin 
    o=new();
    repeat(5)
      o.randomize();

  end
endmodule
