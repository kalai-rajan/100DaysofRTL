module ringcounter_1 #(parameter WIDTH=4)(
    input clk,rst,
    output reg [(WIDTH-1):0]count
);
reg tmp;
always @(posedge clk or posedge rst) 
begin
    if (rst) 
    begin
        count=1;
    end
    else begin
        tmp=count[0];
        count=count>>1;                  
        count[WIDTH-1]=tmp;

    end
end
endmodule

module ringcounter_1_tb;
wire [3:0]COUNT;
reg CLK,RST;

ringcounter_1 dut(.clk(CLK), .rst(RST), .count(COUNT));

initial 
    begin
        $monitor("%t]\t COUNT=%B(%D)\t",$time,COUNT,COUNT);
        RST=1; CLK=0;
        #5 RST=0;
    end
always #5 CLK=~CLK;
endmodule
