module rtc_clock_div (input i_clk,rst, output  reg o_clk);

reg [31:0]count;

always @(posedge i_clk or posedge rst) begin
    if(rst) begin
        count<=0;
        o_clk<=0;
    end
    else if(count==32'd250) begin   //ACTUAL VALUE SHOULD BE 25_000_000 
        o_clk<=1;                      //Value reduced for simulation purpose
        count<=count+1;
    end
    else  if(count==32'd500) begin  //ACTUAL VALUE SHOULD BE 50_000_000 
        o_clk<=0;
        count<=0;
    end
    else 
      count<=count+1;
    
end
endmodule

module rtc_clock_div_tb;

wire O_CLK;
reg CLK,RST;

rtc_clock_div dut(.i_clk(CLK), .o_clk(O_CLK), .rst(RST));

initial begin
    CLK=0; RST=1;
    #5 RST=0;
end

always #5 CLK=~CLK;
endmodule