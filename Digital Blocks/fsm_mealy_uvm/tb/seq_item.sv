/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_item extends uvm_sequence_item;
  `uvm_object_utils(fsm_item)
  
  rand logic rst_n;
  rand logic bit_in;
  logic pattern_found;
  
  state_t current_state; // internally deefined in package



  function new(string name = "fsm_item");
    super.new(name);
  endfunction
  
  constraint con_bitsin {bit_in dist {1:= 60, 0:= 40};}
  constraint con_rst {rst_n dist {1:=90, 0:=10};}
   

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
