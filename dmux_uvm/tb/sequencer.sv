/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class demux_sequencer extends uvm_sequencer #(demux_item);

  `uvm_component_utils(demux_sequencer)

 
  function new(string name = "demux_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
