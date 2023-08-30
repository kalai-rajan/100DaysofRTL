class even_number;
  rand bit[3:0] a[];
  string name;
  constraint size_of_array{a.size inside{[15:20]}; }
  constraint condn{foreach(a[i])
                      if(i%2==1)  //even locations
                        a[i]%2==0;
                       else         //odd locations
                         a[i]%2==1;
               	   }
  
  function void post_randomize();
    foreach(a[i]) begin
      name=(i%2==0)?"even":"odd";
      $display("a[%0d]\t@(%0s  location)Value = %0d",i,name,a[i]);
    end
  endfunction
endclass

module tb;
  even_number e;
  initial begin
  e=new();
      e.randomize();
    $finish();
  end
endmodule
