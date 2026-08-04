/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class univ_sr_sequencer extends uvm_sequencer #(sr_item);
  `uvm_component_utils(univ_sr_sequencer)

  function new(string name = "univ_sr_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
