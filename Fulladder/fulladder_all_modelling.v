
module full_adder (
    input a,b,c,
    output s0,s1,s3,c0,c1,c3,s4,c4,c5,s5,

    output reg c2,s2
);

wire [7:1]w;

wire w1,w2,w3,w4,w5,w6;

wire l,m,n;

assign s0=a^b^c;                           //dataflow modelling   
assign c0=(a&b) + (c&(a^b));

xor a1(w1,a,b);                    //mixed gatelevel modelling
xor a2(s1,c,w1);
and a3(w2,a,b);
and a4(w3,w1,c);
or a5(c1,w3,w2);

nand e1(w[1],a,b);                        //nand gate logic
nand r2(w[2],a,w[1]);
nand d3(w[3],w[1],b);
nand d4(w[4],w[3],w[2]);
nand af5(w[5], w[4],c);
nand a6a(w[6],w[4], w[5]);
nand a7(w[7], w[5], c);
nand a8(s3,w[6],w[7]);
nand a9(c3, w[1],w[5]);


always @ (*)                       //behavioral modelling
begin
    case ({a,b,c})
    
     3'b000: begin s2=0; c2=0; end
     3'b001: begin s2=1; c2=0; end
     3'b010: begin s2=1; c2=0; end
     3'b011: begin s2=0; c2=1; end
     3'b100: begin s2=1; c2=0; end
     3'b101: begin s2=0; c2=1; end
     3'b110: begin s2=0; c2=1; end
     3'b111: begin s2=1; c2=1; end

    endcase

end



assign {c4,s4}= a+b+c;      //overflow bit method

assign s5=a?(b?(c?1:0):(c?0:1)):(b?(c?0:1):(c?1:0));     //using conditional operarotor
assign c5=a?(b?(c?1:1):(c?1:0)):(b?(c?0:0):(c?0:0));


endmodule

module full_addertb;

wire S0,S1,S2,S3,S4,S5,C0,C1,C2,C3,C4,C5;
reg A,B,C;
integer i;

full_adder k(.a(A), .b(B), .c(C), .s0(S0), .s1(S1), .s2(S2), .s3(S3), .s4(S4), .s5(S5), .c0(C0), .c1(C1), .c2(C2), .c3(C3), .c4(C4), .c5(C5));

initial
begin
    A=0;B=0;C=0;
    for(i=0;i<8;i=i+1)
     begin
        {A,B,C}=i;
        #35;
     end
end
    
endmodule

