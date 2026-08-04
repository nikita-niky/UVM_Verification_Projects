/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fifo_sequencer extends uvm_sequencer #(fifo_item);
  `uvm_component_utils(fifo_sequencer)

  function new(string name = "fifo_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
