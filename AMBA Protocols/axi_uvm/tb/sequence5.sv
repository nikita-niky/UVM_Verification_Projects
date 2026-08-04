/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_slave_stall_seq extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_slave_stall_seq)

  function new(string name = "axi_slave_stall_seq");
    super.new(name);
  endfunction

  virtual task body();
    axi_item write_tr;
    axi_item read_tr;

    `uvm_info("SEQ_STALL", "=============================================", UVM_LOW)
    `uvm_info("SEQ_STALL", "  STARTING SLAVE STALL BACKPRESSURE TEST     ", UVM_LOW)
    `uvm_info("SEQ_STALL", "=============================================", UVM_LOW)

    // ========================================================================
    // STEP 1: LONG WRITE BURST FOR MID-TRANSFER STALL VERIFICATION
    // ========================================================================
    `uvm_info("SEQ_STALL", "Step 1: Preparing an 8-beat WRITE burst into stall zone...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_tr_stall");

    start_item(write_tr);

    if (!write_tr.randomize() with {
      op    == WRITE;
      id    == 8'hC5;
      addr  == 16'h3000;
      len   == 8'd7;     // 8 beats total (len = beats - 1)
      size  == 3'b010;   // 32-bit transfer mode
      burst == 2'b01;    // INCR burst type
    }) begin
      `uvm_fatal("RAND_FAIL", "Slave stall test write item randomization crashed!")
    end


    write_tr.data[0] = 32'h1; write_tr.data[1] = 32'h2;
    write_tr.data[2] = 32'h3; write_tr.data[3] = 32'h4;
    write_tr.data[4] = 32'h5; write_tr.data[5] = 32'h6;
    write_tr.data[6] = 32'h7; write_tr.data[7] = 32'h8;

    finish_item(write_tr);


    // ========================================================================
    // STEP 2: LONG READ BURST FOR DATA PIN HANDSHAKE VERIFICATION
    // ========================================================================
    `uvm_info("SEQ_STALL", "Step 2: Preparing an 8-beat READ burst into stall zone...", UVM_LOW)
    read_tr = axi_item::type_id::create("read_tr_stall");

    start_item(read_tr);
    if (!read_tr.randomize() with {
      op    == READ;
      id    == 8'hC5;    // Same ID to match response queues
      addr  == 16'h3000; // Point to identical memory entries
      len   == 8'd7;     // 8 beats total
      size  == 3'b010;
      burst == 2'b01;
    }) begin
      `uvm_fatal("RAND_FAIL", "Slave stall test read item randomization crashed!")
    end
    finish_item(read_tr);


    `uvm_info("SEQ_STALL", "=============================================", UVM_LOW)
    `uvm_info("SEQ_STALL", "  SLAVE STALL BACKPRESSURE TEST FINISHED     ", UVM_LOW)
    `uvm_info("SEQ_STALL", "=============================================", UVM_LOW)
  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
