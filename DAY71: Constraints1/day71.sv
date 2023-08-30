class pattern_0102030405;
  rand int a[];
  constraint size {a.size==10;}
  constraint content {foreach(a[i])
                        if(i%2==0)
                          a[i]==0;
                        else
                          a[i]== ((i+1)/2);}
endclass

module tb;
  initial begin
  pattern_0102030405 p1;
  p1=new();
    p1.randomize();
    $display();
    foreach(p1.a[i]) begin
      $write("%0d",p1.a[i]);
    end
    $display();
  end
endmodule
