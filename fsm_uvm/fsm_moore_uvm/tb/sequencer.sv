class fsm_sequencer extends uvm_sequencer #(fsm_item);
  `uvm_component_utils(fsm_sequencer)

  function new(string name = "fsm_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass