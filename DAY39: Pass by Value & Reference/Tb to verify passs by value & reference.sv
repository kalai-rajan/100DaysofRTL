module a_functions_pass_by_reference;

task automatic  pass_by_ref(ref int a);
#5;
a=a*2;
endtask  

task   pass_by_value(int a);
#5;
a=a*2;
endtask 

int a;

initial begin
    a=10;
  	$display("value of a before pass_by_ref=%0d",a);
	pass_by_ref(a);
  	$display("value of a after pass_by_ref=%0d",a);
  	a=20;
    $display("value of a before pass_by_ref=%0d",a);
	pass_by_value(a);
  	$display("value of a after pass_by_ref=%0d",a);
end
endmodule
