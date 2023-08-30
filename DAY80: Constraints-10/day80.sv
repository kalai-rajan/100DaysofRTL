class unique_array;
  rand int a[10];
  constraint randomise_range{foreach (a[i])
    a[i] inside {[1:100]};
              }
    constraint y{foreach (a[i])
      				foreach (a[j])
                      if(i!=j)
                        a[j]!=a[i];
              } 
endclass

module tb;
  unique_array u;
  initial begin
    u=new();
    u.randomize();
    $display();
    foreach(u.a[i]) begin
      $write("%0d ",u.a[i]);
    end
  end
endmodule
