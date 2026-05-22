class axi_interleave_stress_seq extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_interleave_stress_seq)

  function new(string name = "axi_interleave_stress_seq");
    super.new(name);
  endfunction

  virtual task body();
    axi_item write_history[$];

    `uvm_info("SEQ_INT", "=============================================", UVM_LOW)
    `uvm_info("SEQ_INT", " STARTING PIPELINED INTERLEAVED STRESS TEST  ", UVM_LOW)
    `uvm_info("SEQ_INT", "=============================================", UVM_LOW)

    // ========================================================================
    // PHASE 1: Pipelined Write Stream (In-Order Unique IDs 0 to 4)
    // ========================================================================
    `uvm_info("SEQ_INT", "Phase 1: Blasting pipelined write sequence...", UVM_LOW)
    for (int i = 0; i < 5; i++) begin
      axi_item w_tr = axi_item::type_id::create($sformatf("w_tr_%0d", i));

      start_item(w_tr);

      if (!w_tr.randomize() with {
        op    == WRITE;
        id    == i;                  // Stacking overlapping unique transaction IDs
        addr  == 16'h1000 + (i*16);  // Distinct non-overlapping address pages
        len   == 8'd3;               // 4-beat bursts
        size  == 3'b010;             // 32-bit width
        burst == 2'b01;              // INCR mode
      }) begin
        `uvm_fatal("RAND_FAIL", "Pipelined write item randomization crashed!")
      end

      `uvm_info("SEQ_INT", $sformatf("Driving WRITE Address Phase -> ID:%0d | Addr:%0h", w_tr.id, w_tr.addr), UVM_MEDIUM)
      finish_item(w_tr);
      write_history.push_back(w_tr);    
    end


    // ========================================================================
    // PHASE 2: Pipelined Read Stream (In-Order Unique IDs 10 to 14)
    // ========================================================================
    `uvm_info("SEQ_INT", "Phase 2: Blasting pipelined read back verification...", UVM_LOW)
    while (write_history.size() > 0) begin
      axi_item w_match = write_history.pop_front();
      axi_item r_tr = axi_item::type_id::create("r_tr");

      start_item(r_tr);

      if (!r_tr.randomize() with {
        op    == READ;
        id    == w_match.id + 10;    // Dynamic Read IDs: 10, 11, 12, 13, 14
        addr  == w_match.addr;       // Target matching write address line offsets
        len   == w_match.len;        // Match burst length
        size  == w_match.size;       // Match size
        burst == w_match.burst;      // Match burst type
      }) begin
        `uvm_fatal("RAND_FAIL", "Pipelined read item randomization crashed!")
      end

      `uvm_info("SEQ_INT", $sformatf("Driving READ Address Phase  -> ID:%0d | Addr:%0h", r_tr.id, r_tr.addr), UVM_MEDIUM)
      finish_item(r_tr);
    end

    `uvm_info("SEQ_INT", "=============================================", UVM_LOW)
    `uvm_info("SEQ_INT", " INTERLEAVED STRESS RUN FINISHED COMPACTLY   ", UVM_LOW)
    `uvm_info("SEQ_INT", "=============================================", UVM_LOW)
  endtask
endclass
