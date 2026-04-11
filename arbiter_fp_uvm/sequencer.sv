class arbiter_sequencer extends uvm_sequencer #(arbiter_item);
  `uvm_component_utils(arbiter_sequencer)
  
  function new(string name = "arbiter_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass