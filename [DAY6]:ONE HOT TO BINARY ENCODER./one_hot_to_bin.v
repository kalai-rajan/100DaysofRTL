module a_onehot_to_bin(input [15:0]in,
                        output reg [3:0]out);

always @(*)
begin
      casez (in)
        16'b???????????????1: out=0;
        16'b??????????????1?: out=4'd1;
        16'b?????????????1??: out=4'd2;
        16'b????????????1???: out=4'd3;
        16'b???????????1????: out=4'd4;
        16'b??????????1?????: out=4'd5;
        16'b?????????1??????: out=4'd6;
        16'b????????1???????: out=4'd7;
        16'b???????1????????: out=4'd8;
        16'b??????1?????????: out=4'd9;
        16'b?????1??????????: out=4'd10;
        16'b????1???????????: out=4'd11;
        16'b???1????????????: out=4'd12;
        16'b??1?????????????: out=4'd13;
        16'b?1??????????????: out=4'd14;
        16'b1???????????????: out=4'd15;
        default: out=16'dz; 
         
      endcase
end
endmodule

module a_onehot_to_bin_tb;

wire [3:0]OUT;
reg [15:0]IN;
integer i;
a_onehot_to_bin dut(.in(IN), .out(OUT));

initial begin
  $monitor("%0d\tIN=%b\tOUT=%b(%0d)\n",$time,IN,OUT,OUT);
  i=1;IN=16'd1;
  repeat(16) begin
  #5    IN=16'd0;
    IN[i]=1;
    i=i+1;
  end
  
end
endmodule