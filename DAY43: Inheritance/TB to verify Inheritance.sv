module a_inheritance;
class a;
    int j,k,l;

    function new();
        $display("I am from the parentclass");;
        
    endfunction
endclass
class  b extends a;
    int m,n,o;

    function new();
        $display("I am from Child Class");
    endfunction 

endclass
initial begin
    a a1;
    b b1;
    b1=new();
    b1.j=1; b1.k=3; b1.l=2;
    b1.m=4; b1.n=5; b1.o=6;  
    $display("%p",b1);
end

endmodule
