/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

// The Sequencer acts as a router between the Sequence and the Driver
class p_enc_sequencer extends uvm_sequencer #(enc_item);
  `uvm_component_utils(p_enc_sequencer)

  function new(string name = "p_enc_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
