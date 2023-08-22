module a_poly;
class a;
    int v;
    
    virtual function void dsp();
     $display("from parent v=%d",v);
    endfunction

endclass

class b extends a;
   int w;

 function void dsp();
    $display("from child b v=%d",v);
   endfunction

endclass

class c extends a;
   int y;

 function void dsp();
    $display("from child c v=%d",v);
   endfunction

endclass

initial begin
  	a a1[1:0];  	  //base class
    b b1;        //child class1
    c c1;        //child class2
    
    b1=new();
    c1=new();

    a1[0]=b1;
    a1[1]=c1;

    a1[0].dsp();
    a1[1].dsp();    
end
endmodule
