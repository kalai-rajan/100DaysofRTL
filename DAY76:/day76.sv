class pattern;
    rand int a[ ];
    constraint cn{a.size==8;}
    constraint cn1{
                  foreach (a[i]) 
                    a[i] == (i*10)+9;
                   }

    function void post_randomize ();
      $display();
      foreach (a[i]) 
        $write("%0d ",a[i]);
    endfunction
  
endclass    
    
module tb;
  
  pattern p;
  
  initial begin
    p=new();
    p.randomize();
  end
endmodule
