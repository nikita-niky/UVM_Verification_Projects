class mux_sequencer extends uvm_sequencer #(mux_transaction);

  `uvm_component_utils(mux_sequencer)

 
  function new(string name = "mux_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass