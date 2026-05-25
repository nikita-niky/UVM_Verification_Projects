/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class univ_sr_directed_sequence extends uvm_sequence #(sr_item);
  `uvm_object_utils(univ_sr_directed_sequence)
  sr_item tr;

  function new(string name = "univ_sr_directed_sequence");
    super.new(name);
  endfunction


  virtual task body();
    `uvm_info(get_type_name(), "Starting sequence1 body", UVM_LOW)

    tr = sr_item::type_id::create("tr");

    ///SIPO test shift right

    repeat(4) begin

      `uvm_do_with(tr,{tr.rst==0; tr.mode == 2'b01; tr.sin_right == 1'b0; tr.sin_left == 1'b1;})

      `uvm_do_with(tr,{tr.rst==0; tr.mode == 2'b01; tr.sin_right == 1'b0; tr.sin_left == 1'b0;})
    end

    //SIPO shift left
    `uvm_info("SEQ_2","SIPO with shift left",UVM_LOW)

    repeat(4) begin

      `uvm_do_with(tr,{tr.rst==0; tr.mode == 2'b10; tr.sin_right == 1'b1; tr.sin_left == 1'b0;})

      `uvm_do_with(tr,{tr.rst==0; tr.mode == 2'b10; tr.sin_right == 1'b0; tr.sin_left == 1'b0;})
    end


    `uvm_info("SEQ_3", "Testing Parallel Load", UVM_LOW)

    // Load a specific pattern (e.g., 1010)
    `uvm_do_with(tr, { tr.rst == 0; tr.mode == 2'b11; tr.d_in == 4'b1010; })

    // Load a different pattern immediately after (e.g., 0110)
    `uvm_do_with(tr, { tr.rst == 0; tr.mode == 2'b11; tr.d_in == 4'b0110; })

    // Hold the value for 2 cycles to ensure 'Hold' mode (00) works
    repeat(2) begin
      `uvm_do_with(tr, { tr.rst == 0; tr.mode == 2'b00; })
    end



    `uvm_info(get_type_name(), "Sequence1 body finished", UVM_LOW)

  endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
