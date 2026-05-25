/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class enc_item extends uvm_sequence_item;
  

  rand logic [3:0] req;
  logic [1:0] code;
  logic valid;
  
  `uvm_object_utils(enc_item)



  function new(string name = "enc_item");
    super.new(name);
  endfunction
  
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
