/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class demux_all_zeros_seq extends uvm_sequence#(demux_item);
  demux_item tr;
  
  `uvm_object_utils(demux_all_zeros_seq)
  
  function new (string name = "demux_all_zeros_seq");
    super.new(name);
  endfunction
  
 task body();
   `uvm_info("SEQ", "Starting All-Zeros Stimulus for all ports...", UVM_LOW)
   
   repeat(20) begin

        
     tr = demux_item::type_id::create("tr");
        
     start_item(tr);
        
        
     if(!tr.randomize() with { 
          sel dist {[0:3]:=25}; 
            d   == 32'h0000_0000; 
        }) begin
            `uvm_fatal("SEQ", "Randomization failed!")
        end
        
     finish_item(tr);
    end

endtask
  
endclass





/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
