// Code your testbench here
// or browse Examples
module example_for_packedatruct;
  
  typedef struct packed{
    int phone_no;
    bit [3:0] reg_no;
  }id;
  
  initial begin
    id id1,id2;
    // initialising the struct  
    id1='{365241253,1011};
 	
    //acesssing and modifying the elements of structs
    id2.phone_no=6524564;
    id2.reg_no=1101;
    
    //displaying the contents of struct
    $display("%p\n%p",id1,id2);
  end
endmodule
