module mux4_1_using_case (
     input [3:0]ip ,input s1,s0,
     output reg y
);

always @(*) begin
    case({s1,s0})
    2'd0:y=ip[0];
    2'd1:y=ip[1];
    2'd2:y=ip[2];
    2'd3:y=ip[3];
   

    endcase
    
end


    
endmodule

module mux4_1_case_tb;

 

wire Y;
reg [3:0]IP;
reg S1,S0;
integer i;

mux4_1_using_case dut  (
    .ip(IP),
    .s1(S1), .s0(S0),
    .y(Y)
);

initial 
begin
    $monitor("[%t] INPUTS=%B,SELECT LINES=%B, OUTPUTLINESSELECTED=%d ",$time,IP,{S1,S0},i);
    for(i=0;i<4;i=i+1)
    begin
        #10; IP=(2**i); {S1,S0}=i;
    end
end
endmodule