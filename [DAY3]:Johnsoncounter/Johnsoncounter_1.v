module johnsoncounter_1  #(parameter WIDTH =3)  (
    input clk,rst,
    output reg [(WIDTH-1):0]count
);
reg tmp;
always @(posedge clk or posedge rst) 
begin
    if (rst) 
    begin
        count=4'b0000;
    end
    else begin
        tmp=~count[0];
        count=count>>1;
        count[WIDTH-1]=tmp;

    end
end
endmodule

module johnsoncounter_1_tb;
parameter width=4;
wire [width-1:0]COUNT;
reg CLK,RST;

johnsoncounter_1 #(.WIDTH(width)) DUT (.clk(CLK), .rst(RST), .count(COUNT));

initial 
    begin
        $monitor("%t]\t COUNT=%B(%D)\t",$time,COUNT,COUNT);
        RST=1; CLK=0;
        #5 RST=0;
    end
always #5 CLK=~CLK;
endmodule
