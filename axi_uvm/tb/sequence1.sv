class axi_sanity_sequence extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_sanity_sequence)

  function new(string name = "axi_sanity_sequence");
    super.new(name);
  endfunction

  virtual task body();
    axi_item write_tr;
    axi_item read_tr;

    `uvm_info("SEQ_SANITY", "=============================================", UVM_LOW)
    `uvm_info("SEQ_SANITY", "    STARTING AXI SLAVE BASIC SANITY CHECK    ", UVM_LOW)
    `uvm_info("SEQ_SANITY", "=============================================", UVM_LOW)

    // ========================================================================
    // CASE 1: STANDARD ALIGNED BURST (4 Beats, INCR Burst, 32-bit Width)
    // ========================================================================
    
    `uvm_info("SEQ_SANITY", "Step 1: Driving aligned 4-beat WRITE burst...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_tr");

    start_item(write_tr);
    write_tr.op    = WRITE;
    write_tr.id    = 8'hA1;     // Safe Unique Transaction ID
    write_tr.addr  = 16'h1000;  // Aligned to 4-byte boundary
    write_tr.len   = 8'd3;      // 4 beats total (len = beats - 1)
    write_tr.size  = 3'b010;    // 4 bytes per beat (32-bit)
    write_tr.burst = 2'b01;     // INCR type burst


    write_tr.data = new[4];
    write_tr.strb = new[4];

    write_tr.data[0] = 32'hDEADBEEF; write_tr.strb[0] = 4'b1111;
    write_tr.data[1] = 32'hCAFEFEED; write_tr.strb[1] = 4'b1111;
    write_tr.data[2] = 32'h12345678; write_tr.strb[2] = 4'b1111;
    write_tr.data[3] = 32'h87654321; write_tr.strb[3] = 4'b1111;
    finish_item(write_tr);

    `uvm_info("SEQ_SANITY", "Step 2: Executing matching READ burst to verify...", UVM_LOW)
    read_tr = axi_item::type_id::create("read_tr");

    start_item(read_tr);
    read_tr.op    = READ;
    read_tr.id    = 8'hA1;      // Match Write ID
    read_tr.addr  = 16'h1000;   // Target the same starting boundary
    read_tr.len   = 8'd3;       // Match length
    read_tr.size  = 3'b010;     // Match size
    read_tr.burst = 2'b01;      // Match type
    finish_item(read_tr);

    // ========================================================================
    // CASE 2: BASIC UNALIGNED TRANSFER (1 Beat, Address Offset 0x01)
    // ========================================================================
    
    `uvm_info("SEQ_SANITY", "Step 3: Driving unaligned single-beat WRITE...", UVM_LOW)
    write_tr = axi_item::type_id::create("write_tr_unaligned");

    start_item(write_tr);
    write_tr.op    = WRITE;
    write_tr.id    = 8'hB2;
    write_tr.addr  = 16'h2001;  // Unaligned starting offset!
    write_tr.len   = 8'd0;      // 1 beat transfer
    write_tr.size  = 3'b010;    // 32-bit master container allocation
    write_tr.burst = 2'b01;     // INCR

    write_tr.data = new[1];
    write_tr.strb = new[1];

    write_tr.data[0] = {8'hAA, 8'hBB, 8'hCC, 8'h00}; // Shift data onto active channels
    write_tr.strb[0] = 4'b1110;                      // Mask out Byte Lane 0
    finish_item(write_tr);

    `uvm_info("SEQ_SANITY", "Step 4: Executing matching unaligned READ...", UVM_LOW)
    read_tr = axi_item::type_id::create("read_tr_unaligned");

    start_item(read_tr);
    read_tr.op    = READ;
    read_tr.id    = 8'hB2;
    read_tr.addr  = 16'h2001;  // Unaligned target request pointer
    read_tr.len   = 8'd0;
    read_tr.size  = 3'b010;
    read_tr.burst = 2'b01;
    finish_item(read_tr);

    `uvm_info("SEQ_SANITY", "=============================================", UVM_LOW)
    `uvm_info("SEQ_SANITY", "     SANITY CHECK SEQUENCE FINISHED CLEANLY  ", UVM_LOW)
    `uvm_info("SEQ_SANITY", "=============================================", UVM_LOW)
  endtask
endclass
