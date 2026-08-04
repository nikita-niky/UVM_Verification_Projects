/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class p_enc_random_seq extends uvm_sequence#(enc_item);
  `uvm_object_utils(p_enc_random_seq)

    enc_item tr;

    function new(string name = "p_enc_random_seq");
        super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "Starting random value Stimulus for all ports...", UVM_LOW)
      repeat (100) begin

      tr=enc_item::type_id::create("tr");
      start_item(tr);
        if (!tr.randomize()) 
          `uvm_error("SEQ", "Randomization failed!")
          else
            finish_item(tr);
      end
    endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
