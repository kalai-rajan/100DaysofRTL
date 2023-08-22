// Code your testbench here
// or browse Examples
class packet;
  rand int a;
  rand bit[5:0]b;

    function void pre_randomize();
      $display("RANDMIZATION STARTED");
  	endfunction
  
  	function void post_randomize();
    	$display("RANDMIZATION ENDED");
  	endfunction
  
endclass

module tb;
  
initial begin
  packet p1;
  p1=new();
  repeat(2) begin
    if(!p1.randomize)
      $fatal("RANDOMIZATION FAILED");
    else 
      $display("%p",p1);
      
  end
end
  
endmodule
