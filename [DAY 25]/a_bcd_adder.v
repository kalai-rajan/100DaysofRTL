 module a_bcd_adder (input [3:0]a,b, 
                    output reg [3:0]sum, 
                    output reg carry 
 );
 reg [4:0]tmp_sum;
 

 always @(*) begin
    tmp_sum=a+b;
    if(tmp_sum>9) begin
        tmp_sum=tmp_sum+6;
    end
    else if((tmp_sum[4]==1)  || (tmp_sum<9) ) begin
        tmp_sum=tmp_sum+6;
    end
    else begin
        sum=tmp_sum[3:0];
        carry=tmp_sum[4];
    end
      sum=tmp_sum[3:0];
      carry=tmp_sum[4];
 end
    
 endmodule

 module a_bcd_adder_tb;

 wire [3:0]SUM;
 wire CARRY;
 reg [3:0]A,B;

 a_bcd_adder dut(.a(A), .b(B),  .sum(SUM), .carry(CARRY));

 initial begin
    $monitor("%0d\ta=%b\tb=%b\tsum=%b\tcarrryout=%b",$time,A,B,SUM,CARRY);
    A=4'B1010; B=4'b0100;
    #5 A=4'B1100; B=4'b0001;
    #5 A=4'B1001; B=4'b0110;
 end
 endmodule