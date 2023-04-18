module odd_parity (input [2:0]data,         //even_parity used in encoding
                    output parity);

assign parity=~(data[0]^data[1]^data[2]);       //since odd parity if thier is even number of ones parity bit should be high

endmodule

module odd_parity_tb;
wire  PARITY;
reg [2:0] DATA;

odd_parity dut(.data(DATA), .parity(PARITY));

initial begin
    $monitor("Time=%d\tData=%b\tParity=%b\tEnocodeddata=%b",$time,DATA,PARITY,{DATA,PARITY});
     repeat(5) #5 DATA=$random;
end
endmodule
