// The Sequencer acts as a router between the Sequence and the Driver
class dec_sequencer extends uvm_sequencer #(dec_item);
  `uvm_component_utils(dec_sequencer)

  function new(string name = "dec_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass