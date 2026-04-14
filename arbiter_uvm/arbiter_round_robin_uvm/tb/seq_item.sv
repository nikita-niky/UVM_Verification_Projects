class arb_item extends uvm_sequence_item;
  `uvm_object_utils(arb_item)
  
  rand logic rst_n;
  rand logic [3:0] req;
  
  logic [3:0] gnt;
  
  
  constraint con_req {req inside {[0:15]};}
  constraint con_rst {rst_n dist {1:=90, 0:=10};}

 

  function new(string name = "arb_item");
    super.new(name);
  endfunction

   

endclass