// The Sequencer acts as a router between the Sequence and the Driver
class alu_sequencer extends uvm_sequencer #(alu_item);
  `uvm_component_utils(alu_sequencer)

  function new(string name = "alu_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass