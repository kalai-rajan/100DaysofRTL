
module a_functions_2;    //important program to understand static working.

task static double(int a,string s);
  #5;
  a=a*2;
  $display("$time=%D\t%s\t%d",$time,s,a);
endtask :double
  

initial begin
 
  	 fork
        begin
            double (5,"from thread1");
        end

        begin
		    #2;
            double(4,"from thread 2");    
        end
    join

end
endmodule

 
