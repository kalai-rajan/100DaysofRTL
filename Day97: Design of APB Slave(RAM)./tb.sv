// Code your testbench here
// or browse Examples
module tb;

reg pclk,presetn,pwrite;
reg penable,psel,transfer;
reg [31:0] paddr,pwrdata;
wire pready,pslverr;
wire [31:0]prdata;
int i=0;
apb_slave dut(pclk,presetn,transfer,psel,penable,paddr,pwrite,pready,pwrdata,pslverr,prdata);


   
     
always #5 pclk=~pclk;


initial begin
     presetn=1; pclk=1;
     repeat(1) @(posedge pclk);
         presetn=0;
         paddr=0;pwrdata=0; pwrite=0;     //idle state
         penable=0;psel=0;transfer=0;
  
     //write transfers
     repeat(8) begin
       
       @(posedge pclk);
        paddr=i;pwrdata=i; pwrite=1;     //setup state
         penable=0;psel=1;transfer=1;
	   
        @(posedge pclk);//acess state
         penable=1;   
       
        i++;
     end
      
      i=0;
     
  //read transfer
      presetn=1; 
     repeat(1) @(posedge pclk);
         presetn=0;
         paddr=0;pwrdata=0; pwrite=0;     //idle state
         penable=0;psel=0;transfer=0;
  
     //read transfers
     repeat(8) begin
       
       @(posedge pclk);
        paddr=i;pwrdata=i; pwrite=0;     //setup state
         penable=0;psel=1;transfer=1;
	   
        @(posedge pclk);//acess state
         penable=1;   
       
        i++;
     end

  $finish();
end
  
  initial begin 
    $dumpfile("dump.vcd"); 
  $dumpvars(1);
    
  end
 
endmodule
