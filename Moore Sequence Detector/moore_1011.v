module moore_1011 (
    input x,clk,rst,
    output reg y
);

parameter  one=3'd1,
           two=3'd2,
           three=3'd3,
           idle=3'd0,
           four=3'd4;

reg [3:0]prst,nxt;

always @(posedge clk or posedge rst) begin
    if(rst)
       prst<=idle;
    else 
        prst<=nxt;
    
end
always @(posedge clk or posedge rst ) begin
    if (rst) begin
        y<=0;
    end
    else begin
        case(prst)
           3'd0: y<=0;
           3'd1: y<=0;
           3'd2: y<=0;
           3'd3: y<=0;
           3'd4: y<=1;
           default: y=1'bz;
        endcase
    end
    
end

always @(prst or x or rst) begin
    case (prst)
        3'd0: nxt=x?one:idle;
        3'd1: nxt=x?one:two;
        3'd2: nxt=x?three:idle;
        3'd3: nxt=x?four:two;
        3'd4: nxt=x?one:two; 
        default: nxt<=idle;

    endcase
    
end
    
endmodule

module moore_1011_tb;
wire Y;
reg X,CLK,RST;

moore_1011 dut (.x(X), .clk(CLK), .rst(RST), .y(Y));

initial begin
    $monitor("%t)\tX=%b\tstate=%d\tout=%b",$time,X,dut.prst,Y);

    CLK=0;RST=0;X=0;
    #10 RST=1;
    #10 RST=0;
    repeat(13) #10 X=$random;
end

always #5 CLK=~CLK;
    
endmodule
