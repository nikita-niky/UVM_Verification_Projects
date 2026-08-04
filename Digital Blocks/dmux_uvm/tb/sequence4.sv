/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class demux_select_unknown extends uvm_sequence #(demux_item);
  demux_item tr;
  
  `uvm_object_utils(demux_select_unknown)
  
  function new(string name = "demux_select_unknown");
      super.new(name);
    endfunction
    
    task body();
      `uvm_info("SEQ", "Starting Select-Unknown Stimulus...", UVM_LOW)
      
      
      
      repeat(10) begin
    	tr= demux_item::type_id::create("tr");
      	start_item(tr);
        if (tr.randomize()) begin
        	tr.sel = 2'bx; 
        	finish_item(tr);
        end 
        else
          begin 
            `uvm_error("[SEQ4]","Randomization failed !!!")
    	  end
      end
    endtask
endclass
        
            
            
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
