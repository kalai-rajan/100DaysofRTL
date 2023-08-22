module  tb_example_for_logic;
  logic en;
  logic data;
  
  initial begin
  
    $display("(%0d)value of data=%b\ten=%b",$time,data,en);
    data=1'd1;
    $display("(%0d)value of data=%b\ten=%b",$time,data,en);
    data=1'd0;
  end
  assign en=1'd0;
  
endmodule
