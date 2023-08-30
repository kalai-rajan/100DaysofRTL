module rtc_count(input c_clk,c_rst, h,m,s,   //h,m,se synchroniser butons to set time to current time  after reset 
                     output  reg [3:0]hr_l, hr_m,mn_l,mn_m,se_l,se_m);             

reg [3:0]h_l,h_m,m_l,m_m,s_l,s_m;

always @(posedge c_clk or posedge  c_rst or posedge h  or posedge m or posedge s) begin
    
        if(h) begin

            if(h_l==4'd9) begin     //logic to set time to curren time after  reset using pushbuttons input
                h_l<=0;
                h_m<=h_m+1;
            end
            else if(h_m==4'd2 && h_l==4'd3) begin
                    h_l<=0;
                    h_m<=0;
                end

            else begin
                h_l<=h_l+1;
            end

        end

        else if(m) begin

             if(m_l==4'd9) begin
                m_l<=0;
                m_m<=m_m+1;
                
                if(m_m==4'd5) begin
                    m_m<=0;
                    m_l<=0;
                end
            end
            else begin
                m_l<=m_l+1;
            end

        end

        else if(s) begin

            if(s_l==4'd9) begin
                s_l<=0;
                s_m<=s_m+1;
                if(s_m==4'd5) begin
                    s_m<=0;
                    s_l<=0;
                end
            end

            else begin
                s_l<=s_l+1;
            end

        end
       
        else if (c_rst)begin
        h_l<=0;
        h_m<=0;
        m_l<=0;
        m_m<=0;
        s_l<=0;
        s_m<=0;
        end

    else begin
       
        if(s_l==4'd9) begin
            s_l<=4'd0;
            s_m<=s_m+1'b1;

                if(s_m==5)begin
                    s_m<=4'd0;
                m_l<=m_l+1'b1;

                    if(m_l==4'd9) begin
                        m_l<=4'd0;
                        m_m<=m_m+1'b1;

                            if(m_m==4'd5) begin
                                m_m<=4'd0;
                                h_l<=h_l+1'b1;

                                    if(h_l==4'd3) begin
                                        h_l<=4'd0;
                                        h_m<=h_m+1'b1;

                                        if (h_m==4'd2 && h_l==4'd3 && m_m==4'd5 ) begin
                                             h_m<=0;
                                        end
                                 
                                    end
                            end
                    end
                end
        end
        
        else 
         s_l<=s_l+1'b1;
    end
end

always @(h_m or s_m or m_m or h_l or s_l or m_l) begin
hr_m={h_m};
se_m={s_m};
mn_m={m_m};
hr_l={h_l};
se_l={s_l};
mn_l={m_l};
end
endmodule

module rtc_count_tb;

wire [3:0] HR_M, MN_M, SE_L, HR_L, MN_L,SE_M;
reg C_CLK,C_RST,H,M,S;  

 rtc_count DUT (.c_clk(C_CLK), .c_rst(C_RST), .hr_m(HR_M), .mn_m(MN_M), .se_m(SE_M), .hr_l(HR_L), .mn_l(MN_L), .se_l(SE_L),
 .h(H), .m(M), .s(S));

initial begin
    $monitor("(%0d)\t%0d%0d:\t%0d%0d:\t%0d%0d:\t",$time,HR_M,HR_L,MN_M,MN_L,SE_M,SE_L);
    C_CLK=0; C_RST=1;
    #5 C_RST=0;

    /*repeat(25) begin
        #5 H=0;
        #5 H=1;
    end
    
    repeat(61) begin
        #5 M=0;
        #5 M=1;
    end
     
    repeat(61) begin
        #5 S=0;
        #5 S=1;
    end 
    $finish();*/
end

always #5 C_CLK=~C_CLK;
endmodule




