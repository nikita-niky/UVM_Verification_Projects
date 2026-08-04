/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class axi_burst_boundary_seq extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_burst_boundary_seq)

  function new(string name = "axi_burst_boundary_seq");
    super.new(name);
  endfunction

  virtual task body();
    axi_item write_tr;
    axi_item read_tr;

    `uvm_info("SEQ_BURST", "=============================================", UVM_LOW)
    `uvm_info("SEQ_BURST", " STARTING ADVANCED BURST BOUNDARY TEST       ", UVM_LOW)
    `uvm_info("SEQ_BURST", "=============================================", UVM_LOW)

    // ========================================================================
    // CASE A: FIXED BURST TESTING (FIFO-style, same address repeated)
    // ========================================================================
    `uvm_info("SEQ_BURST", "Sub-Test 1: Preparing FIXED burst (Repeated Addr)...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_fixed");

    start_item(write_tr);
    if (!write_tr.randomize() with {
      op    == WRITE;
      id    == 8'hE1;
      addr  == 16'h1100; // Stationary target FIFO address
      len   == 8'd2;     // 3 beats total
      size  == 3'b010;   // 4 bytes per beat (32-bit width)
      burst == 2'b00;    // FIXED burst type
    }) begin
      `uvm_fatal("RAND_FAIL", "FIXED write item randomization crashed!")
    end


    write_tr.data[0] = 32'h1111_1111; write_tr.strb[0] = 4'b1111;
    write_tr.data[1] = 32'h2222_2222; write_tr.strb[1] = 4'b1111;
    write_tr.data[2] = 32'h3333_3333; write_tr.strb[2] = 4'b1111;
    finish_item(write_tr);


    `uvm_info("SEQ_BURST", "Sub-Test 1 Verification: Launching FIXED read back...", UVM_LOW)
    read_tr = axi_item::type_id::create("read_fixed");

    start_item(read_tr);
    if (!read_tr.randomize() with {
      op    == READ;
      id    == 8'hE1;
      addr  == 16'h1100;
      len   == 8'd2;
      size  == 3'b010;
      burst == 2'b00;    // FIXED read back mode
    }) begin
      `uvm_fatal("RAND_FAIL", "FIXED read item randomization crashed!")
    end
    finish_item(read_tr);


    // ========================================================================
    // CASE B: WRAP BURST TESTING (Cacheline cache boundary rolling)
    // ========================================================================
    `uvm_info("SEQ_BURST", "Sub-Test 2: Preparing WRAP burst (Cacheline alignment rolling)...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_wrap");

    start_item(write_tr);
    if (!write_tr.randomize() with {
      op    == WRITE;
      id    == 8'hE2;
      addr  == 16'h200C; // Unaligned starting block offset near the 16-byte boundary edge
      len   == 8'd3;     // 4 beats total (Exact power of 2 required by AXI Specification)
      size  == 3'b010;   // 4 bytes per beat
      burst == 2'b10;    // WRAP burst type
    }) begin
      `uvm_fatal("RAND_FAIL", "WRAP write item randomization crashed!")
    end

    // Populate signature patterns safely
    write_tr.data[0] = 32'hAAAA_AAAA; write_tr.strb[0] = 4'b1111;
    write_tr.data[1] = 32'hBBBB_BBBB; write_tr.strb[1] = 4'b1111;
    write_tr.data[2] = 32'hCCCC_CCCC; write_tr.strb[2] = 4'b1111;
    write_tr.data[3] = 32'hDDDD_DDDD; write_tr.strb[3] = 4'b1111;
    finish_item(write_tr);



    `uvm_info("SEQ_BURST", "Sub-Test 2 Verification: Launching WRAP read back...", UVM_LOW)
    read_tr = axi_item::type_id::create("read_wrap");

    start_item(read_tr);
    if (!read_tr.randomize() with {
      op    == READ;
      id    == 8'hE2;
      addr  == 16'h200C;
      len   == 8'd3;
      size  == 3'b010;
      burst == 2'b10;    // WRAP read back mode
    }) begin
      `uvm_fatal("RAND_FAIL", "WRAP read item randomization crashed!")
    end
    finish_item(read_tr);



    `uvm_info("SEQ_BURST", "=============================================", UVM_LOW)
    `uvm_info("SEQ_BURST", "  FIXED & WRAP ALIGNMENT TESTING CLOSED SUCCESSFULLY", UVM_LOW)
    `uvm_info("SEQ_BURST", "=============================================", UVM_LOW)
  endtask
endclass

/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
