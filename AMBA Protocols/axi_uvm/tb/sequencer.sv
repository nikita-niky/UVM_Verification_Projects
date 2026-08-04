/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_sequencer extends uvm_sequencer #(axi_item);
  `uvm_component_utils(axi_sequencer)

  function new(string name = "axi_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
