class arbiter_item extends uvm_sequence_item;
  `uvm_object_utils(arbiter_item)
  
  rand logic rst_n;
  rand logic [3:0] req;
  logic [3:0] gnt;


  function new(string name = "arbiter_item");
    super.new(name);
  endfunction
  
  constraint con_req{req inside {[4'b0000:4'b1111]};}
  constraint con_rst {rst_n dist {1:=90 , 0:=10};}

 
endclass