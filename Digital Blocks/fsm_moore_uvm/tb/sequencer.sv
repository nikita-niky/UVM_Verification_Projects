/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_sequencer extends uvm_sequencer #(fsm_item);
  `uvm_component_utils(fsm_sequencer)

  function new(string name = "fsm_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
