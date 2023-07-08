module a_tristatebuffer(in,en,out);
input in;
input en;
output out;

assign out=en?in:1'bz;

endmodule

module a_tristatebuffer_tb;

wire out;
reg in,en;

a_tristatebuffer dut(in,en,out);
initial begin
    $monitor("%0d\tin_data=%b\tenable=%b\toutput=%b",$time,in,en,out);
   #5 in=1'b1; en=1'b1;
   #5 in=1'b0; en=1'b1;
   #5 in=1'b0; en=1'b0;
    #5 in=1'b1; en=1'b0;
end
endmodule