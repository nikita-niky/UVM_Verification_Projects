/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class counter_base_sequence extends uvm_sequence #(counter_item);
  `uvm_object_utils(counter_base_sequence)
  counter_item tr;



  function new(string name = "counter_base_sequence");
    super.new(name);
  endfunction

 
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence body", UVM_LOW)

    repeat(100) begin
      tr = counter_item::type_id::create("tr");
      start_item(tr);

      if(!tr.randomize()) begin
        `uvm_error("SEQ1", "Randomization failed!")
      end

      finish_item(tr);
    end

    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
