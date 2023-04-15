module up_down_counter_1 #(parameter WIDTH=3) (
    input clk,rst,en,
    output reg [WIDTH-1:0]count
);

always @(posedge clk or posedge rst ) 
begin
    if(rst) 
        begin
            count<=0;
        end   
    else
        begin
            if (en) 
            begin
                count<=count+1;
                
            end
            else 
            begin
                count<=count-1;
            end
        end
end
    
endmodule

module up_down_counter_1_tb;

parameter width=4;
wire [width-1:0]COUNT;
reg CLK,RST,EN;

up_down_counter_1 #(.WIDTH(width) ) dur(.clk(CLK), .rst(RST), .en(EN), .count(COUNT));

initial begin
     $monitor("%t] COUNT=%B(%D)",$time,COUNT,COUNT);
   
    RST=0;CLK=0;EN=0;
    #1 RST=1;
    #4 RST=0;EN=1;
    #165 EN=0;
end

always #5 CLK=~CLK;
    
endmodule
