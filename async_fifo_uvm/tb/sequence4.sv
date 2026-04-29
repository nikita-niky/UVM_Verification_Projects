class fifo_stress_seq extends uvm_sequence#(fifo_item);
  `uvm_object_utils(fifo_stress_seq)


  fifo_item tr;
  bit is_write_mode;

  function new(string name = "fifo_stress_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting fifo_stress_seq Stimulus for all ports...", UVM_LOW)
    tr= fifo_item::type_id::create("tr");
    repeat(2) begin
      `uvm_do_with(tr,{tr.wrst_n==1'b0; tr.rrst_n==1'b0; tr.winc==1'b0; tr.rinc==1'b0;})
    end
    #30;

    if(is_write_mode) begin
      `uvm_info("SEQ", "Starting stress test Writes", UVM_LOW)
      // Phase 1: Fill the FIFO (assuming depth 16)
      repeat(16) begin
        `uvm_do_with(tr, {tr.winc == 1'b1; tr.wrst_n == 1'b1;})
      end

      // Phase 2: Stay idle while the read side drains it
      repeat(16) begin
        `uvm_do_with(tr, {tr.winc == 1'b0; tr.wrst_n == 1'b1;})
      end

    end
    else begin
      `uvm_info("SEQ", "Starting stress test Reads", UVM_LOW)
      // Phase 1: Idle while the write side fills it
      repeat(16) begin
        `uvm_do_with(tr, {tr.rinc == 1'b0; tr.rrst_n == 1'b1;})
      end

      // Phase 2: Drain the FIFO immediately
      repeat(16) begin
        `uvm_do_with(tr, {tr.rinc == 1'b1; tr.rrst_n == 1'b1;})
      end  
    end

  endtask

endclass


