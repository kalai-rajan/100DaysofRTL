module events_ex;
  event ev_1; 
  event ev_2; 
  event ev_3; 
  
  initial begin
    fork
       
      begin
        #6;
        $display($time,"\tTriggering The Event ev_1");
        ->ev_1;
      end
       
      begin
        #2;
        $display($time,"\tTriggering The Event ev_2");
        ->ev_2;
      end
       
      begin
        #1;
        $display($time,"\tTriggering The Event ev_3");
        ->ev_3;
      end
      
      begin
        wait_order(ev_2,ev_1,ev_3)
          $display($time,"\tEvent's triggerd Inorder");
        else 
          $display($time,"\tEvent's triggerd Out-Of-Order");
      end
    join
  end
endmodule
