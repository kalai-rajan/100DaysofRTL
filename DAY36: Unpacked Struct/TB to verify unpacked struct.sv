
module struct_example;
  typedef struct {
    string name;
    bit[3:0] no;
    
  } id;
    
  initial begin
    id id1, id2;
    id1.name = "Alex";
    id1.no = 4'b1000;
  
    $display("ID 1: %p", id1);
    
    id2='{"selva",1010};
          $display("id 2: %p", id2);
  end
endmodule
