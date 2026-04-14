class arb_sequencer extends uvm_sequencer #(arb_item);
  `uvm_component_utils(arb_sequencer)

  function new(string name = "arb_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass