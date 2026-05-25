/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class dec_base_sequence extends uvm_sequence #(dec_item);
  `uvm_object_utils(dec_base_sequence)
  dec_item tr;


  function new(string name = "dec_base_sequence");
    super.new(name);
  endfunction

 
  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence body", UVM_LOW)

    repeat(50) begin
      tr = dec_item::type_id::create("tr");
      start_item(tr);

      if(!tr.randomize()) begin
        `uvm_error(get_type_name(), "Randomization failed!")
      end

      finish_item(tr);
    end


    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
