// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================


class alu_base_sequence extends uvm_sequence #(alu_item);
  `uvm_object_utils(alu_base_sequence)
  alu_item tr;


  function new(string name = "alu_base_sequence");
    super.new(name);
  endfunction


  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence body", UVM_LOW)

    repeat(20) begin
     
      tr = alu_item::type_id::create("tr");
      start_item(tr); // Combines wait_for_grant

      if(!tr.randomize()) begin
        `uvm_error(get_type_name(), "Randomization failed!")
      end

      finish_item(tr); // Combines send_request & wait_for_item_done
    end

    `uvm_info(get_type_name(), "Sequence body finished", UVM_LOW)
  endtask

endclass

// ==========================================================================
// Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
// Copyright:   (c) 2026 Nikita Agrawal
// License:     MIT License (see LICENSE file in root)
// ==========================================================================