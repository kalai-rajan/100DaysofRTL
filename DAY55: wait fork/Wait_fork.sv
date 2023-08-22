module wait_fork;
  initial begin
    fork 
      
      begin
        //process1 
        $display("START OF PROCESS-1");
        #5;
        $display("END  OF PROCESS-1");
      end
      
      begin
        //process-2 
        $display("START OF PROCESS-2");
        #20;
        $display("END  OF PROCESS-2");
      end

    join_any
    wait fork;
  end
endmodule
