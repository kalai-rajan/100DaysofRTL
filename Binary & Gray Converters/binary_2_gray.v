module b2g ( input [3:0] b, output [3:0] g);

assign g[3]=b[3];
assign g[2]=b[3]^b[2];
assign g[1]=b[2]^b[1];
assign g[0]=b[1]^b[0];
    
endmodule

module b2gtb;
 wire [3:0]G;
 reg [3:0]B;

 b2g dut  ( .b(B), .g(G));

 initial 
 begin

    $monitor("[%t] BINARY =%b   GRAY =%b", $time,B,G);
    B=4'b1000;
    #10 B=4'b1001;
    #10 B=4'b1110;
    
 end    
endmodule
