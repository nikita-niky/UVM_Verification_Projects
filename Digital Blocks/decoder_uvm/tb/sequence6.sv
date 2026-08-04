/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class dec_x_propogation_seq extends uvm_sequence#(dec_item);
  `uvm_object_utils(dec_x_propogation_seq)

    dec_item tr;

  function new(string name = "dec_x_propogation_seq");
        super.new(name);
    endfunction

    task body();
      
      `uvm_info(get_type_name(), "Starting x_propogation Stimulus for all ports...", UVM_LOW)

      
      tr = dec_item::type_id::create("tr");
 	  start_item(tr);
  
  	  tr.en = 1'b1;
  	  tr.sel = 2'bxx; // Manually forcing X
  
 	  finish_item(tr);
      
   endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
