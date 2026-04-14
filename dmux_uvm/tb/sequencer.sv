class demux_sequencer extends uvm_sequencer #(demux_item);

  `uvm_component_utils(demux_sequencer)

 
  function new(string name = "demux_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass