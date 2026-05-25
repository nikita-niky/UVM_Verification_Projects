/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class arb_random_sequence extends uvm_sequence #(arb_item);
  `uvm_object_utils(arb_random_sequence)
  arb_item tr;


  function new(string name = "arb_random_sequence");
    super.new(name);
  endfunction

  
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 3 body", UVM_LOW)
    
    repeat(500) begin
      `uvm_do(tr)
    end

    `uvm_info(get_type_name(), "Sequence 3 body finished", UVM_LOW)
  endtask

endclass




//     repeat(50) begin
//       tr = arb_item::type_id::create("tr");
//       start_item(tr);
//       if(!tr.randomize() with {rst_n dist {1:=90, 0:=10};
//          					   req inside {[0:15]};})
//         `uvm_error("SEQ3","Randomization failed !!")
        
//       finish_item(tr);
          
//     end
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
