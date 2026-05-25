/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class fsm_random_sequence extends uvm_sequence #(fsm_item);
  `uvm_object_utils(fsm_random_sequence)
  fsm_item tr;


  function new(string name = "fsm_random_sequence");
    super.new(name);
  endfunction

 
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence 1 body", UVM_LOW)

    repeat(50) begin
      tr = fsm_item::type_id::create("tr");
      start_item(tr);

   
      if(!tr.randomize()) begin
        `uvm_error(get_type_name(), "Randomization failed!")
      end

      finish_item(tr);
    end

    `uvm_info(get_type_name(), "Sequence 1 body finished", UVM_LOW)
  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
