/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_error_injection_seq extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_error_injection_seq)

  function new(string name = "axi_error_injection_seq");
    super.new(name);
  endfunction

  virtual task body();
    axi_item write_tr;
    axi_item read_tr;

    `uvm_info("SEQ_ERR_INJ", "=============================================", UVM_LOW)
    `uvm_info("SEQ_ERR_INJ", "  STARTING ILLEGAL ADDRESS ERROR INJECTION   ", UVM_LOW)
    `uvm_info("SEQ_ERR_INJ", "=============================================", UVM_LOW)

    // ========================================================================
    // STEP 1: BLAST ILLEGAL ADDRESS OUT-OF-BOUNDS WRITE
    // ========================================================================
    `uvm_info("SEQ_ERR_INJ", "Step 1: Preparing out-of-bounds WRITE to 16'h5000...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_tr_err");

    start_item(write_tr);

    if (!write_tr.randomize() with {
      op    == WRITE;
      id    == 8'hFF;
      addr  == 16'h5000; // Directly over the 16'h4000 (MEM_LIMIT) threshold!
      len   == 8'd0;    // Single beat tracking
      size  == 3'b010;  // 32-bit transfer configuration
      burst == 2'b01;   // INCR type burst
    }) begin
      `uvm_fatal("RAND_FAIL", "Error injection write transaction randomization crashed!")
    end


    finish_item(write_tr);

    // ========================================================================
    // STEP 2: BLAST MATCHING ILLEGAL ADDRESS OUT-OF-BOUNDS READ
    // ========================================================================

    `uvm_info("SEQ_ERR_INJ", "Step 2: Preparing out-of-bounds READ to 16'h5000...", UVM_LOW)
    read_tr = axi_item::type_id::create("read_tr_err");

    start_item(read_tr);
    if (!read_tr.randomize() with {
      op    == READ;
      id    == 8'hFF;      // Match transaction ID properties
      addr  == 16'h5000;   // Match target illegal memory index
      len   == 8'd0;
      size  == 3'b010;
      burst == 2'b01;
    }) begin
      `uvm_fatal("RAND_FAIL", "Error injection read transaction randomization crashed!")
    end
    finish_item(read_tr);


    `uvm_info("SEQ_ERR_INJ", "=============================================", UVM_LOW)
    `uvm_info("SEQ_ERR_INJ", "   ERROR INJECTION RUN FINISHED CLEANLY      ", UVM_LOW)
    `uvm_info("SEQ_ERR_INJ", "=============================================", UVM_LOW)
  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
