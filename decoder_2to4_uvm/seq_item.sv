class dec_item extends uvm_sequence_item;
  `uvm_object_utils(dec_item)
  
  rand logic [1:0] sel;
  rand logic en;
       logic [3:0] y;


  function new(string name = "dec_item");
    super.new(name);
  endfunction
  
  // Helper function for clean logging
  function string convert2string();
    return $sformatf("en=%b, sel=%b, y=%b", en, sel, y);
  endfunction
  
  constraint con_sel {sel inside {[0:3]};}
  
endclass