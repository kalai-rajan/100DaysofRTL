// Code your testbench here
// or browse Examples
endmodule

module spi_master_tb;
  wire sclk;
  reg rst;
  reg clk;
  reg [11:0]din;
  reg newd;
  wire cs,mosi;
  wire [11:0]data_reg;
  
  spi_master dut (clk,rst,cs,din,newd,mosi,miso,sclk,data_reg);
  
  initial begin
    clk=0;rst=1;din=12'b1010101010101010;
    #5 rst=0;
    #15 newd=1'b1;
    #10 newd=0;
  end
  always #5 clk=~clk;
  
  initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    #300 $finish();
  end
endmodule
