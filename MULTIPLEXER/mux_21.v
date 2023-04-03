module mux_21 (
               input i0,i1,
               input s,
               output y0,y1,y3,
               output reg y2
);

wire l,m;

assign y0= ( (~s & i0) | (s&i1) );          //dataflow modelling

assign y1=s?i1:i0;                          //using conditional operator

always @(*)                                      // behavioral modelling 
begin
    case (s)
        1'b0: begin y2=i0;  end

        1'b1: begin y2=i1;  end 
        
        default: y2=1'b0; 
    endcase
end

and a1(l,~s,i0);                           //structural modeling
and a2(m,s,i1);
or a3(y3,l,m);
    
endmodule

module  mux_21tb;

wire Y0,Y1,Y2,Y3;
reg I0,I1,S;

mux_21 dut (
               .i0(I0), .i1(I1),
               .s(S),
               .y0(Y0),.y1(Y1), .y3(Y3),
               .y2(Y2)
);

initial
begin
    
   
    I0=0; I1=1; 
    #100 S=0;
    #100 S=1;

end
    
endmodule