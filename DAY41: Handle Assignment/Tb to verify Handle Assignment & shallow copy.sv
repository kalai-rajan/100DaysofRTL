class sub;
  int a,b,c;
endclass

class main;
  sub s_h;
  int i,j,k;
  
  function new();
    s_h=new();
  endfunction
  
  function void display(string s);
    $display("%s",s);
    $display("i=%0d\tj=%0d\tk=%0d\na=%0d\tb=%0d\tc=%0d",i,j,k,s_h.a,s_h.b,s_h.c);
  endfunction
endclass

module tb;
  main m_h1,m_h2,m_h3;
  initial begin
  m_h1=new();
  m_h2=new();
  m_h3=new();
  m_h1.i=10; m_h1.j=100; m_h1.k=1000;
  m_h1.s_h.a=1; m_h1.s_h.b=2; m_h1.s_h.c=3;
   
    m_h1.display("\n\nbefore handle assignment and shallow copy\nm_h1");
    m_h2.display("m_h2 ");
    m_h3.display("m_h3 ");
    
  m_h2=m_h1; //handle assignment 
  m_h3= new m_h1; //shallow copy
    
    m_h1.display("after handle assignment and shallow copy\nm_h1");
    m_h2.display("m_h2 ");
    m_h3.display("m_h3");
    
    m_h3.s_h.a=4; m_h3.s_h.b=5; m_h3.s_h.c=5;
    
    m_h1.display("after changes in the m_h3 variables\nm_h1");  
    m_h3.display("m_h3");
  
  end
endmodule
