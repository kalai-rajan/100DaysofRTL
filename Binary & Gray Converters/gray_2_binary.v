module g2b (
    input [3:0]g,
    output [3:0]b
);

assign b[3]=g[3];
assign b[2]=b[3]^g[2];
assign b[1]=b[2]^g[1];
assign b[0]=b[1]^g[0];
    
endmodule

module gebtb;

wire [3:0]B;
reg [3:0]G;

g2b dut(.g(G), .b(B));

initial
begin
    $monitor(" %t--- GRAY=%b--- BINARY=%b",$time,G,B);
    G=4'b001;
    #10 G=4'b1001;

end

    
endmodule
