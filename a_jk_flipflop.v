module a_jk_flip_flop(input j,k,rst,clk,
                      output  reg q,
                      output qb);

always @(posedge clk ) begin
    if(rst) 
      q<=0;
    else begin
        case ({j,k})
            2'b00: q<=q;
            2'b01: q<=1'b0;
            2'b10: q<=1'b1;
            2'b11: q<=~q;
            
        endcase
    end
end
assign qb=~q;
endmodule

module a_jk_flip_flop_tb;

wire  Q,QB;
reg K,J,RST,CLK;
reg [1:0]i;

 a_jk_flip_flop dut(.j(J),.k(K), .rst(RST),.clk(CLK),.q(Q), .qb(QB) );

initial begin
    $monitor("%0d\tj=%b\tk=%b\tq=%b\tqb=%b",$time,J,K,Q,QB);
    CLK=0; RST=1;
    #7RST=0;
    i=2'b0;
    repeat(4) begin
        #2;
        {J,K}=i;
        i=i+1'b1;
    end
end

always #5 CLK=~CLK;
endmodule
