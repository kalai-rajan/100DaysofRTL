module rtc_top(
               input clk,rst,h,m,s,
               output [6:0]h_l,h_m,m_l,m_m,s_l,s_m
);
wire [3:0]hl,hm,ml,mm,sl,sm;
wire n_clk;

rtc_clock_div  dut1(.i_clk(clk), .rst(rst), .o_clk(n_clk)); 

rtc_count   dut2(.c_clk(n_clk), .c_rst(rst),  .h(h),.m(m), .s(s),  
                     .hr_l(hl), .hr_m(hm), .mn_l(ml), .mn_m(mm), .se_l(sl), .se_m(sm) );  

rtc_7seg  dut3(.bcd(hl), .seg(h_l));
rtc_7seg  dut4(.bcd(hm), .seg(h_m)); 
rtc_7seg  dut5(.bcd(ml), .seg(m_l));

rtc_7seg  dut6(.bcd(mm), .seg(m_m));
rtc_7seg  dut7(.bcd(sl), .seg(s_l));
rtc_7seg  dut8(.bcd(sm), .seg(s_m));


endmodule

module rtc_top_tb;

reg CLK,RST,H,M,S;
wire [6:0]H_L,H_M, M_L,M_M,S_L,S_M;

rtc_top dut9 (.clk(CLK), .rst(RST), .h(H), .m(M), .s(S), .h_l(H_L), .h_m(H_M), .m_m(M_M), .m_l(M_L), .s_l(S_L), .s_m(S_M));

initial begin
     $monitor("(%0d)\t%0d%0d:\t%0d%0d:\t%0d%0d:\t",$time,dut9.hm,dut9.hl,dut9.mm,dut9.ml,dut9.sm,dut9.sl);
     CLK=0;RST=1;
     H=0;M=0;S=0;
     #5RST=0;
end

always #5 CLK=~CLK;

endmodule