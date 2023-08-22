// Code your testbench here
// or browse Examples
module a_deep_copy;

class suba;
    int j,k,l;

    function void copy(output suba m );
        m=new();
        m.j=this.j;
        m.k=this.k;
        m.l=this.l;
    endfunction

endclass

class a;
    int o,b,c;
    suba suba_h;

    function new();
        suba_h=new();
    endfunction

    function void copy(output a n);
        n=new();
        n.o=this.o;
        n.b=this.b;
        n.c=this.c;
        this.suba_h.copy(n.suba_h);
     endfunction
     
endclass

initial begin
    a a1,a2;
    a1=new(); a2=new();
    a1.o=1; a1.b=2;a1.c=3;
    a1.suba_h.j=4;  a1.suba_h.k=5;  a1.suba_h.l=6;
   

    a1.copy(a2);

    $display("The Value of Object A1 Main Class Properties are:\n\ta)=%0d,\tb)=%0d\tc=%0d",a1.o,a1.b,a1.c);
    $display("The Value of Object A1 Sub Class Properties are:\n\tj)=%0d,\tk)=%0d\tl=%0d",a1.suba_h.j,a1.suba_h.k,a1.suba_h.l);

    $display("The Value of Object A2 Main Class Properties are:\n\ta)=%0d,\tb)=%0d\tc=%0d",a2.o,a2.b,a2.c);
    $display("The Value of Object A2 Sub Class Properties are:\n\tj)=%0d,\tk)=%0d\tl=%0d",a2.suba_h.j,a2.suba_h.k,a2.suba_h.l);
    
 end
endmodule

