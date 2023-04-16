module a_clock_divide_even #(parameter N=2) (input i_clk, rst,
                         output reg o_clk);

  
reg [31:0]count;
reg [31:0] TC=(N/2-1);

always @(posedge i_clk or posedge rst ) begin
    if(rst) begin
      count<=0;
      o_clk<=0;
    end

    else if(count==TC) begin
        o_clk<=1;
        count<=count+1;
    end

    else if(count==N-1) begin
        o_clk=0;
        count<=0;
        
    end
    
    else 
     count<=count+1;
end
endmodule

module a_clock_divide_even_tb;

wire O_CLK;
reg  RST,I_CLK;

a_clock_divide_even #(.N(10)) dut (.i_clk(I_CLK), .rst(RST), .o_clk(O_CLK));

initial begin
    RST=1;I_CLK=1;
    #5 RST=0;
end

always #5 I_CLK = ~I_CLK;
endmodule
