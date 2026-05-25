/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class mux_all_zeros_seq extends uvm_sequence #(mux_transaction);
  mux_transaction tr;
  
  `uvm_object_utils(mux_all_zeros_seq)
  
  function new(string name = "mux_all_zeros_seq");
      super.new(name);
    endfunction
    
    task body();
      `uvm_info("SEQ", "Starting All-Zeros Stimulus...", UVM_LOW)
      
          
          
            for(int i = 0; i < 4; i++) begin
              tr = mux_transaction::type_id::create("tr");
              start_item(tr);
              tr.d[i]  = 32'h0;
              tr.sel = i; 
               #10;
              finish_item(tr);
            end
            
            
        
    endtask
endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
