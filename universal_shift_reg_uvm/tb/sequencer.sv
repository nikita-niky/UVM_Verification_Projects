class univ_sr_sequencer extends uvm_sequencer #(sr_item);
  `uvm_component_utils(univ_sr_sequencer)

  function new(string name = "univ_sr_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass