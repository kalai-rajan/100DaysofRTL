module dlatch (
    input d,en,rst,
    output reg q,
    output qb
);
    
always @(rst or en or d) 
begin
 if (rst) 
   q<=0;
 else
    begin
        if (en) 
        
           q<=d;
        else
           q<=q;
            
        end 
        
end
    
assign qb=~q;

endmodule

module dlatch_tb;

wire Q,QB;
reg D,EN,RST;

dlatch dut(.d(D), .en(EN), .rst(RST), .q(Q), .qb(QB));
initial begin
    $monitor("%t) EN=%B\t D=%B \t  Q=%B\t QB=%D \t",$time,EN,D,Q,QB);
    EN=0; RST=1;D=0;
    #5 RST=0;D=1;
    #5 D=1;
    #5 D=0;
    #5 D=0;
    #5 D=1;
end

always #5 EN = ~EN;
    
endmodule
