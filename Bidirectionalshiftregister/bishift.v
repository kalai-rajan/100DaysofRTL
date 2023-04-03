module bishift #( parameter WIDTH=3) (input clk,clr,din,dir,
  output reg [WIDTH-1:0]q,
  output reg out
);

always @(posedge clk or posedge clr) begin
    if (clr) begin
        q=0;
    end
    else begin
        if(dir) begin     //DIR=1 RIGHT SHIFT
            
            q=q>>1;
            q[WIDTH-1]=din;
            out=q[0];
        end
        else begin            //DIR=0 LEFT SHIFT
             q=q<<1;
            q[0]=din;
            out=q[WIDTH-1];
            
        end
    end
    
end
    
endmodule

module bishift_tb;
parameter width=4;
wire OUT;
wire [width-1:0]Q;
reg CLK,CLR,DIN,DIR;

bishift #(.WIDTH(width)) dut(.clk(CLK), .clr(CLR), .din(DIN), .dir(DIR), .q(Q), .out(OUT));

initial begin
    $monitor("%t)\tDIR=%B\tDIN=%B\tQ=%B\tOUT=%b",$time,DIR,DIN,Q,OUT);
    CLK=0;CLR=1;
    #5CLR=0;  
    #10 DIR=1; DIN=1;
     repeat(4)  #10  DIR=1; DIN=1;
     #5 CLR=1;
    #5 CLR=0;  DIR=0; DIN=1;
     repeat(4)  #10  DIR=0; DIN=1;
     


end
always #5 CLK=~CLK;
endmodule
