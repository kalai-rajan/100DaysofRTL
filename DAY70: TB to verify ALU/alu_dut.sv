// Code your design here
module alu(a,b,alu_select,alu_out,clk,rst);
  input [3:0]a,b,alu_select;
  output reg [15:0]alu_out;
  input clk,rst;
  always @(posedge clk or posedge rst) begin
    if(rst)
      alu_out<=0;
   else
    case(alu_select)
      
      4'd1: alu_out<=a+b; 
      4'd2: alu_out<=a-b; 
      4'd3: alu_out<=a*b;
      4'd4: alu_out<=a/b;
      
      4'd5: alu_out<=a & b;
      4'd6: alu_out<=a | b;
      4'd7: alu_out<=~a;
      
      4'd8: alu_out<=a^b;
      4'd9: alu_out<=~(a^b);
      
      4'd10: alu_out<=~(a & b);
      4'd11: alu_out<=~(a | b);
      
      4'd12: alu_out<=a>>1; //logical right shift
      4'd13: alu_out<=a<<1; ///logical left shift
      
      4'd14: alu_out<={a[0],a[3:1]}; //rotate right by 1
      4'd15: alu_out<={a[2:0],a[3]}; //rotate left by 1
      
      default: alu_out<=0;
      
    endcase
  end
endmodule
