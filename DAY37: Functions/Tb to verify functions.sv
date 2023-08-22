module a_functions;
int a,b,c;
//System Verilog function with return values with output port
  function void sum(input int a,b, output int c);
      c=a+b;
  endfunction
  
//System Verilog function with return value without  output port   
  function int sum2(input int a,b);
      sum2=a+b;
  endfunction
  
  
//System Verilog function without return types & default arguments
  function void sum3(input int a=1, b=20);
      int  z;
      z=a+b;
      $display("%dfrom function 3",z);
  endfunction
  
//System Verilog function with   return keyword
  	 function int sum4(input int  a,b ,output int c);
 		c=a+b+1; 
		return(a+b);
	endfunction

initial begin

a=10; b=20;
  sum(a,b,c);
  $display("%dfrom function 1",c);
  
  $display("%dfrom function2",c);
  
  sum3( );
  
  $display("%dfrom function 4 ",sum4(a,b,c));

end 

endmodule
