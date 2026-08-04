/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class mux_base_seq extends uvm_sequence#(mux_transaction);
  mux_transaction tr;
  
  `uvm_object_utils(mux_base_seq)
  
  function new (string name = "mux_base_seq");
    super.new(name);
  endfunction
  
  task body();
    repeat(500) begin
      tr= mux_transaction::type_id::create("tr");
      start_item(tr);
      if(tr.randomize())
        finish_item(tr);
        
      else
        `uvm_error("[SEQ]","Randomization failed !!!")
    end
  endtask
  
endclass
          
      
    
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
