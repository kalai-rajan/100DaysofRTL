module xyz;

initial
  
    begin :B1
       fork :F1
           
         begin
            #3 $display("%0d\tfrom thread2",$time);
           end
             #2 $display("%0d\t from thread3",$time);
                 
       join_none
          #1 $display("%0d\tthread 1",$time); 
    
    end
  
endmodule
