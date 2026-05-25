/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class mux_sequencer extends uvm_sequencer #(mux_transaction);

  `uvm_component_utils(mux_sequencer)

 
  function new(string name = "mux_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
