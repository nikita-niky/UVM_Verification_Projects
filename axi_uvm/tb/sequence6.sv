class axi_sparse_strobe_seq extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_sparse_strobe_seq)

  function new(string name = "axi_sparse_strobe_seq");
    super.new(name);
  endfunction

  virtual task body();
    axi_item write_tr;
    axi_item read_tr;

    `uvm_info("SEQ_STROBE", "=============================================", UVM_LOW)
    `uvm_info("SEQ_STROBE", "  STARTING SPARSE STROBE & NARROW BURST TEST ", UVM_LOW)
    `uvm_info("SEQ_STROBE", "=============================================", UVM_LOW)

    // ========================================================================
    // STEP 1: INITIAL BACKGROUND FILL PATTERN (Pre-populate with 0xFFFFFFFF)
    // ========================================================================
    `uvm_info("SEQ_STROBE", "Step 1: Driving full-word WRITE background pattern to 16'h3500...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_background");

    start_item(write_tr);
    if (!write_tr.randomize() with {
      op    == WRITE;
      id    == 8'hD1;
      addr  == 16'h3500;
      len   == 8'd1;     // 2 beats total
      size  == 3'b010;   // 32-bit width
      burst == 2'b01;    // INCR
    }) begin
      `uvm_fatal("RAND_FAIL", "Background write item randomization crashed!")
    end

    write_tr.data[0] = 32'hFFFF_FFFF; write_tr.strb[0] = 4'b1111;
    write_tr.data[1] = 32'hFFFF_FFFF; write_tr.strb[1] = 4'b1111;
    finish_item(write_tr);


    // ========================================================================
    // STEP 2: DRIVE SPARSE OVERWRITE EXTREMES
    // ========================================================================
    `uvm_info("SEQ_STROBE", "Step 2: Injecting sparse overwrites (Beat 0 disabled, Beat 1 lane 1 only)...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_sparse");

    start_item(write_tr);
    if (!write_tr.randomize() with {
      op    == WRITE;
      id    == 8'hD1;
      addr  == 16'h3500;
      len   == 8'd1;     // 2 beats total
      size  == 3'b010;   // 32-bit width
      burst == 2'b01;    // INCR
    }) begin
      `uvm_fatal("RAND_FAIL", "Sparse overwrite item randomization crashed!")
    end

    // FORCE CUSTOM SPARSE STROBES (Overriding post_randomize choices safely)
    // Beat 0: All strobes off (0000) -> Data must not write to memory array
    write_tr.data[0] = 32'h0000_0000; 
    write_tr.strb[0] = 4'b0000; 

    // Beat 1: Only lane 1 on (0010) -> Writes only to Byte 1 location
    write_tr.data[1] = 32'hAAAA_BBBB; 
    write_tr.strb[1] = 4'b0010; 

    finish_item(write_tr);

    // ========================================================================
    // STEP 3: MATCH READ TO VERIFY HISTORICAL PRESERVATION
    // ========================================================================
    `uvm_info("SEQ_STROBE", "Step 3: Driving verification READ burst...", UVM_LOW)
    read_tr = axi_item::type_id::create("read_sparse_verify");

    start_item(read_tr);
    if (!read_tr.randomize() with {
      op    == READ;
      id    == 8'hD1;
      addr  == 16'h3500;
      len   == 8'd1;
      size  == 3'b010;
      burst == 2'b01;
    }) begin
      `uvm_fatal("RAND_FAIL", "Sparse verify read item randomization crashed!")
    end
    finish_item(read_tr);


    `uvm_info("SEQ_STROBE", "=============================================", UVM_LOW)
    `uvm_info("SEQ_STROBE", "  SPARSE STROBE TRANSFERS FINISHED CLEANLY   ", UVM_LOW)
    `uvm_info("SEQ_STROBE", "=============================================", UVM_LOW)
  endtask
endclass
