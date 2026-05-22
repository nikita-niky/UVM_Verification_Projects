class axi_protocol_violation_seq extends uvm_sequence #(axi_item);
  `uvm_object_utils(axi_protocol_violation_seq)

  function new(string name = "axi_protocol_violation_seq");
    super.new(name);
  endfunction

  virtual task body();
    axi_item write_tr;

    `uvm_info("SEQ_VIOLATION", "=============================================", UVM_LOW)
    `uvm_info("SEQ_VIOLATION", " STARTING PIPELINE STAGNATION WATCHDOG TEST  ", UVM_LOW)
    `uvm_info("SEQ_VIOLATION", " [EXPECTED OUTCOME: DRV_WATCHDOG FATAL CRASH]", UVM_LOW)
    `uvm_info("SEQ_VIOLATION", "=============================================", UVM_LOW)

    write_tr = axi_item::type_id::create("write_tr_violating");

    start_item(write_tr);
    if (!write_tr.randomize() with {
      op    == WRITE;
      id    == 8'hFF;
      addr  == 16'h1500;
      len   == 8'd3;   // 4 beats total
      size  == 3'b010;  // 32-bit context
      burst == 2'b01;  // INCR
    }) begin
      `uvm_fatal("RAND_FAIL", "Violation sequence transaction randomization crashed!")
    end


    #5000;

    `uvm_info("SEQ_VIOLATION", "Dispatching violation transaction to driver port...", UVM_LOW)
    finish_item(write_tr);

  endtask
endclass
