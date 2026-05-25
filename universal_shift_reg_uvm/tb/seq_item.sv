/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class sr_item extends uvm_sequence_item;
  `uvm_object_utils(sr_item)
  
  rand logic rst;
  rand logic [1:0] mode;
  rand logic sin_left;
  rand logic sin_right;
  rand logic [3:0] d_in;
  
  logic [3:0] q_out;

  

  function new(string name = "sr_item");
    super.new(name);
  endfunction
     

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
