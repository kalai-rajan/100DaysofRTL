 module down_counter1 #(parameter WIDTH=3) (
    input clk,rst,
    output reg [WIDTH-1:0]count
);

always @(posedge clk or posedge rst)
begin
    if(rst)
      count<=(2**(WIDTH)-1);
    else
     begin
        count<=count-1;
     end
    
end
    
endmodule

module down_counter1_tb;
parameter width=5;
wire [width-1:0]COUNT;
reg CLK,RST;

down_counter1 #(.WIDTH(width)) DUT(.clk(CLK), .rst(RST), .count(COUNT));

initial begin
    $monitor("%t)\tCOUNT=%B(%D)\t",$time,COUNT,COUNT);
    CLK=0;RST=1;
    #5RST=0;
end

always #5 CLK=~CLK;
endmodule
