class enc_item extends uvm_sequence_item;
  

  rand logic [3:0] req;
  logic [1:0] code;
  logic valid;
  
  `uvm_object_utils(enc_item)



  function new(string name = "enc_item");
    super.new(name);
  endfunction
  
endclass