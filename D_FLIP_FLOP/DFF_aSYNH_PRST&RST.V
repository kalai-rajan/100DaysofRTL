module dff_asynchronous_prst_rst(
    input d,clk,prst,rst,
    output reg q, output qb
);



always @(posedge clk or posedge prst)
begin
    if(prst)
      q<=1;
    else if(rst)
       q<=0;
    else
      begin
        if(clk)
        begin
          q<=d;
        end  
        else
         begin
            q<=q;
        end
      end
end

assign qb=~q;
endmodule

module dff_asynchronous_prst_rst_tb;
wire Q,QB;
reg CLK,D,PRST,RST;

dff_asynchronous_prst_rst dut(
    .d(D), .clk(CLK), .prst(PRST), .rst(RST),
      .q(Q), .qb(QB)
);
always #5 CLK =~CLK;
initial begin
    CLK=0;D=0;PRST=0;RST=0;
    $monitor("%t) CLK=%B PRST=%B RST =%B D=%B Q=%B QB=%B",$time,CLK,PRST,RST,D,Q,QB);
     #4 PRST=1;
     #6 PRST=0;
     #5 D=0;
     #10 D=1;
     #10 D=0;
     #4 RST=1;
     #6 RST=0;
end

endmodule