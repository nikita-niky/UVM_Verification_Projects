// The Sequencer acts as a router between the Sequence and the Driver
class p_enc_sequencer extends uvm_sequencer #(enc_item);
  `uvm_component_utils(p_enc_sequencer)

  function new(string name = "p_enc_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass