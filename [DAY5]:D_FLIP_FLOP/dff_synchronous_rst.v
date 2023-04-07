module dff_synchronous_rst(
    input d,clk,rst,
    output reg q, output qb
);



always @(posedge clk )
begin
    if(rst)
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

module dff_synchronous_rst_tb;
wire Q,QB;
reg CLK,D,RST;

dff_asynchronous_rst dut(
    .d(D), .clk(CLK), .rst(RST),
      .q(Q), .qb(QB)
);

initial begin
    CLK=0;D=0;RST=0;
    $monitor("%t) CLK=%B RST=%B D=%B Q=%B QB=%B",$time,CLK,RST,D,Q,QB);
    #1RST=0;
    #4RST=1;
    #5 RST=0;
    #10 D=1;
    #10 D=0;
end
always #5 CLK =~CLK;
endmodule
