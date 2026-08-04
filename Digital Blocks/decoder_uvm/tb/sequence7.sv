/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class dec_sel_toggle_seq extends uvm_sequence#(dec_item);
  `uvm_object_utils(dec_sel_toggle_seq)

    dec_item tr;
  int transitions[12]; 

  function new(string name = "dec_sel_toggle_seq");
        super.new(name);
    endfunction

    task body();
      
      `uvm_info(get_type_name(), "Starting sel_toggle Stimulus for all ports...", UVM_LOW)

    
      transitions = '{0, 0, 0, 1, 1, 2, 2, 2, 3, 2, 3, 3}; 

   
    foreach(transitions[i]) begin
      tr = dec_item::type_id::create("tr");
      start_item(tr);
      
      if(!tr.randomize() with { en == 1; sel == transitions[i]; }) begin
        `uvm_error("SEQ", "Randomization failed")
      end
      
      finish_item(tr);
    end
   endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
