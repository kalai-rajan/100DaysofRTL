module mux81_using_behavi (
    input [7:0]ip,
    input [2:0]s,
    output reg y
);
always @(*) begin
    case(s)
    3'd0:y=ip[0];
    3'd1:y=ip[1];
    3'd2:y=ip[2];
    3'd3:y=ip[3];
    3'd4:y=ip[4];
    3'd5:y=ip[5];
    3'd6:y=ip[6];
    3'd7:y=ip[7];

    endcase
    
end

endmodule

module mux81_using_behavi_tb;

wire Y;
reg [7:0]IP;
reg [2:0]S;
integer i;

mux81_using_21 dut  (
    .ip(IP),
    .s(S),
    .y(Y)
);

initial 
begin
    $monitor("[%t] INPUTS=%B,SELECT LINES=%B, OUTPUTLINESSELECTED=%d ",$time,IP,S,i);
    for(i=0;i<8;i=i+1)
    begin
        #10; IP=(2**i); S=i;
    end
end

    
endmodule
